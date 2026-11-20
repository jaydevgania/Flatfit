import 'package:flutter/material.dart';

/// Top balance summary card showing net owed / get back amount.
class NetBalanceCard extends StatelessWidget {
  final double netBalance; // positive = owed to user, negative = user owes
  final double totalMonthSpend;
  final VoidCallback onSettleUp;
  final VoidCallback onAddExpense;

  const NetBalanceCard({
    super.key,
    required this.netBalance,
    required this.totalMonthSpend,
    required this.onSettleUp,
    required this.onAddExpense,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = netBalance > 0.009;
    final isNegative = netBalance < -0.009;

    Color badgeColor;
    String statusText;
    if (isPositive) {
      badgeColor = Colors.green.shade700;
      statusText = 'You are owed';
    } else if (isNegative) {
      badgeColor = Colors.red.shade700;
      statusText = 'You owe';
    } else {
      badgeColor = Colors.teal.shade800;
      statusText = 'You are all settled up!';
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade800, Colors.teal.shade900],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.shade900.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                statusText.toUpperCase(),
                style: TextStyle(
                  color: Colors.teal.shade100,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Flat Spend: ₹${totalMonthSpend.toStringAsFixed(0)}',
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            (isPositive || isNegative)
                ? '₹${netBalance.abs().toStringAsFixed(0)}'
                : '₹0.00',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.teal.shade900,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Expense', style: TextStyle(fontWeight: FontWeight.bold)),
                  onPressed: onAddExpense,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade700,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.sync_alt, size: 18),
                  label: const Text('Settle Up', style: TextStyle(fontWeight: FontWeight.bold)),
                  onPressed: onSettleUp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
