import '../domain/question_model.dart';
import '../domain/answer_model.dart';
import 'questionnaire_data_source.dart';

/// Repository providing clean questionnaire operations.
class QuestionnaireRepository {
  final QuestionnaireDataSource _dataSource;

  QuestionnaireRepository(this._dataSource);

  /// Get current user ID.
  String? get currentUserId => _dataSource.currentUserId;

  /// Fetch all questions. Falls back to default seed questions if DB is empty.
  Future<List<Question>> getQuestions() async {
    try {
      final data = await _dataSource.fetchQuestions();
      if (data.isEmpty) {
        return QuestionnaireDataSource.defaultQuestions;
      }
      return data.map((json) => Question.fromJson(json)).toList();
    } catch (_) {
      // Offline fallback
      return QuestionnaireDataSource.defaultQuestions;
    }
  }

  /// Fetch existing answers for a user.
  Future<List<UserAnswer>> getUserAnswers(String userId) async {
    final data = await _dataSource.fetchUserAnswers(userId);
    return data.map((json) => UserAnswer.fromJson(json)).toList();
  }

  /// Fetch existing answers for the current user.
  Future<List<UserAnswer>> getCurrentUserAnswers() async {
    final userId = currentUserId;
    if (userId == null) return [];
    return getUserAnswers(userId);
  }

  /// Save or update a single answer.
  Future<UserAnswer> saveAnswer(UserAnswer answer) async {
    final json = await _dataSource.upsertAnswer(answer.toJson());
    return UserAnswer.fromJson(json);
  }

  /// Save all answers at once.
  Future<void> saveAllAnswers(List<UserAnswer> answers) async {
    final data = answers.map((a) => a.toJson()).toList();
    await _dataSource.upsertAnswers(data);
  }

  /// Clear all answers for the current user (retake quiz).
  Future<void> clearAnswers() async {
    final userId = currentUserId;
    if (userId == null) return;
    await _dataSource.deleteAllAnswers(userId);
  }

  /// Get number of answered questions for a user.
  Future<int> getAnsweredCount(String userId) async {
    final answers = await getUserAnswers(userId);
    return answers.length;
  }
}
