/// Status of an individual referral invite.
enum ReferralStatus {
  sent,
  registered,
  kycCompleted,
  movedIn,
}

/// An invited friend and their conversion progress.
class ReferralItem {
  final String id;
  final String friendName;
  final String friendPhoneOrEmail;
  final ReferralStatus status;
  final double rewardEarned;
  final DateTime invitedAt;

  const ReferralItem({
    required this.id,
    required this.friendName,
    required this.friendPhoneOrEmail,
    required this.status,
    required this.rewardEarned,
    required this.invitedAt,
  });
}

/// Complete referral program details for the active user.
class UserReferralSummary {
  final String referralCode;
  final String referralLink;
  final double totalCashEarned;
  final double pendingCashRewards;
  final int totalFriendsInvited;
  final int totalFriendsMovedIn;
  final List<ReferralItem> referralHistory;

  const UserReferralSummary({
    required this.referralCode,
    required this.referralLink,
    required this.totalCashEarned,
    required this.pendingCashRewards,
    required this.totalFriendsInvited,
    required this.totalFriendsMovedIn,
    required this.referralHistory,
  });

  /// Check whether user has unlocked the 3-referral milestone for free FlatFit Plus.
  bool get hasUnlockedPlusMilestone => totalFriendsMovedIn >= 3;
}

/// Domain logic for generating referral codes and calculating rewards.
class ReferralEngine {
  static const double rewardPerMoveIn = 250.0; // ₹250 wallet cash per successful move-in
  static const double rewardForSignup = 50.0; // ₹50 welcome credit

  /// Generate a unique referral link for a user.
  static String generateReferralLink(String code) {
    return 'https://flatfit.in/invite/$code';
  }

  /// Generate default summary for a user.
  static UserReferralSummary getDefaultSummary(String userId, String userName) {
    final sanitizedName = userName.replaceAll(RegExp(r'\s+'), '').toUpperCase();
    final code = 'FIT-$sanitizedName-2026';
    final link = generateReferralLink(code);

    final history = [
      ReferralItem(
        id: 'ref_1',
        friendName: 'Rohan Deshmukh',
        friendPhoneOrEmail: '+91 98333 •••••',
        status: ReferralStatus.movedIn,
        rewardEarned: 250.0,
        invitedAt: DateTime.now().subtract(const Duration(days: 12)),
      ),
      ReferralItem(
        id: 'ref_2',
        friendName: 'Priya Nambiar',
        friendPhoneOrEmail: '+91 98201 •••••',
        status: ReferralStatus.kycCompleted,
        rewardEarned: 0.0,
        invitedAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      ReferralItem(
        id: 'ref_3',
        friendName: 'Tanmay Shah',
        friendPhoneOrEmail: '+91 99300 •••••',
        status: ReferralStatus.registered,
        rewardEarned: 0.0,
        invitedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];

    return UserReferralSummary(
      referralCode: code,
      referralLink: link,
      totalCashEarned: 250.0,
      pendingCashRewards: 500.0,
      totalFriendsInvited: 3,
      totalFriendsMovedIn: 1,
      referralHistory: history,
    );
  }
}
