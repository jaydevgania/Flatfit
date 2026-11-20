import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/questionnaire_provider.dart';
import '../widgets/quiz_progress_bar.dart';
import 'question_card_screen.dart';
import 'questionnaire_complete_screen.dart';

/// Main quiz screen orchestrating the 20 lifestyle questions
class QuestionnaireScreen extends ConsumerStatefulWidget {
  const QuestionnaireScreen({super.key});

  @override
  ConsumerState<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends ConsumerState<QuestionnaireScreen> {
  void _handleNext() {
    final state = ref.read(questionnaireProvider);
    final notifier = ref.read(questionnaireProvider.notifier);

    if (state.isLastQuestion) {
      notifier.nextQuestion(); // Marks isCompleted = true
    } else {
      notifier.nextQuestion();
    }
  }

  void _handleBack() {
    final state = ref.read(questionnaireProvider);
    final notifier = ref.read(questionnaireProvider.notifier);

    if (state.currentIndex > 0) {
      notifier.previousQuestion();
    } else {
      _confirmExit();
    }
  }

  void _confirmExit() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Exit Lifestyle Quiz?'),
        content: const Text(
          'Your answered questions will be saved. You can complete the rest anytime.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Continue Quiz'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/home');
              }
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(questionnaireProvider);
    final notifier = ref.read(questionnaireProvider.notifier);

    // If quiz is completed, show the completion / summary screen
    if (state.isCompleted) {
      return const QuestionnaireCompleteScreen();
    }

    if (state.isLoading) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading lifestyle questions...'),
            ],
          ),
        ),
      );
    }

    final currentQ = state.currentQuestion;
    if (currentQ == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No questions available.'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => notifier.initQuiz(),
                child: const Text('Reload'),
              ),
            ],
          ),
        ),
      );
    }

    final hasAnswered = state.hasAnsweredCurrent;

    return WillPopScope(
      onWillPop: () async {
        _handleBack();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _handleBack,
          ),
          title: const Text(
            'Lifestyle Quiz',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () => notifier.nextQuestion(),
              child: const Text('Skip'),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(6),
            child: QuizProgressBar(
              currentQuestionIndex: state.currentIndex,
              totalQuestions: state.totalQuestions,
              barColor: Color(currentQ.topic.colorValue),
            ),
          ),
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, animation) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.05, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: KeyedSubtree(
            key: ValueKey(currentQ.id),
            child: QuestionCardScreen(
              question: currentQ,
              currentAnswer: state.currentAnswer,
              questionNumber: state.currentIndex + 1,
              totalQuestions: state.totalQuestions,
              onSelectOption: (option) {
                notifier.selectAnswer(option);
              },
              onSelectImportance: (importance) {
                notifier.setImportance(importance);
              },
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: hasAnswered ? _handleNext : null,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.isLastQuestion ? 'Review Answers 🎉' : 'Next Question',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
