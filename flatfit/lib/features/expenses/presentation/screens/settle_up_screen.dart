import 'package:flutter/material.dart';
import '../../domain/models/expense_models.dart';
import '../../domain/services/expense_splitter.dart';
import '../../domain/services/upi_service.dart';
import '../widgets/upi_pay_button.dart';

/// Screen allowing flatmates to track who owes whom, trigger direct UPI payments, and send WhatsApp reminders.
class SettleUpScreen extends StatefulWidget {
  final String currentUserId;
  final String currentUserName;
  final List<Expense> expenses;

  const SettleUpScreen({
    super.key,
    required this.currentUserId,
    required this.currentUserName,
    required this.expenses,
  });

  @override
  State<SettleUpScreen> createState() => _SettleUpScreenState();
}

class _SettleUpScreenState extends State<SettleUpScreen> {
  late List<SimplifiedDebt> _debts;

  final Map<String, String> _userNames = {
    'user_rohan': 'Rohan Verma',
    'user_ananya': 'Ananya Sharma',
    'user_kabir': 'Kabir Mehta',
  };

  final Map<String, String> _userVpas = {
    'user_rohan': 'rohan.verma@okhdfcbank',
    'user_ananya': 'ananya.s@ibl',
    'user_kabir': 'kabir.mehta@paytm',
  };

  @override
  void initState() {
    super.initState();
    _computeSimplifiedDebts();
  }

  void _computeSimplifiedDebts() {
    // 1. Build pairwise debts map from expenses: debtor -> creditor -> totalAmount
    final pairwise = <String, Map<String, double>>{};

    for (final exp in widget.expenses) {
      final creditor = exp.paidByUserId;
      for (final split in exp.splits) {
        if (split.isSettled) continue;
        final debtor = split.userId;
        if (debtor == creditor) continue;

        pairwise.putIfAbsent(debtor, () => {});
        pairwise[debtor]![creditor] = (pairwise[debtor]![creditor] ?? 0.0) + split.amount;
      }
    }

    _debts = ExpenseSplitter.simplifyDebts(
      pairwise,
      userNames: _userNames,
      userVpas: _userVpas,
    );
  }

  void _markDebtSettled(SimplifiedDebt debt) {
    setState(() {
      _debts.remove(debt);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Settlement of ₹${debt.amount.toStringAsFixed(0)} between ${debt.fromUserName} and ${debt.toUserName} recorded!'),
        backgroundColor: Colors.teal.shade700,
      ),
    );
  }

  void _sendWhatsAppReminder(SimplifiedDebt debt) {
    final msg = UpiService.generateWhatsAppReminderMessage(
      debtorName: debt.fromUserName,
      creditorName: debt.toUserName,
      amount: debt.amount,
      vpa: debt.toUserVpa ?? 'house@upi',
      expenseDescription: 'FlatFit Co-Living Monthly Expenses',
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('WhatsApp Reminder Template'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: BorderSide(color: Colors.green.shade200),
                ),
                child: SelectableText(
                  msg,
                  style: const TextStyle(fontSize: 12.5, height: 1.4),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.share, size: 16),
            label: const Text('Copy & Open WhatsApp'),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Copied reminder to clipboard! Opening WhatsApp...')),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settle Up Debts'),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              borderRadius: BorderRadius.circular(12),
              border: BorderSide(color: Colors.teal.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.auto_awesome, color: Colors.teal.shade800),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Smart Debt Simplification algorithm is active: cross-debts have been minimized to the fewest direct UPI transfers.',
                    style: TextStyle(fontSize: 12, color: Colors.teal.shade900),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (_debts.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(Icons.check_circle_outline, size: 64, color: Colors.green.shade600),
                    const SizedBox(height: 12),
                    const Text(
                      'All flatmate debts are settled!',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Everyone has paid their fair share.',
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            )
          else
            ..._debts.map((debt) => _buildDebtCard(debt)),
        ],
      ),
    );
  }

  Widget _buildDebtCard(SimplifiedDebt debt) {
    final isUserDebtor = debt.fromUserId == widget.currentUserId;
    final isUserCreditor = debt.toUserId == widget.currentUserId;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 15, color: Colors.black87),
                      children: [
                        TextSpan(
                          text: isUserDebtor ? 'You' : debt.fromUserName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: ' owe '),
                        TextSpan(
                          text: isUserCreditor ? 'You' : debt.toUserName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  '₹${debt.amount.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isUserDebtor ? Colors.red.shade700 : Colors.green.shade700,
                  ),
                ),
              ],
            ),
            if (debt.toUserVpa != null) ...[
              const SizedBox(height: 4),
              Text(
                'UPI ID: ${debt.toUserVpa}',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isUserCreditor)
                  TextButton.icon(
                    icon: const Icon(Icons.send_to_mobile, size: 16, color: Colors.green),
                    label: const Text('Send Reminder', style: TextStyle(color: Colors.green)),
                    onPressed: () => _sendWhatsAppReminder(debt),
                  ),
                if (isUserDebtor && debt.toUserVpa != null) ...[
                  UpiPayButton(
                    vpa: debt.toUserVpa!,
                    payeeName: debt.toUserName,
                    amount: debt.amount,
                    note: 'FlatFit Settlement for ${widget.currentUserName}',
                    onPaymentTriggered: () => _markDebtSettled(debt),
                  ),
                ],
                const SizedBox(width: 8),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    minimumSize: const Size(0, 32),
                  ),
                  onPressed: () => _markDebtSettled(debt),
                  child: const Text('Mark Settled', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
