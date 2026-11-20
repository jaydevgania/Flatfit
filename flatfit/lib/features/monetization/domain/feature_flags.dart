import 'subscription.dart';

/// Central feature flag gatekeeper ensuring free core access while protecting monetized perks.
class FeatureFlagGate {
  /// Basic compatibility browsing and match calculation is ALWAYS 100% free.
  static bool canViewMatches() => true;

  /// Basic first chat between mutually accepted flatmates is ALWAYS 100% free.
  static bool canChatWithMutualMatch() => true;

  /// Checks if a user is permitted to send another match request today.
  static bool canSendMatchRequest(UserSubscription sub) {
    if (sub.isPlusActive) return true;
    return sub.dailyRequestsUsed < sub.dailyRequestsLimit;
  }

  /// Checks if user can view who viewed or shortlisted their profile.
  static bool canViewProfileViewers(UserSubscription sub) {
    return sub.isPlusActive;
  }

  /// Checks if user can use granular advanced lifestyle filters.
  static bool canUseAdvancedFilters(UserSubscription sub) {
    return sub.isPlusActive;
  }

  /// Checks if user can activate a 3x discovery boost for their profile.
  static bool canActivateProfileBoost(UserSubscription sub) {
    return sub.isPlusActive;
  }

  /// Checks if user can export the customized legal rent agreement for free.
  static bool canGenerateFreeRentAgreement(UserSubscription sub) {
    return sub.isPlusActive;
  }

  /// Evaluates whether an action requires displaying the Plus Paywall sheet.
  static bool shouldShowPaywall({
    required String action,
    required UserSubscription sub,
  }) {
    if (sub.isPlusActive) return false;

    switch (action) {
      case 'match_request':
        return sub.dailyRequestsUsed >= sub.dailyRequestsLimit;
      case 'view_viewers':
      case 'advanced_filters':
      case 'boost_profile':
      case 'free_agreement':
        return true;
      case 'basic_match':
      case 'first_chat':
      default:
        return false;
    }
  }
}
