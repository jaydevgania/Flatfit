import 'package:flutter_test/flutter_test.dart';
import 'package:flatfit/features/monetization/domain/subscription.dart';
import 'package:flatfit/features/monetization/domain/feature_flags.dart';

void main() {
  group('FeatureFlagGate Tests', () {
    test('Basic match and first chat are ALWAYS 100% free', () {
      expect(FeatureFlagGate.canViewMatches(), isTrue);
      expect(FeatureFlagGate.canChatWithMutualMatch(), isTrue);
    });

    test('Free users can send up to 5 match requests per day', () {
      const freeUnderLimit = UserSubscription(
        userId: 'u1',
        tier: SubscriptionTier.free,
        dailyRequestsUsed: 4,
        dailyRequestsLimit: 5,
      );

      expect(FeatureFlagGate.canSendMatchRequest(freeUnderLimit), isTrue);
      expect(FeatureFlagGate.shouldShowPaywall(action: 'match_request', sub: freeUnderLimit), isFalse);

      const freeAtLimit = UserSubscription(
        userId: 'u1',
        tier: SubscriptionTier.free,
        dailyRequestsUsed: 5,
        dailyRequestsLimit: 5,
      );

      expect(FeatureFlagGate.canSendMatchRequest(freeAtLimit), isFalse);
      expect(FeatureFlagGate.shouldShowPaywall(action: 'match_request', sub: freeAtLimit), isTrue);
    });

    test('Plus users have unlimited requests and access to all gated perks', () {
      const plusUser = UserSubscription(
        userId: 'u2',
        tier: SubscriptionTier.plus,
        dailyRequestsUsed: 25,
      );

      expect(FeatureFlagGate.canSendMatchRequest(plusUser), isTrue);
      expect(FeatureFlagGate.canViewProfileViewers(plusUser), isTrue);
      expect(FeatureFlagGate.canUseAdvancedFilters(plusUser), isTrue);
      expect(FeatureFlagGate.shouldShowPaywall(action: 'view_viewers', sub: plusUser), isFalse);
    });
  });
}
