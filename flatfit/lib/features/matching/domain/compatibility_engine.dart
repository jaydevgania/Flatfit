import 'dart:math' as math;
import 'package:flutter/foundation.dart';

import 'match_filters.dart';
import 'match_result.dart';
import 'profile.dart';
import 'user_answer.dart';

export 'match_filters.dart';
export 'match_outcome.dart';
export 'match_result.dart';
export 'profile.dart';
export 'user_answer.dart';

/// Configurable weights for compatibility scoring.
/// Designed so an ML learning-to-rank model can supply learned weights.
class CompatibilityWeights {
  final double dealBreakerMultiplier;
  final double importantMultiplier;
  final double niceToHaveMultiplier;

  /// Optional per-topic ML importance weights (e.g. {'cleanliness': 1.4, 'sleep': 1.2}).
  final Map<String, double> topicMultipliers;

  const CompatibilityWeights({
    this.dealBreakerMultiplier = 3.0,
    this.importantMultiplier = 2.0,
    this.niceToHaveMultiplier = 1.0,
    this.topicMultipliers = const {},
  });

  static const defaults = CompatibilityWeights();

  double getMultiplier(AnswerImportance importance) {
    switch (importance) {
      case AnswerImportance.dealBreaker:
        return dealBreakerMultiplier;
      case AnswerImportance.important:
        return importantMultiplier;
      case AnswerImportance.niceToHave:
        return niceToHaveMultiplier;
    }
  }

  double getTopicMultiplier(String topic) {
    return topicMultipliers[topic.toLowerCase()] ?? 1.0;
  }
}

/// Pure functional Compatibility Engine for FlatFit.
///
/// Contains NO side effects, database calls, or UI code.
/// Deterministic and fully unit-testable.
class CompatibilityEngine {
  CompatibilityEngine._();

  /// Known ordinal option scales for topics to infer step differences
  /// when optionIndex is not explicitly supplied.
  static final Map<String, List<String>> _standardTopicScales = {
    'smoking': ['never', 'socially', 'regularly', 'daily'],
    'drinking': ['never', 'socially', 'regularly', 'frequent_parties'],
    'cleanliness': ['relaxed', 'moderate', 'very_tidy', 'neat_freak'],
    'sleep': ['early_bird', 'moderate', 'late_sleeper', 'night_owl'],
    'noise': ['silent', 'quiet', 'moderate', 'lively'],
    'guests': ['never', 'occasional_day', 'overnight_ok', 'frequent_parties'],
    'pets': ['no_pets', 'open_to_pets', 'pet_lover', 'has_pets'],
    'food': ['pure_veg', 'veg_eggs', 'occasional_non_veg', 'regular_non_veg'],
    'cooking': ['never', 'rarely', 'often', 'daily_chef'],
    'wfh': ['rarely', 'hybrid_1_2', 'hybrid_3_4', 'fully_remote'],
    'bills': ['strict_split', 'rough_split', 'turn_based', 'flexible'],
    'rent_punctuality': ['strict_1st', 'within_1st_week', 'flexible', 'relaxed'],
    'introvert_extrovert': ['introvert', 'ambivert_intro', 'ambivert_extro', 'extrovert'],
    'conflict': ['direct_talk', 'calm_wait', 'mediator', 'avoidant'],
  };

  /// Explicit deal-breaker conflict pairs (topic -> list of mutually exclusive sets).
  /// If User A picks an option from set 1 with deal_breaker, User B's answer
  /// must NOT be in set 2 (and vice versa).
  static final Map<String, List<Map<String, Set<String>>>> _dealBreakerConflictRules = {
    'smoking': [
      {
        'forbid': {'never', 'non_smoker', 'no_smoking', 'no'},
        'with': {'smoker', 'regularly', 'daily', 'chain_smoker', 'yes', 'frequent'},
      },
    ],
    'pets': [
      {
        'forbid': {'no_pets', 'strictly_no', 'allergic', 'no'},
        'with': {'has_pets', 'has_dog', 'has_cat', 'pet_owner', 'yes'},
      },
    ],
    'food': [
      {
        'forbid': {'pure_veg', 'pure_veg_only', 'jain', 'strictly_veg'},
        'with': {'regular_non_veg', 'non_veg', 'cooks_meat', 'eats_meat_at_home'},
      },
    ],
    'drinking': [
      {
        'forbid': {'never', 'teetotaler', 'strictly_no_alcohol', 'no'},
        'with': {'regularly', 'frequent_parties', 'heavy_drinker', 'daily'},
      },
    ],
    'guests': [
      {
        'forbid': {'never', 'no_guests', 'no_overnight_guests'},
        'with': {'frequent_parties', 'guests_always_welcome', 'party_house'},
      },
    ],
    'sleep': [
      {
        'forbid': {'early_bird', 'early_sleeper'},
        'with': {'night_owl', 'very_late_night'},
      },
    ],
    'cleanliness': [
      {
        'forbid': {'neat_freak', 'obsessive', 'very_tidy'},
        'with': {'relaxed', 'messy', 'unorganized'},
      },
    ],
    'noise': [
      {
        'forbid': {'silent', 'strictly_quiet'},
        'with': {'lively', 'loud_music', 'party_house'},
      },
    ],
  };

  /// Computes compatibility between two users.
  /// Returns `null` if any hard filter fails (instant reject).
  static MatchResult? computeCompatibility({
    required Profile userA,
    required Profile userB,
    required List<UserAnswer> answersA,
    required List<UserAnswer> answersB,
    HardFilters filters = HardFilters.defaults,
    CompatibilityWeights weights = CompatibilityWeights.defaults,
  }) {
    // -----------------------------------------------------------------
    // STEP 1 - HARD FILTERS (Any fail -> instant reject / null)
    // -----------------------------------------------------------------

    // 1. Budget overlap (>= minBudgetOverlapRatio, default 20%)
    if (!filters.budgetOverlaps(
      aMin: userA.budgetMin.toInt(),
      aMax: userA.budgetMax.toInt(),
      bMin: userB.budgetMin.toInt(),
      bMax: userB.budgetMax.toInt(),
    )) {
      return null;
    }

    // 2. Location matching: shared preferred locality OR geo-distance <= maxDistanceKm
    double? geoDistance;
    if (userA.location != null && userB.location != null) {
      geoDistance = calculateHaversineDistanceKm(
        userA.location!.latitude,
        userA.location!.longitude,
        userB.location!.latitude,
        userB.location!.longitude,
      );
    }

    // Combine single locality with preferredLocalities list for matching
    final localitiesA = [
      if (userA.locality != null && userA.locality!.isNotEmpty) userA.locality!,
      ...userA.preferredLocalities,
    ];
    final localitiesB = [
      if (userB.locality != null && userB.locality!.isNotEmpty) userB.locality!,
      ...userB.preferredLocalities,
    ];

    if (!filters.locationMatches(
      localitiesA: localitiesA,
      localitiesB: localitiesB,
      distanceKm: geoDistance,
    )) {
      return null;
    }

    // 3. Move-in window: within moveInWindowDays (default 30 days)
    if (!filters.moveInDatesAlign(userA.moveInDate, userB.moveInDate)) {
      return null;
    }

    // 4. Gender preference: bidirectional check
    if (!filters.genderPrefMatches(
      genderA: userA.gender,
      genderB: userB.gender,
      prefA: userA.genderPreference,
      prefB: userB.genderPreference,
    )) {
      return null;
    }

    // 5. Deal-breakers: check whether any deal-breaker answer conflicts
    if (filters.enforceDealBreakers) {
      if (hasDealBreakerConflict(answersA, answersB) ||
          hasDealBreakerConflict(answersB, answersA)) {
        return null;
      }
    }

    // -----------------------------------------------------------------
    // STEP 2 - WEIGHTED SCORE (0-100)
    // -----------------------------------------------------------------
    final answersMapA = <String, UserAnswer>{};
    for (final a in answersA) {
      // Index by questionId or topic
      final key = a.questionId.isNotEmpty ? a.questionId : a.topic.toLowerCase();
      answersMapA[key] = a;
    }

    final answersMapB = <String, UserAnswer>{};
    for (final b in answersB) {
      final key = b.questionId.isNotEmpty ? b.questionId : b.topic.toLowerCase();
      answersMapB[key] = b;
    }

    // Shared questions
    final sharedKeys = answersMapA.keys.where(answersMapB.containsKey).toList();

    // Fallback if no questions overlap at all
    if (sharedKeys.isEmpty) {
      return MatchResult(
        targetUserId: userB.id,
        score: 50.0,
        compatibleTopics: const [],
        watchOutTopics: const [],
        label: CompatibilityLabel.worthAChat,
        topicScores: const {},
        computedAt: DateTime.now(),
      );
    }

    double totalWeightedScore = 0.0;
    double maxPossibleWeightedScore = 0.0;

    final Map<String, double> topicScores = {};
    final List<String> compatibleTopics = [];
    final List<String> watchOutTopics = [];

    for (final key in sharedKeys) {
      final ansA = answersMapA[key]!;
      final ansB = answersMapB[key]!;
      final topic = ansA.topic.isNotEmpty ? ansA.topic : ansB.topic;

      // Base score: 10, 6, 2, or 0
      final baseScore = computeBaseScore(ansA, ansB, topic);
      topicScores[topic] = baseScore;

      // Bidirectional importance: take the MAX importance
      final maxImportance = getMaxImportance(ansA.importance, ansB.importance);
      final importanceWeight = weights.getMultiplier(maxImportance);
      final topicMLWeight = weights.getTopicMultiplier(topic);

      final combinedWeight = importanceWeight * topicMLWeight;

      totalWeightedScore += (baseScore * combinedWeight);
      maxPossibleWeightedScore += (10.0 * combinedWeight);

      // Topic categorization
      if (baseScore >= 7.0) {
        if (!compatibleTopics.contains(topic)) {
          compatibleTopics.add(topic);
        }
      } else if (baseScore < 4.0) {
        if (!watchOutTopics.contains(topic)) {
          watchOutTopics.add(topic);
        }
      }
    }

    final rawScore = maxPossibleWeightedScore > 0
        ? (totalWeightedScore / maxPossibleWeightedScore) * 100.0
        : 50.0;

    // Clamp score to [0.0, 100.0] and round to 1 decimal place
    final finalScore = (rawScore.clamp(0.0, 100.0) * 10).round() / 10.0;

    // -----------------------------------------------------------------
    // STEP 3 - EXPLAINABLE OUTPUT
    // -----------------------------------------------------------------
    final label = CompatibilityLabel.fromScore(finalScore);

    return MatchResult(
      targetUserId: userB.id,
      score: finalScore,
      compatibleTopics: compatibleTopics,
      watchOutTopics: watchOutTopics,
      label: label,
      topicScores: topicScores,
      computedAt: DateTime.now(),
    );
  }

  /// Calculates the base score (10, 6, 2, or 0) for two answers to the same topic.
  static double computeBaseScore(
    UserAnswer ansA,
    UserAnswer ansB,
    String topic,
  ) {
    // Exact match -> 10
    final valA = ansA.answer.trim().toLowerCase();
    final valB = ansB.answer.trim().toLowerCase();

    if (valA == valB) {
      return 10.0;
    }

    // Step calculation
    int? stepDifference;

    if (ansA.optionIndex != null && ansB.optionIndex != null) {
      stepDifference = (ansA.optionIndex! - ansB.optionIndex!).abs();
    } else {
      // Look up topic in standard scales
      final scale = _standardTopicScales[topic.toLowerCase()];
      if (scale != null) {
        final idxA = scale.indexOf(valA);
        final idxB = scale.indexOf(valB);
        if (idxA != -1 && idxB != -1) {
          stepDifference = (idxA - idxB).abs();
        }
      }
    }

    if (stepDifference != null) {
      if (stepDifference == 0) return 10.0;
      if (stepDifference == 1) return 6.0;
      if (stepDifference == 2) return 2.0;
      return 0.0; // 3 or more steps apart
    }

    // Fallback if not found on scale: check if they are known antonyms
    if (_areDirectOpposites(valA, valB, topic)) {
      return 0.0;
    }

    // Non-identical without scale mapping
    return 4.0;
  }

  /// Takes the higher priority of two answer importances.
  static AnswerImportance getMaxImportance(
    AnswerImportance a,
    AnswerImportance b,
  ) {
    if (a == AnswerImportance.dealBreaker || b == AnswerImportance.dealBreaker) {
      return AnswerImportance.dealBreaker;
    }
    if (a == AnswerImportance.important || b == AnswerImportance.important) {
      return AnswerImportance.important;
    }
    return AnswerImportance.niceToHave;
  }

  /// Checks if any deal-breaker answer from [source] conflicts with [target].
  static bool hasDealBreakerConflict(
    List<UserAnswer> source,
    List<UserAnswer> target,
  ) {
    final targetMap = <String, UserAnswer>{};
    for (final t in target) {
      final key = t.questionId.isNotEmpty ? t.questionId : t.topic.toLowerCase();
      targetMap[key] = t;
      targetMap[t.topic.toLowerCase()] = t;
    }

    for (final src in source) {
      if (src.importance != AnswerImportance.dealBreaker) continue;

      final key = src.questionId.isNotEmpty ? src.questionId : src.topic.toLowerCase();
      final tgt = targetMap[key] ?? targetMap[src.topic.toLowerCase()];
      if (tgt == null) continue;

      final topicKey = src.topic.toLowerCase();
      final srcVal = src.answer.trim().toLowerCase();
      final tgtVal = tgt.answer.trim().toLowerCase();

      // If they gave identical answers, they do not conflict
      if (srcVal == tgtVal) continue;

      // 1. Check explicit conflict rules
      final rules = _dealBreakerConflictRules[topicKey];
      if (rules != null) {
        for (final rule in rules) {
          final forbid = rule['forbid']!;
          final withSet = rule['with']!;

          if (forbid.contains(srcVal) && withSet.contains(tgtVal)) {
            return true;
          }
          if (withSet.contains(srcVal) && forbid.contains(tgtVal)) {
            return true;
          }
        }
      }

      // 2. Check scale step difference (>= 3 is extreme opposite)
      if (src.optionIndex != null && tgt.optionIndex != null) {
        final diff = (src.optionIndex! - tgt.optionIndex!).abs();
        if (diff >= 3) return true;
      } else {
        final scale = _standardTopicScales[topicKey];
        if (scale != null) {
          final iA = scale.indexOf(srcVal);
          final iB = scale.indexOf(tgtVal);
          if (iA != -1 && iB != -1 && (iA - iB).abs() >= 3) {
            return true;
          }
        }
      }

      // 3. Known direct opposites
      if (_areDirectOpposites(srcVal, tgtVal, topicKey)) {
        return true;
      }
    }

    return false;
  }

  static bool _areDirectOpposites(String a, String b, String topic) {
    const opposites = [
      {'yes', 'no'},
      {'true', 'false'},
      {'never', 'always'},
      {'never', 'daily'},
      {'early_bird', 'night_owl'},
      {'pure_veg', 'non_veg'},
      {'no_pets', 'has_pets'},
      {'no_smoking', 'smoker'},
    ];

    for (final pair in opposites) {
      if (pair.contains(a) && pair.contains(b) && a != b) {
        return true;
      }
    }
    return false;
  }

  /// Haversine formula to compute distance in kilometers between two geo coordinates.
  static double calculateHaversineDistanceKm(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadiusKm = 6371.0;
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_deg2rad(lat1)) *
            math.cos(_deg2rad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadiusKm * c;
  }

  static double _deg2rad(double deg) => deg * (math.pi / 180.0);
}
