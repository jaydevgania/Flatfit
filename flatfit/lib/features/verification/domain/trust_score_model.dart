import 'package:flutter/material.dart';

/// TrustScore model representing the multi-factor trust rating of a FlatFit user.
class TrustScore {
  final String userId;
  final int score; // 0 - 100
  final Map<String, int> factors; // Points breakdown
  final DateTime updatedAt;

  const TrustScore({
    required this.userId,
    required this.score,
    this.factors = const {},
    required this.updatedAt,
  });

  /// Factors breakdown getters
  int get phonePoints => factors['phone_verified'] ?? 0;
  int get kycPoints => factors['kyc_verified'] ?? 0;
  int get emailPoints => factors['email_verified'] ?? 0;
  int get profilePoints => factors['profile_complete'] ?? 0;
  int get reviewsPoints => factors['reviews_score'] ?? 0;
  int get accountAgePoints => factors['account_age'] ?? 0;

  /// Calculate Trust Score according to FlatFit algorithm:
  /// - phone verified: +10
  /// - KYC: +30
  /// - work/college email: +10
  /// - complete profile: +10
  /// - reviews: +5 each (up to 30)
  /// - age of account: +1 per month (max 10)
  static TrustScore calculate({
    required String userId,
    required bool isPhoneVerified,
    required bool isKycDone,
    required bool isEmailVerified,
    required bool isProfileComplete,
    required int positiveReviewCount,
    required int accountAgeMonths,
  }) {
    final Map<String, int> breakdown = {};

    breakdown['phone_verified'] = isPhoneVerified ? 10 : 0;
    breakdown['kyc_verified'] = isKycDone ? 30 : 0;
    breakdown['email_verified'] = isEmailVerified ? 10 : 0;
    breakdown['profile_complete'] = isProfileComplete ? 10 : 0;
    breakdown['reviews_score'] = (positiveReviewCount * 5).clamp(0, 30);
    breakdown['account_age'] = accountAgeMonths.clamp(0, 10);

    final total = breakdown.values.fold(0, (sum, val) => sum + val);

    return TrustScore(
      userId: userId,
      score: total.clamp(0, 100),
      factors: breakdown,
      updatedAt: DateTime.now(),
    );
  }

  /// Badge Tier
  String get tierName {
    if (score >= 90) return 'Platinum Verified';
    if (score >= 70) return 'Gold Verified';
    if (score >= 40) return 'Silver Verified';
    return 'Bronze (Unverified)';
  }

  Color get tierColor {
    if (score >= 90) return const Color(0xFF0D9488); // Teal
    if (score >= 70) return const Color(0xFFD97706); // Gold Amber
    if (score >= 40) return const Color(0xFF64748B); // Silver Slate
    return const Color(0xFFB45309); // Bronze
  }

  factory TrustScore.fromJson(Map<String, dynamic> json) {
    final rawFactors = json['factors'] != null && json['factors'] is Map
        ? Map<String, dynamic>.from(json['factors'] as Map)
        : <String, dynamic>{};

    final factorsMap = rawFactors.map(
      (key, value) => MapEntry(key, (value as num?)?.toInt() ?? 0),
    );

    return TrustScore(
      userId: json['user_id'] as String? ?? json['userId'] as String? ?? '',
      score: json['score'] as int? ?? 50,
      factors: factorsMap,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'score': score,
      'factors': factors,
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
