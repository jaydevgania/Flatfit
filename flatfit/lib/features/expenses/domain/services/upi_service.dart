class UpiService {
  static bool isValidVpa(String vpa) {
    return RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+$').hasMatch(vpa);
  }

  static String generateUpiDeepLink({
    required String vpa,
    required String payeeName,
    required double amount,
    required String note,
  }) {
    final uri = Uri(
      scheme: 'upi',
      host: 'pay',
      queryParameters: {
        'pa': vpa,
        'pn': payeeName,
        'am': amount.toStringAsFixed(2),
        'cu': 'INR',
        'tn': note,
      },
    );
    return uri.toString();
  }
}
