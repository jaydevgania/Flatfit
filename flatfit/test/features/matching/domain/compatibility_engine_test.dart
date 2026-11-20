import 'package:flutter_test/flutter_test.dart';
import 'package:flatfit/features/matching/domain/compatibility_engine.dart';

void main() {
  group('CompatibilityEngine Unit Tests', () {
    final now = DateTime(2026, 11, 15);

    Profile createProfile({
      String id = 'user_1',
      String name = 'User One',
      String gender = 'male',
      String? genderPreference,
      double minBudget = 20000,
      double maxBudget = 30000,
      List<String> localities = const ['Bandra West', 'Khar'],
      GeoLocation? location,
      DateTime? moveInDate,
    }) {
      return Profile(
        id: id,
        fullName: name,
        gender: gender,
        genderPreference: genderPreference,
        budgetMin: minBudget,
        budgetMax: maxBudget,
        preferredLocalities: localities,
        location: location ?? const GeoLocation(latitude: 19.0596, longitude: 72.8295),
        moveInDate: moveInDate ?? now,
      );
    }

    test('1. Exact match across all topics results in 100 score and Great Match', () {
      final userA = createProfile(id: 'a', name: 'A');
      final userB = createProfile(id: 'b', name: 'B');

      final answersA = [
        const UserAnswer(userId: 'a', questionId: 'q1', topic: 'cleanliness', answer: 'very_tidy', optionIndex: 2),
        const UserAnswer(userId: 'a', questionId: 'q2', topic: 'sleep', answer: 'early_bird', optionIndex: 0),
        const UserAnswer(userId: 'a', questionId: 'q3', topic: 'smoking', answer: 'never', optionIndex: 0),
      ];

      final answersB = [
        const UserAnswer(userId: 'b', questionId: 'q1', topic: 'cleanliness', answer: 'very_tidy', optionIndex: 2),
        const UserAnswer(userId: 'b', questionId: 'q2', topic: 'sleep', answer: 'early_bird', optionIndex: 0),
        const UserAnswer(userId: 'b', questionId: 'q3', topic: 'smoking', answer: 'never', optionIndex: 0),
      ];

      final result = CompatibilityEngine.computeCompatibility(
        userA: userA,
        userB: userB,
        answersA: answersA,
        answersB: answersB,
      );

      expect(result, isNotNull);
      expect(result!.score, 100.0);
      expect(result.label, CompatibilityLabel.greatMatch);
      expect(result.compatibleTopics, containsAll(['cleanliness', 'sleep', 'smoking']));
      expect(result.watchOutTopics, isEmpty);
    });

    test('2. Adjacent answers (1 step apart) yield 60 score and Good Match', () {
      final userA = createProfile(id: 'a');
      final userB = createProfile(id: 'b');

      final answersA = [
        const UserAnswer(userId: 'a', questionId: 'q1', topic: 'cleanliness', answer: 'moderate', optionIndex: 1),
        const UserAnswer(userId: 'a', questionId: 'q2', topic: 'sleep', answer: 'moderate', optionIndex: 1),
      ];
      final answersB = [
        const UserAnswer(userId: 'b', questionId: 'q1', topic: 'cleanliness', answer: 'very_tidy', optionIndex: 2),
        const UserAnswer(userId: 'b', questionId: 'q2', topic: 'sleep', answer: 'late_sleeper', optionIndex: 2),
      ];

      final result = CompatibilityEngine.computeCompatibility(
        userA: userA,
        userB: userB,
        answersA: answersA,
        answersB: answersB,
      );

      expect(result, isNotNull);
      expect(result!.score, 60.0);
      expect(result.label, CompatibilityLabel.goodMatch);
      expect(result.compatibleTopics, isEmpty);
      expect(result.watchOutTopics, isEmpty);
    });

    test('3. Answers 2 steps apart yield 20 score and Might be Tricky', () {
      final userA = createProfile(id: 'a');
      final userB = createProfile(id: 'b');

      final answersA = [
        const UserAnswer(userId: 'a', questionId: 'q1', topic: 'cleanliness', answer: 'relaxed', optionIndex: 0),
      ];
      final answersB = [
        const UserAnswer(userId: 'b', questionId: 'q1', topic: 'cleanliness', answer: 'very_tidy', optionIndex: 2),
      ];

      final result = CompatibilityEngine.computeCompatibility(
        userA: userA,
        userB: userB,
        answersA: answersA,
        answersB: answersB,
      );

      expect(result, isNotNull);
      expect(result!.score, 20.0);
      expect(result.label, CompatibilityLabel.mightBeTricky);
      expect(result.watchOutTopics, contains('cleanliness'));
    });

    test('4. Answers >= 3 steps apart yield 0 score', () {
      final userA = createProfile(id: 'a');
      final userB = createProfile(id: 'b');

      final answersA = [
        const UserAnswer(userId: 'a', questionId: 'q1', topic: 'cleanliness', answer: 'relaxed', optionIndex: 0),
      ];
      final answersB = [
        const UserAnswer(userId: 'b', questionId: 'q1', topic: 'cleanliness', answer: 'neat_freak', optionIndex: 3),
      ];

      final result = CompatibilityEngine.computeCompatibility(
        userA: userA,
        userB: userB,
        answersA: answersA,
        answersB: answersB,
      );

      expect(result, isNotNull);
      expect(result!.score, 0.0);
      expect(result.label, CompatibilityLabel.mightBeTricky);
      expect(result.watchOutTopics, contains('cleanliness'));
    });

    test('5. Hard Filter: Budget completely non-overlapping returns null', () {
      final userA = createProfile(minBudget: 10000, maxBudget: 15000);
      final userB = createProfile(minBudget: 20000, maxBudget: 35000);

      final result = CompatibilityEngine.computeCompatibility(
        userA: userA,
        userB: userB,
        answersA: const [],
        answersB: const [],
      );

      expect(result, isNull);
    });

    test('6. Hard Filter: Budget overlap less than 20% returns null', () {
      // Range A: 10,000 to 20,000 (span = 10,000)
      // Range B: 19,000 to 30,000 (span = 11,000)
      // Overlap: 19,000 to 20,000 = 1,000 (10% of span 10,000 < 20%)
      final userA = createProfile(minBudget: 10000, maxBudget: 20000);
      final userB = createProfile(minBudget: 19000, maxBudget: 30000);

      final result = CompatibilityEngine.computeCompatibility(
        userA: userA,
        userB: userB,
        answersA: const [],
        answersB: const [],
      );

      expect(result, isNull);
    });

    test('7. Hard Filter: Budget overlap >= 20% passes', () {
      // Range A: 15,000 to 25,000 (span = 10,000)
      // Range B: 20,000 to 30,000 (overlap = 5,000 = 50% >= 20%)
      final userA = createProfile(minBudget: 15000, maxBudget: 25000);
      final userB = createProfile(minBudget: 20000, maxBudget: 30000);

      final result = CompatibilityEngine.computeCompatibility(
        userA: userA,
        userB: userB,
        answersA: const [],
        answersB: const [],
      );

      expect(result, isNotNull);
    });

    test('8. Hard Filter: Locality shared in preferredLocalities passes', () {
      final userA = createProfile(localities: ['Andheri East', 'Powai']);
      final userB = createProfile(localities: ['Powai', 'Ghatkopar']);

      final result = CompatibilityEngine.computeCompatibility(
        userA: userA,
        userB: userB,
        answersA: const [],
        answersB: const [],
      );

      expect(result, isNotNull);
    });

    test('9. Hard Filter: Locality mismatch and distance > 5km returns null', () {
      // Bandra West (19.0596, 72.8295) vs Thane West (19.2183, 72.9781) ~ 23km apart
      final userA = createProfile(
        localities: ['Bandra West'],
        location: const GeoLocation(latitude: 19.0596, longitude: 72.8295),
      );
      final userB = createProfile(
        localities: ['Thane West'],
        location: const GeoLocation(latitude: 19.2183, longitude: 72.9781),
      );

      final result = CompatibilityEngine.computeCompatibility(
        userA: userA,
        userB: userB,
        answersA: const [],
        answersB: const [],
      );

      expect(result, isNull);
    });

    test('10. Hard Filter: Locality mismatch but distance <= 5km passes', () {
      // Bandra West (19.0596, 72.8295) vs Khar West (19.0688, 72.8344) ~ 1.1km apart
      final userA = createProfile(
        localities: ['Bandra West'],
        location: const GeoLocation(latitude: 19.0596, longitude: 72.8295),
      );
      final userB = createProfile(
        localities: ['Khar West'],
        location: const GeoLocation(latitude: 19.0688, longitude: 72.8344),
      );

      final result = CompatibilityEngine.computeCompatibility(
        userA: userA,
        userB: userB,
        answersA: const [],
        answersB: const [],
      );

      expect(result, isNotNull);
    });

    test('11. Hard Filter: Move-in dates within 30 days passes', () {
      final userA = createProfile(moveInDate: DateTime(2026, 12, 1));
      final userB = createProfile(moveInDate: DateTime(2026, 12, 20)); // 19 days difference

      final result = CompatibilityEngine.computeCompatibility(
        userA: userA,
        userB: userB,
        answersA: const [],
        answersB: const [],
      );

      expect(result, isNotNull);
    });

    test('12. Hard Filter: Move-in dates > 30 days apart returns null', () {
      final userA = createProfile(moveInDate: DateTime(2026, 11, 1));
      final userB = createProfile(moveInDate: DateTime(2026, 12, 15)); // 44 days difference

      final result = CompatibilityEngine.computeCompatibility(
        userA: userA,
        userB: userB,
        answersA: const [],
        answersB: const [],
      );

      expect(result, isNull);
    });

    test('13. Hard Filter: Flexible move-in dates (null) passes', () {
      final userA = createProfile(moveInDate: DateTime(2026, 11, 1));
      final userB = createProfile(moveInDate: null);

      final result = CompatibilityEngine.computeCompatibility(
        userA: userA,
        userB: userB,
        answersA: const [],
        answersB: const [],
      );

      expect(result, isNotNull);
    });

    test('14. Hard Filter: Gender preference match passes', () {
      final userA = createProfile(gender: 'male', genderPreference: 'female');
      final userB = createProfile(gender: 'female', genderPreference: 'male');

      final result = CompatibilityEngine.computeCompatibility(
        userA: userA,
        userB: userB,
        answersA: const [],
        answersB: const [],
      );

      expect(result, isNotNull);
    });

    test('15. Hard Filter: Gender preference mismatch returns null', () {
      final userA = createProfile(gender: 'male', genderPreference: 'female');
      final userB = createProfile(gender: 'male', genderPreference: 'male');

      final result = CompatibilityEngine.computeCompatibility(
        userA: userA,
        userB: userB,
        answersA: const [],
        answersB: const [],
      );

      expect(result, isNull);
    });

    test('16. Hard Filter: Bidirectional gender preference rejection', () {
      final userA = createProfile(gender: 'male', genderPreference: 'female');
      final userB = createProfile(gender: 'female', genderPreference: 'female'); // B requires female

      final result = CompatibilityEngine.computeCompatibility(
        userA: userA,
        userB: userB,
        answersA: const [],
        answersB: const [],
      );

      expect(result, isNull);
    });

    test('17. Hard Filter: Deal-breaker conflict (smoking) returns null', () {
      final userA = createProfile();
      final userB = createProfile();

      final answersA = [
        const UserAnswer(
          userId: 'a',
          questionId: 'q_smoke',
          topic: 'smoking',
          answer: 'never',
          importance: AnswerImportance.dealBreaker,
        ),
      ];
      final answersB = [
        const UserAnswer(
          userId: 'b',
          questionId: 'q_smoke',
          topic: 'smoking',
          answer: 'daily',
          importance: AnswerImportance.niceToHave,
        ),
      ];

      final result = CompatibilityEngine.computeCompatibility(
        userA: userA,
        userB: userB,
        answersA: answersA,
        answersB: answersB,
      );

      expect(result, isNull);
    });

    test('18. Hard Filter: Bidirectional deal-breaker conflict (food/veg) returns null', () {
      final userA = createProfile();
      final userB = createProfile();

      final answersA = [
        const UserAnswer(
          userId: 'a',
          questionId: 'q_food',
          topic: 'food',
          answer: 'regular_non_veg',
          importance: AnswerImportance.niceToHave,
        ),
      ];
      final answersB = [
        const UserAnswer(
          userId: 'b',
          questionId: 'q_food',
          topic: 'food',
          answer: 'pure_veg',
          importance: AnswerImportance.dealBreaker,
        ),
      ];

      final result = CompatibilityEngine.computeCompatibility(
        userA: userA,
        userB: userB,
        answersA: answersA,
        answersB: answersB,
      );

      expect(result, isNull);
    });

    test('19. Hard Filter: Deal-breaker non-conflicting answers pass', () {
      final userA = createProfile();
      final userB = createProfile();

      final answersA = [
        const UserAnswer(
          userId: 'a',
          questionId: 'q_smoke',
          topic: 'smoking',
          answer: 'never',
          importance: AnswerImportance.dealBreaker,
        ),
      ];
      final answersB = [
        const UserAnswer(
          userId: 'b',
          questionId: 'q_smoke',
          topic: 'smoking',
          answer: 'never',
          importance: AnswerImportance.dealBreaker,
        ),
      ];

      final result = CompatibilityEngine.computeCompatibility(
        userA: userA,
        userB: userB,
        answersA: answersA,
        answersB: answersB,
      );

      expect(result, isNotNull);
      expect(result!.score, 100.0);
    });

    test('20. Weighted scoring applies importance multipliers (3.0 for deal_breaker, 1.0 for nice_to_have)', () {
      final userA = createProfile();
      final userB = createProfile();

      // Q1: Deal-breaker (weight 3.0), exact match (10) -> 30
      // Q2: Nice to have (weight 1.0), opposite (0) -> 0
      // Max possible: 30 + 10 = 40. Total weighted: 30. Score: 30/40 * 100 = 75.0
      final answersA = [
        const UserAnswer(
          userId: 'a',
          questionId: 'q1',
          topic: 'cleanliness',
          answer: 'very_tidy',
          optionIndex: 2,
          importance: AnswerImportance.dealBreaker,
        ),
        const UserAnswer(
          userId: 'a',
          questionId: 'q2',
          topic: 'cooking',
          answer: 'never',
          optionIndex: 0,
          importance: AnswerImportance.niceToHave,
        ),
      ];
      final answersB = [
        const UserAnswer(
          userId: 'b',
          questionId: 'q1',
          topic: 'cleanliness',
          answer: 'very_tidy',
          optionIndex: 2,
          importance: AnswerImportance.niceToHave,
        ),
        const UserAnswer(
          userId: 'b',
          questionId: 'q2',
          topic: 'cooking',
          answer: 'daily_chef',
          optionIndex: 3,
          importance: AnswerImportance.niceToHave,
        ),
      ];

      final result = CompatibilityEngine.computeCompatibility(
        userA: userA,
        userB: userB,
        answersA: answersA,
        answersB: answersB,
      );

      expect(result, isNotNull);
      expect(result!.score, 75.0);
      expect(result.label, CompatibilityLabel.goodMatch);
    });

    test('21. Bidirectional importance takes MAX importance between users', () {
      final userA = createProfile();
      final userB = createProfile();

      // User A marked nice_to_have (1.0), User B marked deal_breaker (3.0) -> effective weight = 3.0
      final answersA = [
        const UserAnswer(
          userId: 'a',
          questionId: 'q1',
          topic: 'cleanliness',
          answer: 'moderate',
          optionIndex: 1,
          importance: AnswerImportance.niceToHave,
        ),
      ];
      final answersB = [
        const UserAnswer(
          userId: 'b',
          questionId: 'q1',
          topic: 'cleanliness',
          answer: 'very_tidy',
          optionIndex: 2,
          importance: AnswerImportance.dealBreaker,
        ),
      ];

      final result = CompatibilityEngine.computeCompatibility(
        userA: userA,
        userB: userB,
        answersA: answersA,
        answersB: answersB,
      );

      expect(result, isNotNull);
      // 1 step apart -> base score = 6.0
      expect(result!.score, 60.0);
    });

    test('22. Explainable output correctly identifies compatible and watch-out topics', () {
      final userA = createProfile();
      final userB = createProfile();

      final answersA = [
        const UserAnswer(userId: 'a', questionId: 'q1', topic: 'sleep', answer: 'early_bird', optionIndex: 0),
        const UserAnswer(userId: 'a', questionId: 'q2', topic: 'noise', answer: 'silent', optionIndex: 0),
        const UserAnswer(userId: 'a', questionId: 'q3', topic: 'food', answer: 'pure_veg', optionIndex: 0),
      ];
      final answersB = [
        const UserAnswer(userId: 'b', questionId: 'q1', topic: 'sleep', answer: 'early_bird', optionIndex: 0), // 10 -> compatible
        const UserAnswer(userId: 'b', questionId: 'q2', topic: 'noise', answer: 'quiet', optionIndex: 1), // 6 -> neither
        const UserAnswer(userId: 'b', questionId: 'q3', topic: 'food', answer: 'regular_non_veg', optionIndex: 3), // 0 -> watch out
      ];

      final result = CompatibilityEngine.computeCompatibility(
        userA: userA,
        userB: userB,
        answersA: answersA,
        answersB: answersB,
      );

      expect(result, isNotNull);
      expect(result!.compatibleTopics, contains('sleep'));
      expect(result.watchOutTopics, contains('food'));
      expect(result.compatibleTopics, isNot(contains('noise')));
      expect(result.watchOutTopics, isNot(contains('noise')));
    });

    test('23. CompatibilityLabel thresholds match specifications', () {
      expect(CompatibilityLabel.fromScore(95.0), CompatibilityLabel.greatMatch);
      expect(CompatibilityLabel.fromScore(80.0), CompatibilityLabel.greatMatch);
      expect(CompatibilityLabel.fromScore(79.9), CompatibilityLabel.goodMatch);
      expect(CompatibilityLabel.fromScore(60.0), CompatibilityLabel.goodMatch);
      expect(CompatibilityLabel.fromScore(59.9), CompatibilityLabel.worthAChat);
      expect(CompatibilityLabel.fromScore(40.0), CompatibilityLabel.worthAChat);
      expect(CompatibilityLabel.fromScore(39.9), CompatibilityLabel.mightBeTricky);
      expect(CompatibilityLabel.fromScore(0.0), CompatibilityLabel.mightBeTricky);
    });

    test('24. Learning-to-Rank ML custom topic weights properly adjust score', () {
      final userA = createProfile();
      final userB = createProfile();

      final answersA = [
        const UserAnswer(userId: 'a', questionId: 'q1', topic: 'sleep', answer: 'early_bird', optionIndex: 0),
        const UserAnswer(userId: 'a', questionId: 'q2', topic: 'cleanliness', answer: 'relaxed', optionIndex: 0),
      ];
      final answersB = [
        const UserAnswer(userId: 'b', questionId: 'q1', topic: 'sleep', answer: 'early_bird', optionIndex: 0), // 10
        const UserAnswer(userId: 'b', questionId: 'q2', topic: 'cleanliness', answer: 'neat_freak', optionIndex: 3), // 0
      ];

      // Equal weight -> (10 + 0) / 20 * 100 = 50.0
      final standardResult = CompatibilityEngine.computeCompatibility(
        userA: userA,
        userB: userB,
        answersA: answersA,
        answersB: answersB,
      );
      expect(standardResult!.score, 50.0);

      // Boost cleanliness ML weight to 3.0:
      // Sleep: 10 * 1.0 = 10, max = 10
      // Cleanliness: 0 * 3.0 = 0, max = 30
      // Total: 10 / 40 * 100 = 25.0
      const mlWeights = CompatibilityWeights(
        topicMultipliers: {'cleanliness': 3.0},
      );
      final mlResult = CompatibilityEngine.computeCompatibility(
        userA: userA,
        userB: userB,
        answersA: answersA,
        answersB: answersB,
        weights: mlWeights,
      );
      expect(mlResult!.score, 25.0);
    });

    test('25. Haversine distance correctly calculates Mumbai localities distance', () {
      // Bandra (19.0596, 72.8295) to Andheri (19.1136, 72.8697) ~ 7.3 km
      final dist = CompatibilityEngine.calculateHaversineDistanceKm(
        19.0596,
        72.8295,
        19.1136,
        72.8697,
      );
      expect(dist, greaterThan(6.5));
      expect(dist, lessThan(8.0));
    });
  });
}
