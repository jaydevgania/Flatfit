import 'dart:math';

/// Result of a pricing calculation with GST and platform commission.
class CheckoutPricingBreakdown {
  final double basePrice;
  final double discountAmount;
  final double subtotal;
  final double gstAmount; // 18% standard
  final double totalPayable;
  final double flatfitCommissionAmount;
  final double vendorNetPayout;

  const CheckoutPricingBreakdown({
    required this.basePrice,
    required this.discountAmount,
    required this.subtotal,
    required this.gstAmount,
    required this.totalPayable,
    required this.flatfitCommissionAmount,
    required this.vendorNetPayout,
  });
}

/// Service handling checkout logic, UPI intent creation, and platform commission tracking.
class CheckoutService {
  static const double gstRate = 0.18; // 18% GST

  /// Computes itemized pricing, taxes, and platform commission.
  static CheckoutPricingBreakdown calculatePricing({
    required double basePrice,
    double discountPercent = 0.0,
    double platformCommissionPct = 10.0,
  }) {
    final discountAmount = basePrice * (discountPercent / 100);
    final subtotal = basePrice - discountAmount;
    final gst = subtotal * gstRate;
    final total = subtotal + gst;
    final commission = subtotal * (platformCommissionPct / 100);
    final vendorPayout = subtotal - commission;

    return CheckoutPricingBreakdown(
      basePrice: basePrice,
      discountAmount: double.parse(discountAmount.toStringAsFixed(2)),
      subtotal: double.parse(subtotal.toStringAsFixed(2)),
      gstAmount: double.parse(gst.toStringAsFixed(2)),
      totalPayable: double.parse(total.toStringAsFixed(2)),
      flatfitCommissionAmount: double.parse(commission.toStringAsFixed(2)),
      vendorNetPayout: double.parse(vendorPayout.toStringAsFixed(2)),
    );
  }

  /// Generates a standard NPCI-compliant UPI Intent URI for seamless payment in GPay/PhonePe/Paytm.
  static Uri generateUpiUri({
    required String payeeVpa,
    required String payeeName,
    required double amount,
    required String transactionNote,
    String? transactionRef,
  }) {
    final ref = transactionRef ?? 'FF${DateTime.now().millisecondsSinceEpoch}';
    final queryParams = {
      'pa': payeeVpa,
      'pn': payeeName,
      'am': amount.toStringAsFixed(2),
      'cu': 'INR',
      'tn': transactionNote,
      'tr': ref,
    };

    return Uri(
      scheme: 'upi',
      host: 'pay',
      queryParameters: queryParams,
    );
  }

  /// Triggers a mock or Razorpay checkout flow, returning transaction receipt details.
  static Future<Map<String, dynamic>> processMockPayment({
    required String bookingId,
    required double amount,
    required String paymentMethod, // 'upi' or 'razorpay_card'
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    final randomId = 'pay_${Random().nextInt(899999) + 100000}';
    final orderId = 'order_ff_${Random().nextInt(89999) + 10000}';

    return {
      'isSuccess': true,
      'paymentId': randomId,
      'orderId': orderId,
      'amount': amount,
      'currency': 'INR',
      'paymentMethod': paymentMethod,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}
