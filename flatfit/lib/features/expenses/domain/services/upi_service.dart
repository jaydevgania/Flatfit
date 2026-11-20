/// UPI (Unified Payments Interface) deep link generation and payment assistance service.
class UpiService {
  /// Validates standard Virtual Payment Address (VPA) / UPI ID format.
  /// Examples: 'rohan@okhdfcbank', '9820144321@paytm', 'ananya@ibl'.
  static bool isValidVpa(String vpa) {
    final trimmed = vpa.trim();
    final regex = RegExp(r'^[\w\.\-_]{2,256}@[a-zA-Z]{2,64}$');
    return regex.hasMatch(trimmed);
  }

  /// Generates the standard NPCI-compliant generic `upi://pay` URI string.
  /// Format: `upi://pay?pa={vpa}&pn={payeeName}&am={amount}&tn={note}&cu=INR`
  static String generateUpiDeepLink({
    required String vpa,
    required String payeeName,
    required double amount,
    String? note,
    String? transactionRef,
  }) {
    final sanitizedVpa = vpa.trim();
    final sanitizedName = payeeName.trim();
    final formattedAmount = amount.toStringAsFixed(2);
    final sanitizedNote = (note != null && note.isNotEmpty) ? note.trim() : 'FlatFit Expense Settlement';

    final queryParams = <String, String>{
      'pa': sanitizedVpa,
      'pn': sanitizedName,
      'am': formattedAmount,
      'cu': 'INR',
      'tn': sanitizedNote,
    };

    if (transactionRef != null && transactionRef.isNotEmpty) {
      queryParams['tr'] = transactionRef;
    }

    final query = queryParams.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');

    return 'upi://pay?$query';
  }

  /// Generates app-specific intent URI schemes for direct opening.
  static String generateAppSpecificUri({
    required String appScheme, // 'tez://upi/pay' (GPay), 'phonepe://pay', 'paytmmp://pay'
    required String vpa,
    required String payeeName,
    required double amount,
    String? note,
  }) {
    final genericLink = generateUpiDeepLink(
      vpa: vpa,
      payeeName: payeeName,
      amount: amount,
      note: note,
    );
    final queryString = genericLink.substring('upi://pay?'.length);
    return '$appScheme?$queryString';
  }

  /// Creates a polite and clear WhatsApp payment reminder message containing the UPI payment link.
  static String generateWhatsAppReminderMessage({
    required String debtorName,
    required String creditorName,
    required double amount,
    required String vpa,
    required String expenseDescription,
  }) {
    final upiLink = generateUpiDeepLink(
      vpa: vpa,
      payeeName: creditorName,
      amount: amount,
      note: 'Settlement: $expenseDescription',
    );

    return 'Hey $debtorName! 👋\n\n'
        'A quick friendly reminder from FlatFit for our shared house expense:\n'
        '📌 $expenseDescription\n'
        '💰 Amount due: ₹${amount.toStringAsFixed(0)}\n'
        '💳 Pay to: $creditorName ($vpa)\n\n'
        'Tap here to pay instantly via any UPI app (GPay / PhonePe / Paytm):\n'
        '$upiLink\n\n'
        'Thanks! ✨';
  }
}
