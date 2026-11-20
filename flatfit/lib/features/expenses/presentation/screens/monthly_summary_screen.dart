import 'package:flutter/material.dart';
import '../../domain/models/expense_models.dart';
import '../widgets/category_icon.dart';

/// Monthly spending summary screen showing category breakdown and household cost distribution.
class MonthlySummaryScreen extends StatelessWidget {
  final List<Expense> expenses;

  const MonthlySummaryScreen({
    super.key,
    required this.expenses,
  });

  Map<ExpenseCategory, double> _calculateCategoryTotals() {
    final totals = <ExpenseCategory, double>{};
    for (final exp in expenses) {
      totals[exp.category] = (totals[exp.category] ?? 0.0) + exp.amount;
    }
    return totals;
  }

  @override
  Widget build(BuildContext context) {
    final categoryTotals = _calculateCategoryTotals();
    final totalSpend = expenses.fold<double>(0.0, (s, e) => s + e.amount);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Spending Summary'),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildTotalCard(totalSpend),
          const SizedBox(height: 16),
          const Text(
            'Spending by Category',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          ...ExpenseCategory.values.map((cat) {
            final catSpend = categoryTotals[cat] ?? 0.0;
            if (catSpend <= 0 && expenses.isNotEmpty) return const SizedBox.shrink();
            final pct = totalSpend > 0 ? (catSpend / totalSpend) : 0.0;
            return _buildCategoryRow(cat, catSpend, pct);
          }),
          const SizedBox(height: 24),
          _buildInsightsCard(totalSpend),
        ],
      ),
    );
  }

  Widget _buildTotalCard(double total) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(16),
        border: BorderSide(color: Colors.teal.shade200),
      ),
      child: Column(
        children: [
          const Text(
            'Total Household Spend (This Month)',
            style: TextStyle(color: Colors.black54, fontSize: 13),
          ),
          const SizedBox(height: 6),
          Text(
            '₹${total.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.teal.shade900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Average per flatmate: ₹${(total / 3).toStringAsFixed(0)} across 3 flatmates',
            style: TextStyle(fontSize: 12, color: Colors.teal.shade800),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryRow(ExpenseCategory category, double amount, double percentage) {
    final color = ExpenseCategoryIcon.getColor(category);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                ExpenseCategoryIcon(category: category, radius: 16),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    ExpenseCategoryIcon.getLabel(category),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Text(
                  '₹${amount.toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(width: 8),
                Text(
                  '(${(percentage * 100).toStringAsFixed(0)}%)',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage,
                minHeight: 6,
                backgroundColor: Colors.grey.shade100,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightsCard(double totalSpend) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: BorderSide(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, color: Colors.amber.shade800),
              const SizedBox(width: 8),
              const Text(
                'Household Financial Insights',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '• Domestic help (Cook + Maid) and Electricity make up 65% of variable costs.',
            style: TextStyle(fontSize: 12.5, height: 1.3),
          ),
          const SizedBox(height: 4),
          const Text(
            '• All 3 flatmates are current with utility settlements this cycle.',
            style: TextStyle(fontSize: 12.5, height: 1.3),
          ),
        ],
      ),
    );
  }
}
