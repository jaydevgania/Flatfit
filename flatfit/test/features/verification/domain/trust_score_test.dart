import 'package:flutter_test/flutter_test.dart';
import '../../../../flatfit/lib/features/verification/domain/review_model.dart';
import '../../../../flatfit/lib/features/verification/domain/review_tags.dart';
import '../../../../flatfit/lib/features/verification/domain/trust_score_model.dart';

void main() {
  group('Trust Score and Verification Algorithm Tests', () {
    test('Calculates Trust Score according to exact specification', () {
      // phone (10) + kyc (30) + email (10) + profile (10) + 4 reviews (20) + 5 months age (5) = 85
      final trust = TrustScore.calculate(
        userId: 'test_user_1',
        isPhoneVerified: true,
        isKycDone: true,
        isEmailVerified: true,
        isProfileComplete: true,
        positiveReviewCount: 4,
        accountAgeMonths: 5,
      );

      expect(trust.phonePoints, 10);
      expect(trust.kycPoints, 30);
      expect(trust.emailPoints, 10);
      expect(trust.profilePoints, 10);
      expect(trust.reviewsPoints, 20);
      expect(trust.accountAgePoints, 5);
      expect(trust.score, 85);
      expect(trust.tierName, 'Gold Verified');
    });

    test('Clamps review score to 30 and account age to 10', () {
      final trust = TrustScore.calculate(
        userId: 'veteran_user',
        isPhoneVerified: true,
        isKycDone: true,
        isEmailVerified: true,
        isProfileComplete: true,
        positiveReviewCount: 15, // 15 * 5 = 75, should clamp to 30
        accountAgeMonths: 24, // should clamp to 10
      );

      expect(trust.reviewsPoints, 30);
      expect(trust.accountAgePoints, 10);
      expect(trust.score, 100);
      expect(trust.tierName, 'Platinum Verified');
    });

    test('Review requires 30+ days of stay duration', () {
      final validReview = UserReview(
        id: 'r1',
        reviewerId: 'u1',
        revieweeId: 'u2',
        reviewerName: 'Priya',
        rating: 5,
        stayDurationMonths: 2,
        createdAt: DateTime.now(),
      );
      expect(validReview.meetsStayRequirement, true);

      final invalidReview = UserReview(
        id: 'r2',
        reviewerId: 'u1',
        revieweeId: 'u2',
        reviewerName: 'Priya',
        rating: 5,
        stayDurationMonths: 0,
        createdAt: DateTime.now(),
      );
      expect(invalidReview.meetsStayRequirement, false);
    });

    test('Predefined review tags categorization', () {
      expect(ReviewTags.isPositive('Pays on time'), true);
      expect(ReviewTags.isPositive('Clean and tidy'), true);
      expect(ReviewTags.isPositive('Night owl'), false); // neutral
      expect(ReviewTags.neutralTags.contains('Night owl'), true);
    });
  });
}
