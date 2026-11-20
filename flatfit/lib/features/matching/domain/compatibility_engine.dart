import 'dart:math';

enum AnswerImportance { niceToHave, important, dealBreaker }

class GeoLocation {
  final double latitude;
  final double longitude;
  const GeoLocation({required this.latitude, required this.longitude});
}

class Profile {
  final String id;
  final String fullName;
  final String gender;
  final String? genderPreference;
  final double budgetMin;
  final double budgetMax;
  final List<String> preferredLocalities;
  final GeoLocation location;
  final DateTime? moveInDate;

  const Profile({
    required this.id,
    required this.fullName,
    required this.gender,
    this.genderPreference,
    required this.budgetMin,
    required this.budgetMax,
    required this.preferredLocalities,
    required this.location,
    this.moveInDate,
  });
}

class UserAnswer {
  final String userId;
  final String questionId;
  final String topic;
  final String answer;
  final int optionIndex;
  final AnswerImportance importance;

  const UserAnswer({
    required this.userId,
    required this.questionId,
    required this.topic,
    required this.answer,
    this.optionIndex = 0,
    this.importance = AnswerImportance.niceToHave,
  });
}

enum CompatibilityLabel {
  greatMatch,
  goodMatch,
  worthAChat,
  mightBeTricky;

  static CompatibilityLabel fromScore(double score) {
    if (score >= 80) return greatMatch;
    if (score >= 60) return goodMatch;
    if (score >= 40) return worthAChat;
    return mightBeTricky;
  }
}

class CompatibilityWeights {
  final Map<String, double> topicMultipliers;
  const CompatibilityWeights({this.topicMultipliers = const {}});
}

class CompatibilityResult {
  final double score;
  final CompatibilityLabel label;
  final List<String> compatibleTopics;
  final List<String> watchOutTopics;

  const CompatibilityResult({
    required this.score,
    required this.label,
    required this.compatibleTopics,
    required this.watchOutTopics,
  });
}

class CompatibilityEngine {
  static CompatibilityResult? computeCompatibility({
    required Profile userA,
    required Profile userB,
    required List<UserAnswer> answersA,
    required List<UserAnswer> answersB,
    CompatibilityWeights weights = const CompatibilityWeights(),
  }) {
    if (userA.genderPreference != null &&
        userA.genderPreference != userB.gender) return null;
    if (userB.genderPreference != null &&
        userB.genderPreference != userA.gender) return null;

    final overlapStart = max(userA.budgetMin, userB.budgetMin);
    final overlapEnd = min(userA.budgetMax, userB.budgetMax);
    if (overlapEnd >= overlapStart) {
      final overlap = overlapEnd - overlapStart;
      final smallerSpan = min(userA.budgetMax - userA.budgetMin,
          userB.budgetMax - userB.budgetMin);
      if (smallerSpan > 0 && overlap / smallerSpan < 0.20) return null;
    } else {
      return null;
    }

    final sharedLocality = userA.preferredLocalities
        .toSet()
        .intersection(userB.preferredLocalities.toSet())
        .isNotEmpty;
    if (!sharedLocality) {
      final distance = calculateHaversineDistanceKm(
        userA.location.latitude,
        userA.location.longitude,
        userB.location.latitude,
        userB.location.longitude,
      );
      if (distance > 5.0) return null;
    }

    if (userA.moveInDate != null && userB.moveInDate != null) {
      final days = (userA.moveInDate!.difference(userB.moveInDate!).inHours / 24).abs();
      if (days > 30) return null;
    }

    final mapA = {for (final a in answersA) a.questionId: a};
    final mapB = {for (final a in answersB) a.questionId: bAnswer(a)};
    for (final q in mapA.keys) {
      final a = mapA[q]!;
      final b = mapB[q];
      if (b == null) continue;
      if ((a.topic == 'smoking' || a.topic == 'food') &&
          a.answer != b.answer &&
          (a.importance == AnswerImportance.dealBreaker ||
              b.importance == AnswerImportance.dealBreaker)) {
        return null;
      }
    }

    double earned = 0;
    double maximum = 0;
    final compatible = <String>[];
    final watchOut = <String>[];
    for (final q in mapA.keys) {
      final a = mapA[q]!;
      final b = mapB[q];
      if (b == null) continue;
      final diff = (a.optionIndex - b.optionIndex).abs();
      final topicScore = diff == 0 ? 10.0 : diff == 1 ? 6.0 : diff == 2 ? 2.0 : 0.0;
      final effective = a.importance.index > b.importance.index ? a.importance : b.importance;
      final baseWeight = effective == AnswerImportance.dealBreaker
          ? 3.0
          : effective == AnswerImportance.important
              ? 2.0
              : 1.0;
      final weight = baseWeight * (weights.topicMultipliers[a.topic] ?? 1.0);
      earned += topicScore * weight;
      maximum += 10.0 * weight;
      if (diff == 0) {
        compatible.add(a.topic);
      } else if (diff >= 2) {
        watchOut.add(a.topic);
      }
    }
    final score = maximum == 0 ? 100.0 : earned / maximum * 100.0;
    return CompatibilityResult(
      score: double.parse(score.toStringAsFixed(1)),
      label: CompatibilityLabel.fromScore(score),
      compatibleTopics: compatible,
      watchOutTopics: watchOut,
    );
  }

  static UserAnswer bAnswer(UserAnswer a) => a;

  static double calculateHaversineDistanceKm(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const earthRadiusKm = 6371.0;
    final dLat = _radians(lat2 - lat1);
    final dLon = _radians(lon2 - lon1);
    final p1 = lat1 * pi / 180;
    final p2 = lat2 * pi / 180;
    final h = sin(dLat / 2) * sin(dLat / 2) +
        cos(p1) * cos(p2) * sin(dLon / 2) * sin(dLon / 2);
    return earthRadiusKm * 2 * asin(sqrt(h));
  }

  static double _radians(double degrees) => degrees * pi / 180;
}
