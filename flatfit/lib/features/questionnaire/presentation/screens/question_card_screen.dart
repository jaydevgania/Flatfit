import 'package:flutter/material.dart';
import '../../domain/importance_level.dart';
import '../../domain/question_model.dart';
import '../../domain/answer_model.dart';
import '../widgets/answer_option_chip.dart';
import '../widgets/importance_selector.dart';
import '../widgets/topic_header.dart';

/// Single question presentation with options and importance selector
class QuestionCardScreen extends StatelessWidget {
  final Question question;
  final UserAnswer? currentAnswer;
  final int questionNumber;
  final int totalQuestions;
  final ValueChanged<String> onSelectOption;
  final ValueChanged<ImportanceLevel> onSelectImportance;

  const QuestionCardScreen({
    super.key,
    required this.question,
    required this.currentAnswer,
    required this.questionNumber,
    required this.totalQuestions,
    required this.onSelectOption,
    required this.onSelectImportance,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedOption = currentAnswer?.answer;
    final topicColor = Color(question.topic.colorValue);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Topic Header
          TopicHeader(
            topic: question.topic,
            questionNumber: questionNumber,
            totalQuestions: totalQuestions,
          ),
          const SizedBox(height: 24),

          // Question Text
          Text(
            question.questionText,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              height: 1.3,
            ),
          ),
          if (question.questionTextHi != null) ...[
            const SizedBox(height: 6),
            Text(
              question.questionTextHi!,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          const SizedBox(height: 24),

          // Options List (Large clickable chips)
          ...question.options.map((option) {
            final isSelected = selectedOption == option;
            return AnswerOptionChip(
              text: option,
              isSelected: isSelected,
              activeColor: topicColor,
              onTap: () => onSelectOption(option),
            );
          }),
          const SizedBox(height: 24),

          // Importance Selector (appears once an answer is chosen)
          AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: selectedOption != null ? 1.0 : 0.0,
            child: selectedOption != null
                ? Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ImportanceSelector(
                      selectedImportance:
                          currentAnswer?.importance ?? ImportanceLevel.important,
                      onSelected: onSelectImportance,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
