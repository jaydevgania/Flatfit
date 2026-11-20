import 'package:flutter_test/flutter_test.dart';
import 'package:flatfit/features/ai/domain/listing_authenticity.dart';

void main() {
  group('ListingAuthenticityEngine Tests', () {
    test('Flags suspiciously low rent in Bandra West as high risk anomaly', () {
      final report = ListingAuthenticityEngine.evaluateListing(
        title: 'Luxury 1BHK in Bandra West Pali Hill',
        description: 'Furnished master room with sea view and AC.',
        rent: 5000.0, // Bandra West median is ~42k; 5k is impossible and a classic scam
        locality: 'Bandra West',
        photoCount: 3,
        isVerifiedOwner: false,
        hasVideoTour: false,
      );

      expect(report.isSuspicious, isTrue);
      expect(report.grade, equals(AuthenticityGrade.suspiciouslyLow));
      expect(report.flaggedAnomalies.isNotEmpty, isTrue);
    });

    test('Validates realistic market rent in Andheri West as fair market price', () {
      final report = ListingAuthenticityEngine.evaluateListing(
        title: 'Master bedroom in 2BHK Lokhandwala Andheri West',
        description: 'Spacious room with wardrobe, attached washroom, WiFi, and daily maid.',
        rent: 25000.0,
        locality: 'Andheri West',
        photoCount: 5,
        isVerifiedOwner: true,
        hasVideoTour: true,
      );

      expect(report.isSuspicious, isFalse);
      expect(report.trustScore, greaterThanOrEqualTo(85));
      expect(report.positiveSignals.length, greaterThanOrEqualTo(3));
    });
  });
}
