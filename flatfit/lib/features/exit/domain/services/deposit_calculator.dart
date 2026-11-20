import '../models/exit_models.dart';

/// Calculation result with itemized breakdown and compliance warnings.
class DepositCalculationResult {
  final double originalDeposit;
  final double totalDeductions;
  final double netRefundableAmount;
  final List<String> legalNotes;
  final DepositSettlement settlement;

  const DepositCalculationResult({
    required this.originalDeposit,
    required this.totalDeductions,
    required this.netRefundableAmount,
    required this.legalNotes,
    required this.settlement,
  });
}

/// Pure Dart domain engine for transparent security deposit return calculation.
class DepositCalculator {
  /// Computes the net refundable security deposit according to agreed itemized deductions.
  static DepositCalculationResult calculateDepositRefund({
    required String exitRequestId,
    required double originalDeposit,
    double unpaidRentDeduction = 0.0,
    double unpaidUtilityBillsDeduction = 0.0,
    required List<DamageInspectionItem> inspectionItems,
    double deepCleaningFee = 0.0,
    required String recipientVpa,
  }) {
    // Only non-wear-and-tear damages are deducted
    double damageTotal = 0.0;
    final notes = <String>[];

    for (final item in inspectionItems) {
      if (item.isNormalWearAndTear) {
        notes.add('Protected: "${item.itemDescription}" classified as normal wear & tear. ₹0 deduction.');
      } else {
        damageTotal += item.estimatedRepairCost;
      }
    }

    final totalDeductions = unpaidRentDeduction + unpaidUtilityBillsDeduction + damageTotal + deepCleaningFee;
    final netRefund = (originalDeposit - totalDeductions) > 0 ? (originalDeposit - totalDeductions) : 0.0;

    // Due within 7 working days of exit under standard Leave & License clauses
    final refundDueBy = DateTime.now().add(const Duration(days: 7));

    final settlement = DepositSettlement(
      id: 'settle_${DateTime.now().millisecondsSinceEpoch}',
      exitRequestId: exitRequestId,
      originalDeposit: originalDeposit,
      unpaidRentDeduction: unpaidRentDeduction,
      unpaidUtilityBillsDeduction: unpaidUtilityBillsDeduction,
      damageDeductions: damageTotal,
      cleaningDeduction: deepCleaningFee,
      netRefundAmount: netRefund,
      refundDueBy: refundDueBy,
      recipientVpa: recipientVpa,
    );

    notes.add('Model Tenancy Act compliance: Security deposit refund must be remitted within 7 to 30 days of physical handover.');

    return DepositCalculationResult(
      originalDeposit: originalDeposit,
      totalDeductions: totalDeductions,
      netRefundableAmount: netRefund,
      legalNotes: notes,
      settlement: settlement,
    );
  }
}
