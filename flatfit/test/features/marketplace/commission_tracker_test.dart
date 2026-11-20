import 'package:flutter_test/flutter_test.dart';
import 'package:flatfit/features/marketplace/domain/checkout_service.dart';

void main() {
  group('CheckoutService & Commission Tracker Tests', () {
    test('Calculates 18% GST and 10% platform commission accurately', () {
      final pricing = CheckoutService.calculatePricing(
        basePrice: 5000.0,
        discountPercent: 10.0, // 10% discount -> 4500 subtotal
        platformCommissionPct: 10.0,
      );

      expect(pricing.basePrice, equals(5000.0));
      expect(pricing.discountAmount, equals(500.0));
      expect(pricing.subtotal, equals(4500.0));
      expect(pricing.gstAmount, equals(810.0)); // 18% of 4500
      expect(pricing.totalPayable, equals(5310.0));
      expect(pricing.flatfitCommissionAmount, equals(450.0)); // 10% of 4500
      expect(pricing.vendorNetPayout, equals(4050.0));
    });

    test('Generates valid NPCI compliant UPI Intent URI', () {
      final uri = CheckoutService.generateUpiUri(
        payeeVpa: 'flatfit.services@okaxis',
        payeeName: 'FlatFit Services',
        amount: 2499.0,
        transactionNote: 'Packers & Movers Booking',
      );

      expect(uri.scheme, equals('upi'));
      expect(uri.host, equals('pay'));
      expect(uri.queryParameters['pa'], equals('flatfit.services@okaxis'));
      expect(uri.queryParameters['am'], equals('2499.00'));
      expect(uri.queryParameters['cu'], equals('INR'));
    });
  });
}
