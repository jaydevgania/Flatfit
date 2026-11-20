import 'package:flutter/material.dart';

/// Widget displaying explainable match reasons:
/// "Compatible on: Cleanliness, Sleep, Smoking"
/// "Watch out: Weekend Socializing"
class CompatibilityBreakdown extends StatelessWidget {
  final List<String> compatibleTopics;
  final List<String> watchOutTopics;
  final Map<String, double>? topicScores;
  final bool isCompact;

  const CompatibilityBreakdown({
    super.key,
    required this.compatibleTopics,
    required this.watchOutTopics,
    this.topicScores,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return _buildCompactView();
    }
    return _buildExpandedCard();
  }

  Widget _buildCompactView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (compatibleTopics.isNotEmpty) ...[
          Row(
            children: [
              const Icon(Icons.check_circle_rounded, size: 14, color: Color(0xFF10B981)),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Compatible on: ${compatibleTopics.take(3).join(', ')}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF047857),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
        if (watchOutTopics.isNotEmpty) ...[
          const SizedBox(height: 3),
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded, size: 14, color: Color(0xFFF59E0B)),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Watch out: ${watchOutTopics.take(2).join(', ')}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFB45309),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildExpandedCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.insights_rounded, size: 18, color: Color(0xFF4F46E5)),
              SizedBox(width: 8),
              Text(
                'Compatibility Insights',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Compatible topics section
          if (compatibleTopics.isNotEmpty) ...[
            const Text(
              'High Alignment',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF065F46),
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: compatibleTopics.map((topic) {
                return _buildPill(
                  topic: topic,
                  isCompatible: true,
                  score: topicScores?[topic],
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
          ],

          // Watch out topics section
          if (watchOutTopics.isNotEmpty) ...[
            const Text(
              'Topics to Discuss',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF9A3412),
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: watchOutTopics.map((topic) {
                return _buildPill(
                  topic: topic,
                  isCompatible: false,
                  score: topicScores?[topic],
                );
              }).toList(),
            ),
          ],

          if (compatibleTopics.isEmpty && watchOutTopics.isEmpty)
            const Text(
              'Moderate alignment across all answered questionnaire topics.',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF6B7280),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPill({
    required String topic,
    required bool isCompatible,
    double? score,
  }) {
    final bgColor = isCompatible ? const Color(0xFFD1FAE5) : const Color(0xFFFEF3C7);
    final textColor = isCompatible ? const Color(0xFF065F46) : const Color(0xFF92400E);
    final icon = isCompatible ? Icons.check_circle_outline_rounded : Icons.info_outline_rounded;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            topic,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          if (score != null) ...[
            const SizedBox(width: 4),
            Text(
              '(${score.toInt()}/10)',
              style: TextStyle(
                fontSize: 11,
                color: textColor.withOpacity(0.8),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
