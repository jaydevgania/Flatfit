enum SubscriptionTier { free, plus }

class UserSubscription {
  final String userId;
  final SubscriptionTier tier;
  final int dailyRequestsUsed;
  final int dailyRequestsLimit;

  const UserSubscription({
    required this.userId,
    required this.tier,
    this.dailyRequestsUsed = 0,
    this.dailyRequestsLimit = 5,
  });
}
