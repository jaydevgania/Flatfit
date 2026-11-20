import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/answer_model.dart';
import '../../domain/importance_level.dart';
import '../../domain/question_model.dart';
import '../../data/questionnaire_data_source.dart';
import '../../data/questionnaire_repository.dart';
import '../widgets/quiz_progress_bar.dart';
import '../../profile/presentation/providers/profile_provider.dart';

/// Questionnaire data source provider
final questionnaireDataSourceProvider = Provider<QuestionnaireDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return QuestionnaireDataSource(client);
});

/// Questionnaire repository provider
final questionnaireRepositoryProvider = Provider<QuestionnaireRepository>((ref) {
  final dataSource = ref.watch(questionnaireDataSourceProvider);
  return QuestionnaireRepository(dataSource);
});

/// State of the active questionnaire
class QuestionnaireState {
  final bool isLoading;
  final bool isSubmitting;
  final List<Question> questions;
  final Map<String, UserAnswer> answers; // questionId -> UserAnswer
  final int currentIndex;
  final String? errorMessage;
  final bool isCompleted;

  const QuestionnaireState({
    this.isLoading = true,
    this.isSubmitting = false,
    this.questions = const [],
    this.answers = const {},
    this.currentIndex = 0,
    this.errorMessage,
    this.isCompleted = false,
  });

  Question? get currentQuestion =>
      questions.isNotEmpty && currentIndex < questions.length
          ? questions[currentIndex]
          : null;

  UserAnswer? get currentAnswer =>
      currentQuestion != null ? answers[currentQuestion!.id] : null;

  int get totalQuestions => questions.length;
  int get answeredCount => answers.length;
  double get progress =>
      totalQuestions > 0 ? (currentIndex + 1) / totalQuestions : 0.0;
  bool get hasAnsweredCurrent => currentAnswer != null;
  bool get isLastQuestion => currentIndex == totalQuestions - 1;

  QuestionnaireState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    List<Question>? questions,
    Map<String, UserAnswer>? answers,
    int? currentIndex,
    String? errorMessage,
    bool? isCompleted,
  }) {
    return QuestionnaireState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      questions: questions ?? this.questions,
      answers: answers ?? this.answers,
      currentIndex: currentIndex ?? this.currentIndex,
      errorMessage: errorMessage,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

/// State notifier managing quiz progress and answer tracking
class QuestionnaireNotifier extends StateNotifier<QuestionnaireState> {
  final QuestionnaireRepository _repository;

  QuestionnaireNotifier(this._repository) : super(const QuestionnaireState()) {
    initQuiz();
  }

  /// Initialize and load questions and prior answers
  Future<void> initQuiz() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final questions = await _repository.getQuestions();
      final priorAnswers = await _repository.getCurrentUserAnswers();

      final answersMap = <String, UserAnswer>{};
      for (final a in priorAnswers) {
        answersMap[a.questionId] = a;
      }

      state = state.copyWith(
        isLoading: false,
        questions: questions,
        answers: answersMap,
        currentIndex: 0,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        questions: QuestionnaireDataSource.defaultQuestions,
        errorMessage: e.toString(),
      );
    }
  }

  /// Select answer option and optionally advance
  void selectAnswer(String option) {
    final currentQ = state.currentQuestion;
    if (currentQ == null) return;

    final userId = _repository.currentUserId ?? 'guest_user';
    final existing = state.answers[currentQ.id];

    final updatedAnswer = UserAnswer(
      userId: userId,
      questionId: currentQ.id,
      answer: option,
      importance: existing?.importance ?? ImportanceLevel.important,
    );

    final updatedMap = Map<String, UserAnswer>.from(state.answers);
    updatedMap[currentQ.id] = updatedAnswer;

    state = state.copyWith(answers: updatedMap);
  }

  /// Change importance level for the current question
  void setImportance(ImportanceLevel level) {
    final currentQ = state.currentQuestion;
    if (currentQ == null) return;

    final existing = state.answers[currentQ.id];
    if (existing == null) return;

    final updatedAnswer = existing.copyWith(importance: level);
    final updatedMap = Map<String, UserAnswer>.from(state.answers);
    updatedMap[currentQ.id] = updatedAnswer;

    state = state.copyWith(answers: updatedMap);
  }

  /// Set importance for a specific question (used in review screen)
  void setImportanceForQuestion(String questionId, ImportanceLevel level) {
    final existing = state.answers[questionId];
    if (existing == null) return;

    final updatedAnswer = existing.copyWith(importance: level);
    final updatedMap = Map<String, UserAnswer>.from(state.answers);
    updatedMap[questionId] = updatedAnswer;

    state = state.copyWith(answers: updatedMap);
  }

  /// Advance to next question
  void nextQuestion() {
    if (state.currentIndex < state.questions.length - 1) {
      state = state.copyWith(currentIndex: state.currentIndex + 1);
    } else {
      state = state.copyWith(isCompleted: true);
    }
  }

  /// Go back to previous question
  void previousQuestion() {
    if (state.currentIndex > 0) {
      state = state.copyWith(currentIndex: state.currentIndex - 1);
    }
  }

  /// Jump to a specific question (e.g. from review screen)
  void goToQuestion(int index) {
    if (index >= 0 && index < state.questions.length) {
      state = state.copyWith(
        currentIndex: index,
        isCompleted: false,
      );
    }
  }

  /// Save all answers to Supabase
  Future<bool> saveAnswers() async {
    state = state.copyWith(isSubmitting: true, errorMessage: null);

    try {
      final answersList = state.answers.values.toList();
      await _repository.saveAllAnswers(answersList);

      state = state.copyWith(
        isSubmitting: false,
        isCompleted: true,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Reset/retake the quiz
  Future<void> retakeQuiz() async {
    await _repository.clearAnswers();
    state = state.copyWith(
      answers: {},
      currentIndex: 0,
      isCompleted: false,
    );
  }
}

/// Provider for questionnaire state
final questionnaireProvider =
    StateNotifierProvider<QuestionnaireNotifier, QuestionnaireState>((ref) {
  final repository = ref.watch(questionnaireRepositoryProvider);
  return QuestionnaireNotifier(repository);
});
