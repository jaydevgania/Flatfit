class TrustScore {
  final String userId;
  final int phonePoints;
  final int kycPoints;
  final int emailPoints;
  final int profilePoints;
  final int reviewsPoints;
  final int accountAgePoints;

  const TrustScore({
    required this.userId,
    required this.phonePoints,
    required this.kycPoints,
    required this.emailPoints,
    required this.profilePoints,
    required this.reviewsPoints,
    required this.accountAgePoints,
  });

  int get score =>
      phonePoints +
      kycPoints +
      emailPoints +
      profilePoints +
      reviewsPoints +
      accountAgePoints;

  String get tierName {
    if (score >= 95) return 'Platinum Verified';
    if (score >= 80) return 'Gold Verified';
    if (score >= 60) return 'Silver Verified';
    return 'Verified';
  }

  static TrustScore calculate({
    required String userId,
    required bool isPhoneVerified,
    required bool isKycDone,
    required bool isEmailVerified,
    required bool isProfileComplete,
    required int positiveReviewCount,
    required int accountAgeMonths,
  }) {
    return TrustScore(
      userId: userId,
      phonePoints: isPhoneVerified ? 10 : 0,
      kycPoints: isKycDone ? 30 : 0,
      emailPoints: isEmailVerified ? 10 : 0,
      profilePoints: isProfileComplete ? 10 : 0,
      reviewsPoints: (positiveReviewCount * 5).clamp(0, 30).toInt(),
      accountAgePoints: accountAgeMonths.clamp(0, 10).toInt(),
    );
  }
}
