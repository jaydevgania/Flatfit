import 'package:flutter/material.dart';
import '../../domain/models/expense_models.dart';
import 'category_icon.dart';

/// Reusable list item showing an expense entry with payer, category, and date.
class ExpenseListTile extends StatelessWidget {
  final Expense expense;
  final String currentUserId;
  final VoidCallback? onTap;

  const ExpenseListTile({
    super.key,
    required this.expense,
    required this.currentUserId,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isPaidByMe = expense.paidByUserId == currentUserId;
    final mySplit = expense.splits.firstWhere(
      (s) => s.userId == currentUserId,
      orElse: () => ExpenseSplit(
        id: '',
        expenseId: expense.id,
        userId: currentUserId,
        userName: 'Me',
        amount: 0.0,
      ),
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        onTap: onTap,
        leading: ExpenseCategoryIcon(category: expense.category),
        title: Text(
          expense.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5),
        ),
        subtitle: Text(
          '${isPaidByMe ? "You paid" : "${expense.paidByName} paid"} ₹${expense.amount.toStringAsFixed(0)} • ${_formatDate(expense.date)}',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              isPaidByMe
                  ? '+₹${(expense.amount - mySplit.amount).toStringAsFixed(0)}'
                  : '-₹${mySplit.amount.toStringAsFixed(0)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isPaidByMe ? Colors.green.shade700 : Colors.red.shade700,
              ),
            ),
            Text(
              isPaidByMe ? 'you lent' : 'your share',
              style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${dt.day} ${months[dt.month - 1]}';
  }
}
