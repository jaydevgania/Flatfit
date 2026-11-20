import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/importance_level.dart';
import '../../domain/lifestyle_topics.dart';
import '../../domain/question_model.dart';
import '../providers/questionnaire_provider.dart';

/// Screen summarizing answers grouped by topic, allowing editing and final submission
class QuestionnaireCompleteScreen extends ConsumerWidget {
  const QuestionnaireCompleteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(questionnaireProvider);
    final notifier = ref.read(questionnaireProvider.notifier);

    // Group questions by LifestyleTopic
    final groupedQuestions = <LifestyleTopic, List<Question>>{};
    for (final q in state.questions) {
      groupedQuestions.putIfAbsent(q.topic, () => []).add(q);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Summary'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => notifier.goToQuestion(state.questions.length - 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Celebration Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withValues(alpha: 0.15),
                    Colors.purple.shade50,
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text('🎯', style: TextStyle(fontSize: 28)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Lifestyle Profile Ready!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${state.answeredCount} of ${state.totalQuestions} questions answered. You can review or tweak any answers below.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'Your Answers by Lifestyle Topic',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Grouped Answers
            ...groupedQuestions.entries.map((entry) {
              final topic = entry.key;
              final questions = entry.value;
              final topicColor = Color(topic.colorValue);

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
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
                child: Theme(
                  data: theme.copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: topicColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Text(topic.emoji, style: const TextStyle(fontSize: 18)),
                    ),
                    title: Text(
                      topic.label,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      '${questions.where((q) => state.answers.containsKey(q.id)).length}/${questions.length} answered',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                    children: questions.map((q) {
                      final answer = state.answers[q.id];
                      final qIndex = state.questions.indexOf(q);

                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.grey.shade100),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    q.questionText,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  if (answer != null) ...[
                                    Text(
                                      answer.answer,
                                      style: TextStyle(
                                        color: theme.colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Color(answer.importance.colorValue)
                                                .withValues(alpha: 0.12),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            '${answer.importance.emoji} ${answer.importance.label}',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: Color(
                                                  answer.importance.colorValue),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ] else
                                    const Text(
                                      'Not answered',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () => notifier.goToQuestion(qIndex),
                              child: const Text('Edit'),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            }),

            const SizedBox(height: 24),

            // Save Answers CTA
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: state.isSubmitting
                    ? null
                    : () async {
                        final ok = await notifier.saveAnswers();
                        if (context.mounted) {
                          if (ok) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Lifestyle quiz answers saved! 🚀'),
                              ),
                            );
                            context.go('/matches');
                          } else {
                            // Offline or preview fallback
                            context.go('/matches');
                          }
                        }
                      },
                icon: state.isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.check_circle_outline),
                label: Text(
                  state.isSubmitting
                      ? 'Saving Answers...'
                      : 'Save Answers & Find Flatmates',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Retake Quiz option
            Center(
              child: TextButton.icon(
                onPressed: () async {
                  await notifier.retakeQuiz();
                },
                icon: const Icon(Icons.refresh, size: 18, color: Colors.grey),
                label: const Text(
                  'Retake Quiz from Start',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
