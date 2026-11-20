import 'package:flutter/material.dart';
import '../../domain/models/expense_models.dart';
import '../widgets/balance_card.dart';
import '../widgets/expense_list_tile.dart';
import 'add_expense_screen.dart';
import 'settle_up_screen.dart';
import 'rent_collection_screen.dart';
import 'monthly_summary_screen.dart';

/// Central Expenses & Splitter Dashboard screen.
class ExpensesDashboardScreen extends StatefulWidget {
  final String flatId;
  final String currentUserId;
  final String currentUserName;

  const ExpensesDashboardScreen({
    super.key,
    required this.flatId,
    required this.currentUserId,
    this.currentUserName = 'Rohan Verma',
  });

  @override
  State<ExpensesDashboardScreen> createState() => _ExpensesDashboardScreenState();
}

class _ExpensesDashboardScreenState extends State<ExpensesDashboardScreen> {
  late List<Expense> _expenses;

  @override
  void initState() {
    super.initState();
    _expenses = _getSampleExpenses();
  }

  List<Expense> _getSampleExpenses() {
    final now = DateTime.now();
    return [
      Expense(
        id: 'exp_1',
        flatId: widget.flatId,
        paidByUserId: widget.currentUserId,
        paidByName: widget.currentUserName,
        title: 'Electricity Bill (Adani Electricity)',
        amount: 3450,
        category: ExpenseCategory.electricity,
        date: now.subtract(const Duration(days: 2)),
        splitType: SplitType.equal,
        splits: [
          ExpenseSplit(id: 's1', expenseId: 'exp_1', userId: widget.currentUserId, userName: widget.currentUserName, amount: 1150),
          const ExpenseSplit(id: 's2', expenseId: 'exp_1', userId: 'user_ananya', userName: 'Ananya Sharma', amount: 1150),
          const ExpenseSplit(id: 's3', expenseId: 'exp_1', userId: 'user_kabir', userName: 'Kabir Mehta', amount: 1150),
        ],
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      Expense(
        id: 'exp_2',
        flatId: widget.flatId,
        paidByUserId: 'user_ananya',
        paidByName: 'Ananya Sharma',
        title: 'Monthly Cook (Sunita Bai)',
        amount: 6000,
        category: ExpenseCategory.cook,
        date: now.subtract(const Duration(days: 5)),
        splitType: SplitType.equal,
        splits: [
          ExpenseSplit(id: 's4', expenseId: 'exp_2', userId: widget.currentUserId, userName: widget.currentUserName, amount: 2000),
          const ExpenseSplit(id: 's5', expenseId: 'exp_2', userId: 'user_ananya', userName: 'Ananya Sharma', amount: 2000),
          const ExpenseSplit(id: 's6', expenseId: 'exp_2', userId: 'user_kabir', userName: 'Kabir Mehta', amount: 2000),
        ],
        createdAt: now.subtract(const Duration(days: 5)),
      ),
      Expense(
        id: 'exp_3',
        flatId: widget.flatId,
        paidByUserId: 'user_kabir',
        paidByName: 'Kabir Mehta',
        title: 'ACT Fibernet 300 Mbps WiFi',
        amount: 1180,
        category: ExpenseCategory.wifi,
        date: now.subtract(const Duration(days: 7)),
        splitType: SplitType.equal,
        splits: [
          ExpenseSplit(id: 's7', expenseId: 'exp_3', userId: widget.currentUserId, userName: widget.currentUserName, amount: 394),
          const ExpenseSplit(id: 's8', expenseId: 'exp_3', userId: 'user_ananya', userName: 'Ananya Sharma', amount: 393),
          const ExpenseSplit(id: 's9', expenseId: 'exp_3', userId: 'user_kabir', userName: 'Kabir Mehta', amount: 393),
        ],
        createdAt: now.subtract(const Duration(days: 7)),
      ),
    ];
  }

  double _calculateNetBalance() {
    double net = 0.0;
    for (final exp in _expenses) {
      if (exp.paidByUserId == widget.currentUserId) {
        // You paid, everyone else owes you
        for (final s in exp.splits) {
          if (s.userId != widget.currentUserId && !s.isSettled) {
            net += s.amount;
          }
        }
      } else {
        // Someone else paid, you owe your split
        for (final s in exp.splits) {
          if (s.userId == widget.currentUserId && !s.isSettled) {
            net -= s.amount;
          }
        }
      }
    }
    return net;
  }

  double _calculateTotalMonthSpend() {
    return _expenses.fold<double>(0.0, (s, e) => s + e.amount);
  }

  @override
  Widget build(BuildContext context) {
    final netBalance = _calculateNetBalance();
    final totalSpend = _calculateTotalMonthSpend();

    return Scaffold(
      appBar: AppBar(
        title: const Text('FlatFit Expenses & UPI Splitter'),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart_outlined),
            tooltip: 'Monthly Spending Summary',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MonthlySummaryScreen(
                    expenses: _expenses,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_balance),
            tooltip: 'Rent Collection Flow',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RentCollectionScreen(
                    flatId: widget.flatId,
                    currentUserId: widget.currentUserId,
                    currentUserName: widget.currentUserName,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NetBalanceCard(
              netBalance: netBalance,
              totalMonthSpend: totalSpend,
              onAddExpense: () async {
                final newExp = await Navigator.push<Expense>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddExpenseScreen(
                      flatId: widget.flatId,
                      currentUserId: widget.currentUserId,
                      currentUserName: widget.currentUserName,
                    ),
                  ),
                );
                if (newExp != null) {
                  setState(() => _expenses.insert(0, newExp));
                }
              },
              onSettleUp: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SettleUpScreen(
                      currentUserId: widget.currentUserId,
                      currentUserName: widget.currentUserName,
                      expenses: _expenses,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            _buildRentCollectionBanner(context),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent House Expenses',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${_expenses.length} records',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            ..._expenses.map(
              (exp) => ExpenseListTile(
                expense: exp,
                currentUserId: widget.currentUserId,
                onTap: () {
                  _showExpenseDetailsDialog(exp);
                },
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Expense'),
        onPressed: () async {
          final newExp = await Navigator.push<Expense>(
            context,
            MaterialPageRoute(
              builder: (_) => AddExpenseScreen(
                flatId: widget.flatId,
                currentUserId: widget.currentUserId,
                currentUserName: widget.currentUserName,
              ),
            ),
          );
          if (newExp != null) {
            setState(() => _expenses.insert(0, newExp));
          }
        },
      ),
    );
  }

  Widget _buildRentCollectionBanner(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(12),
        border: BorderSide(color: Colors.indigo.shade100),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.indigo.shade700,
            radius: 20,
            child: const Icon(Icons.real_estate_agent, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Monthly Rent Collection Cycle',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  'Collect shares via UPI -> Pay landlord before 5th of month.',
                  style: TextStyle(fontSize: 11.5, color: Colors.indigo.shade900),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              minimumSize: const Size(0, 32),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RentCollectionScreen(
                    flatId: widget.flatId,
                    currentUserId: widget.currentUserId,
                    currentUserName: widget.currentUserName,
                  ),
                ),
              );
            },
            child: const Text('Track', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  void _showExpenseDetailsDialog(Expense exp) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(exp.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Amount: ₹${exp.amount.toStringAsFixed(0)}'),
            Text('Paid by: ${exp.paidByName}'),
            Text('Category: ${exp.category.name.toUpperCase()}'),
            Text('Split Type: ${exp.splitType.name.toUpperCase()}'),
            const SizedBox(height: 12),
            const Text('Individual Splits:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            ...exp.splits.map((s) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(s.userName),
                      Text('₹${s.amount.toStringAsFixed(0)}'),
                    ],
                  ),
                )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
