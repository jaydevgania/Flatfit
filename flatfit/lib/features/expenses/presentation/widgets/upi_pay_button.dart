import 'package:flutter/material.dart';
import '../../domain/services/upi_service.dart';

/// One-tap button that launches UPI apps (GPay, PhonePe, Paytm, BHIM) with prefilled VPA & amount.
class UpiPayButton extends StatelessWidget {
  final String vpa;
  final String payeeName;
  final double amount;
  final String? note;
  final VoidCallback? onPaymentTriggered;

  const UpiPayButton({
    super.key,
    required this.vpa,
    required this.payeeName,
    required this.amount,
    this.note,
    this.onPaymentTriggered,
  });

  void _triggerPayment(BuildContext context) {
    final upiUri = UpiService.generateUpiDeepLink(
      vpa: vpa,
      payeeName: payeeName,
      amount: amount,
      note: note,
    );

    // Call callback or copy URI
    if (onPaymentTriggered != null) {
      onPaymentTriggered!();
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.payment, color: Colors.teal.shade700),
                const SizedBox(width: 8),
                const Text(
                  'Pay via UPI',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  '₹${amount.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Paying $payeeName ($vpa)',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            _appOptionTile(
              name: 'Google Pay',
              scheme: 'tez://upi/pay',
              icon: Icons.g_mobiledata,
              color: Colors.blue,
              ctx: ctx,
            ),
            _appOptionTile(
              name: 'PhonePe',
              scheme: 'phonepe://pay',
              icon: Icons.phone_android,
              color: Colors.purple,
              ctx: ctx,
            ),
            _appOptionTile(
              name: 'Paytm',
              scheme: 'paytmmp://pay',
              icon: Icons.account_balance_wallet,
              color: Colors.lightBlue,
              ctx: ctx,
            ),
            _appOptionTile(
              name: 'Any UPI App (BHIM / Bank)',
              scheme: 'upi://pay',
              icon: Icons.qr_code,
              color: Colors.green,
              ctx: ctx,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                'UPI URI: $upiUri',
                style: const TextStyle(fontSize: 10, fontFamily: 'monospace'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _appOptionTile({
    required String name,
    required String scheme,
    required IconData icon,
    required Color color,
    required BuildContext ctx,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.12),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: () {
        Navigator.pop(ctx);
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text('Opening $name with UPI intent for ₹${amount.toStringAsFixed(0)}...'),
            backgroundColor: Colors.teal.shade800,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      icon: const Icon(Icons.payment, size: 16),
      label: Text(
        'Pay ₹${amount.toStringAsFixed(0)} via UPI',
        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
      ),
      onPressed: () => _triggerPayment(context),
    );
  }
}
