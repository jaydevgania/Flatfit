import 'package:flutter/material.dart';

/// Animated progress indicator for the questionnaire quiz
class QuizProgressBar extends StatelessWidget {
  final int currentQuestionIndex;
  final int totalQuestions;
  final Color? barColor;

  const QuizProgressBar({
    super.key,
    required this.currentQuestionIndex,
    required this.totalQuestions,
    this.barColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = barColor ?? theme.colorScheme.primary;
    final progress = totalQuestions > 0
        ? (currentQuestionIndex + 1) / totalQuestions
        : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            tween: Tween<double>(begin: 0, end: progress.clamp(0.0, 1.0)),
            builder: (context, value, _) {
              return LinearProgressIndicator(
                value: value,
                minHeight: 6,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              );
            },
          ),
        ),
      ],
    );
  }
}
