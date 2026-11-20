/// Supported subscription tier plans.
enum SubscriptionTier {
  free,
  plus,
}

/// Billing frequency duration.
enum BillingPeriod {
  monthly,
  quarterly,
  annual,
}

/// A pricing plan option for FlatFit Plus.
class PlusPlanOption {
  final BillingPeriod period;
  final String title;
  final double totalPrice;
  final double perMonthPrice;
  final String savingsLabel;
  final bool isPopular;

  const PlusPlanOption({
    required this.period,
    required this.title,
    required this.totalPrice,
    required this.perMonthPrice,
    required this.savingsLabel,
    this.isPopular = false,
  });
}

/// Feature comparison item between Free and Plus.
class FeatureComparisonItem {
  final String featureName;
  final String freeTierValue;
  final String plusTierValue;
  final bool isHighlighted;

  const FeatureComparisonItem({
    required this.featureName,
    required this.freeTierValue,
    required this.plusTierValue,
    this.isHighlighted = false,
  });
}

/// Active user subscription details.
class UserSubscription {
  final String userId;
  final SubscriptionTier tier;
  final BillingPeriod? activePeriod;
  final DateTime? startsAt;
  final DateTime? expiresAt;
  final bool autoRenew;
  final int dailyRequestsUsed;
  final int dailyRequestsLimit; // 5 for free, 9999 for plus

  const UserSubscription({
    required this.userId,
    this.tier = SubscriptionTier.free,
    this.activePeriod,
    this.startsAt,
    this.expiresAt,
    this.autoRenew = false,
    this.dailyRequestsUsed = 0,
    this.dailyRequestsLimit = 5,
  });

  bool get isPlusActive => tier == SubscriptionTier.plus;

  bool get canSendMatchRequest => isPlusActive || dailyRequestsUsed < dailyRequestsLimit;

  int get remainingRequestsToday =>
      isPlusActive ? 999 : (dailyRequestsLimit - dailyRequestsUsed).clamp(0, dailyRequestsLimit);
}

/// Plans and comparison data.
class SubscriptionCatalog {
  static const List<PlusPlanOption> plans = [
    PlusPlanOption(
      period: BillingPeriod.monthly,
      title: '1 Month',
      totalPrice: 499,
      perMonthPrice: 499,
      savingsLabel: 'Standard',
      isPopular: false,
    ),
    PlusPlanOption(
      period: BillingPeriod.quarterly,
      title: '3 Months',
      totalPrice: 999,
      perMonthPrice: 333,
      savingsLabel: 'Save 33%',
      isPopular: true,
    ),
    PlusPlanOption(
      period: BillingPeriod.annual,
      title: '12 Months',
      totalPrice: 1999,
      perMonthPrice: 166,
      savingsLabel: 'Save 66%',
      isPopular: false,
    ),
  ];

  static const List<FeatureComparisonItem> comparisonTable = [
    FeatureComparisonItem(
      featureName: 'Compatibility matching & scores',
      freeTierValue: 'Free Forever',
      plusTierValue: 'Included',
    ),
    FeatureComparisonItem(
      featureName: 'Direct 1-on-1 chat with mutual matches',
      freeTierValue: 'Free Forever',
      plusTierValue: 'Included',
    ),
    FeatureComparisonItem(
      featureName: 'Daily match requests',
      freeTierValue: '5 per day',
      plusTierValue: 'Unlimited',
      isHighlighted: true,
    ),
    FeatureComparisonItem(
      featureName: 'See who viewed & shortlisted you',
      freeTierValue: 'Blurred',
      plusTierValue: 'Full Access',
      isHighlighted: true,
    ),
    FeatureComparisonItem(
      featureName: 'Advanced filters (food, sleep, zodiac, etc.)',
      freeTierValue: 'Basic only',
      plusTierValue: 'All 14 Filters',
      isHighlighted: true,
    ),
    FeatureComparisonItem(
      featureName: 'Profile Discovery Boost (3x more views)',
      freeTierValue: 'No',
      plusTierValue: '1 Boost / Week',
    ),
    FeatureComparisonItem(
      featureName: 'Verified Plus Member Badge',
      freeTierValue: 'No',
      plusTierValue: 'Yes',
    ),
    FeatureComparisonItem(
      featureName: 'Digital Rent Agreement Generator',
      freeTierValue: '₹499 extra',
      plusTierValue: 'Free (Save ₹499)',
    ),
  ];
}
