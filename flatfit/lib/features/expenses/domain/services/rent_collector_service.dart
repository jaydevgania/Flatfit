import '../models/expense_models.dart';
import 'upi_service.dart';

/// Service managing the co-living Rent Collection flow.
class RentCollectorService {
  /// Generates the rent autopay / due reminder notification message for a flatmate.
  static String generateRentReminderMessage({
    required String flatmateName,
    required double shareAmount,
    required String month,
    required int dueDayOfMonth,
    required String collectorName,
    required String collectorVpa,
    required String ownerName,
  }) {
    final upiLink = UpiService.generateUpiDeepLink(
      vpa: collectorVpa,
      payeeName: collectorName,
      amount: shareAmount,
      note: '$month Flat Rent - $flatmateName',
    );

    return 'Hi $flatmateName! 🏠\n\n'
        'Rent reminder for $month co-living stay:\n'
        '🗓️ Due date: ${dueDayOfMonth}th of this month\n'
        '💵 Your share: ₹${shareAmount.toStringAsFixed(0)}\n'
        '👤 Landlord: $ownerName\n'
        '📲 House collection point: $collectorName ($collectorVpa)\n\n'
        'Please pay using this one-tap UPI link:\n'
        '$upiLink\n\n'
        'Once received, $collectorName will remit the full flat rent to the landlord.';
  }

  /// Calculates total collected percentage and remaining amount for the flat's monthly rent.
  static ({double collectedAmount, double pendingAmount, double percentage, bool isFullyCollected})
      calculateProgress({
    required double totalRent,
    required List<FlatmateRentStatus> shares,
  }) {
    double collected = 0;
    for (final s in shares) {
      if (s.isPaid) collected += s.shareAmount;
    }
    final pending = (totalRent - collected) > 0 ? (totalRent - collected) : 0.0;
    final pct = totalRent > 0 ? (collected / totalRent).clamp(0.0, 1.0) : 1.0;

    return (
      collectedAmount: collected,
      pendingAmount: pending,
      percentage: pct,
      isFullyCollected: collected >= totalRent,
    );
  }
}
