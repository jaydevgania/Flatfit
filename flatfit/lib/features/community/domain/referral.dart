class UserReferralSummary {
  final String referralCode;
  final String referralLink;
  final double totalCashEarned;
  final double pendingCashRewards;
  final int totalFriendsInvited;
  final int totalFriendsMovedIn;
  final List<String> referralHistory;

  const UserReferralSummary({
    required this.referralCode,
    required this.referralLink,
    required this.totalCashEarned,
    required this.pendingCashRewards,
    required this.totalFriendsInvited,
    required this.totalFriendsMovedIn,
    required this.referralHistory,
  });

  bool get hasUnlockedPlusMilestone => totalFriendsMovedIn >= 3;
}

class ReferralEngine {
  static String generateReferralLink(String code) =>
      'https://flatfit.in/invite/$code';

  static UserReferralSummary getDefaultSummary(String userId, String name) =>
      UserReferralSummary(
        referralCode: 'FIT-${name.toUpperCase()}',
        referralLink: generateReferralLink('FIT-${name.toUpperCase()}'),
        totalCashEarned: 250.0,
        pendingCashRewards: 0,
        totalFriendsInvited: 2,
        totalFriendsMovedIn: 1,
        referralHistory: const [],
      );
}
