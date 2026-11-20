import 'subscription.dart';

class FeatureFlagGate {
  static bool canViewMatches() => true;
  static bool canChatWithMutualMatch() => true;

  static bool canSendMatchRequest(UserSubscription sub) {
    if (sub.tier == SubscriptionTier.plus) return true;
    return sub.dailyRequestsUsed < sub.dailyRequestsLimit;
  }

  static bool canViewProfileViewers(UserSubscription sub) =>
      sub.tier == SubscriptionTier.plus;

  static bool canUseAdvancedFilters(UserSubscription sub) =>
      sub.tier == SubscriptionTier.plus;

  static bool shouldShowPaywall({
    required String action,
    required UserSubscription sub,
  }) {
    if (sub.tier == SubscriptionTier.plus) return false;
    if (action == 'match_request') return !canSendMatchRequest(sub);
    return true;
  }
}
