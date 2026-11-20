import 'package:flutter/material.dart';
import '../../domain/lifestyle_topics.dart';

/// Header widget displaying the current lifestyle topic's icon, title, and color badge
class TopicHeader extends StatelessWidget {
  final LifestyleTopic topic;
  final int questionNumber;
  final int totalQuestions;

  const TopicHeader({
    super.key,
    required this.topic,
    required this.questionNumber,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    final topicColor = Color(topic.colorValue);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Topic Pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: topicColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: topicColor.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(topic.emoji, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text(
                topic.label.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                  color: topicColor,
                ),
              ),
            ],
          ),
        ),

        // Question count tag
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$questionNumber / $totalQuestions',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
        ),
      ],
    );
  }
}
