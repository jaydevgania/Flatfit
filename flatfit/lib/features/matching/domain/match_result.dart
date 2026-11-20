import 'package:flutter/foundation.dart';

/// Overall compatibility label based on 0-100 score.
enum CompatibilityLabel {
  greatMatch('Great Match'),
  goodMatch('Good Match'),
  worthAChat('Worth a Chat'),
  mightBeTricky('Might be Tricky');

  final String display;
  const CompatibilityLabel(this.display);

  static CompatibilityLabel fromScore(double score) {
    if (score >= 80.0) return CompatibilityLabel.greatMatch;
    if (score >= 60.0) return CompatibilityLabel.goodMatch;
    if (score >= 40.0) return CompatibilityLabel.worthAChat;
    return CompatibilityLabel.mightBeTricky;
  }
}

/// Result of evaluating compatibility between two users.
@immutable
class MatchResult {
  /// The other user's ID (or target profile ID).
  final String targetUserId;

  /// Compatibility score between 0.0 and 100.0.
  final double score;

  /// Topics where both users scored highly (>= 7/10).
  final List<String> compatibleTopics;

  /// Topics where the score was low (< 4/10).
  final List<String> watchOutTopics;

  /// Qualitative label based on score.
  final CompatibilityLabel label;

  /// Detailed per-topic score breakdown: topic -> score (0-10).
  final Map<String, double> topicScores;

  /// Timestamp when this match was computed.
  final DateTime computedAt;

  const MatchResult({
    required this.targetUserId,
    required this.score,
    required this.compatibleTopics,
    required this.watchOutTopics,
    required this.label,
    this.topicScores = const {},
    required this.computedAt,
  });

  Map<String, dynamic> toJson() => {
    'target_user_id': targetUserId,
    'score': score,
    'compatible_topics': compatibleTopics,
    'watch_out_topics': watchOutTopics,
    'label': label.display,
    'topic_scores': topicScores,
    'computed_at': computedAt.toIso8601String(),
  };

  factory MatchResult.fromJson(Map<String, dynamic> json) {
    final s = (json['score'] as num).toDouble();
    return MatchResult(
      targetUserId: json['target_user_id'] as String? ?? json['user_b'] as String? ?? '',
      score: s,
      compatibleTopics: (json['compatible_topics'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      watchOutTopics: (json['watch_out_topics'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      label: CompatibilityLabel.fromScore(s),
      topicScores: (json['topic_scores'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, (v as num).toDouble()),
          ) ??
          {},
      computedAt: json['computed_at'] != null
          ? DateTime.tryParse(json['computed_at'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
