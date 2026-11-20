import 'package:flutter_test/flutter_test.dart';
import 'package:flatfit/features/community/domain/referral.dart';

void main() {
  group('ReferralEngine Tests', () {
    test('Generates branded referral link from code', () {
      const code = 'FIT-JAY-2026';
      final link = ReferralEngine.generateReferralLink(code);

      expect(link, equals('https://flatfit.in/invite/FIT-JAY-2026'));
    });

    test('Identifies milestone unlock when 3 friends move in', () {
      final summary = ReferralEngine.getDefaultSummary('u1', 'Rohan');

      // Default has 1 moved in friend -> milestone not yet unlocked
      expect(summary.hasUnlockedPlusMilestone, isFalse);

      final unlockedSummary = UserReferralSummary(
        referralCode: 'FIT-KOHLI',
        referralLink: 'https://flatfit.in/invite/FIT-KOHLI',
        totalCashEarned: 750.0,
        pendingCashRewards: 0.0,
        totalFriendsInvited: 5,
        totalFriendsMovedIn: 3,
        referralHistory: const [],
      );

      expect(unlockedSummary.hasUnlockedPlusMilestone, isTrue);
    });
  });
}
