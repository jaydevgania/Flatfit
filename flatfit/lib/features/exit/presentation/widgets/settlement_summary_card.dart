import 'package:flutter/material.dart';
import '../../domain/models/exit_models.dart';

/// Card showing the full transparent breakdown of security deposit deductions and net refund.
class SettlementSummaryCard extends StatelessWidget {
  final DepositSettlement settlement;
  final VoidCallback? onRefundViaUpi;

  const SettlementSummaryCard({
    super.key,
    required this.settlement,
    this.onRefundViaUpi,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Deposit Return Settlement',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: settlement.isRefunded ? Colors.green.shade50 : Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    settlement.isRefunded ? 'REFUNDED' : 'READY TO PAY',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: settlement.isRefunded ? Colors.green.shade800 : Colors.amber.shade900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _breakdownRow('Original Security Deposit Held', '+₹${settlement.originalDeposit.toStringAsFixed(0)}', isBold: true),
            if (settlement.unpaidRentDeduction > 0)
              _breakdownRow('Unpaid Rent Days', '-₹${settlement.unpaidRentDeduction.toStringAsFixed(0)}', isDeduction: true),
            if (settlement.unpaidUtilityBillsDeduction > 0)
              _breakdownRow('Unpaid Electricity / WiFi Dues', '-₹${settlement.unpaidUtilityBillsDeduction.toStringAsFixed(0)}', isDeduction: true),
            if (settlement.damageDeductions > 0)
              _breakdownRow('Agreed Tenant Damage Repairs', '-₹${settlement.damageDeductions.toStringAsFixed(0)}', isDeduction: true),
            if (settlement.cleaningDeduction > 0)
              _breakdownRow('Agreed Deep Cleaning Share', '-₹${settlement.cleaningDeduction.toStringAsFixed(0)}', isDeduction: true),
            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Net Refundable Amount:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(
                  '₹${settlement.netRefundAmount.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.teal.shade900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Refund destination: ${settlement.recipientVpa}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 14),
            if (!settlement.isRefunded && onRefundViaUpi != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.payment, size: 18),
                  label: Text(
                    'Refund ₹${settlement.netRefundAmount.toStringAsFixed(0)} via UPI',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: onRefundViaUpi,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _breakdownRow(String label, String value, {bool isDeduction = false, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: isDeduction ? Colors.red.shade700 : Colors.teal.shade900,
            ),
          ),
        ],
      ),
    );
  }
}
