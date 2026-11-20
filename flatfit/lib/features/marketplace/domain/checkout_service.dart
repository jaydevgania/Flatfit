class CheckoutPricing {
  final double basePrice;
  final double discountAmount;
  final double subtotal;
  final double gstAmount;
  final double totalPayable;
  final double flatfitCommissionAmount;
  final double vendorNetPayout;

  const CheckoutPricing({
    required this.basePrice,
    required this.discountAmount,
    required this.subtotal,
    required this.gstAmount,
    required this.totalPayable,
    required this.flatfitCommissionAmount,
    required this.vendorNetPayout,
  });
}

class CheckoutService {
  static CheckoutPricing calculatePricing({
    required double basePrice,
    required double discountPercent,
    required double platformCommissionPct,
  }) {
    final discount = basePrice * discountPercent / 100;
    final subtotal = basePrice - discount;
    final gst = subtotal * 0.18;
    final commission = subtotal * platformCommissionPct / 100;
    return CheckoutPricing(
      basePrice: basePrice,
      discountAmount: discount,
      subtotal: subtotal,
      gstAmount: gst,
      totalPayable: subtotal + gst,
      flatfitCommissionAmount: commission,
      vendorNetPayout: subtotal - commission,
    );
  }

  static Uri generateUpiUri({
    required String payeeVpa,
    required String payeeName,
    required double amount,
    required String transactionNote,
  }) {
    return Uri(
      scheme: 'upi',
      host: 'pay',
      queryParameters: {
        'pa': payeeVpa,
        'pn': payeeName,
        'am': amount.toStringAsFixed(2),
        'cu': 'INR',
        'tn': transactionNote,
      },
    );
  }
}
