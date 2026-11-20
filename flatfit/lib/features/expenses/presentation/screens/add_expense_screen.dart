import 'package:flutter/material.dart';
import '../../domain/models/expense_models.dart';
import '../../domain/services/expense_splitter.dart';
import '../widgets/category_icon.dart';

/// Screen allowing flatmates to record an expense with Equal, Custom Ratio, or Itemized split logic.
class AddExpenseScreen extends StatefulWidget {
  final String flatId;
  final String currentUserId;
  final String currentUserName;

  const AddExpenseScreen({
    super.key,
    required this.flatId,
    required this.currentUserId,
    this.currentUserName = 'Rohan Verma',
  });

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  ExpenseCategory _category = ExpenseCategory.groceries;
  late String _paidByUserId;
  late String _paidByName;

  late TabController _splitTabController;
  final List<String> _flatmateIds = ['user_rohan', 'user_ananya', 'user_kabir'];
  final Map<String, String> _flatmateNames = {
    'user_rohan': 'Rohan Verma',
    'user_ananya': 'Ananya Sharma',
    'user_kabir': 'Kabir Mehta',
  };

  // Equal split selection
  final Set<String> _selectedEqualUsers = {'user_rohan', 'user_ananya', 'user_kabir'};

  // Ratio split percentages
  final Map<String, TextEditingController> _ratioControllers = {
    'user_rohan': TextEditingController(text: '33.3'),
    'user_ananya': TextEditingController(text: '33.3'),
    'user_kabir': TextEditingController(text: '33.4'),
  };

  // Itemized split entries
  final List<ItemizedEntry> _itemizedEntries = [
    const ItemizedEntry(itemName: 'Organic Milk & Curd', amount: 120, assignedUserIds: ['user_rohan', 'user_ananya']),
    const ItemizedEntry(itemName: 'Protein Bread & Eggs', amount: 180, assignedUserIds: ['user_kabir']),
    const ItemizedEntry(itemName: 'Kitchen Detergent & Trash Bags', amount: 200, assignedUserIds: ['user_rohan', 'user_ananya', 'user_kabir']),
  ];

  @override
  void initState() {
    super.initState();
    _paidByUserId = widget.currentUserId;
    _paidByName = widget.currentUserName;
    _splitTabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    _splitTabController.dispose();
    for (final c in _ratioControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _saveExpense() {
    if (!_formKey.currentState!.validate()) return;
    final totalAmount = double.tryParse(_amountController.text.trim()) ?? 0.0;
    if (totalAmount <= 0) return;

    SplitType splitType;
    List<ExpenseSplit> splits = [];

    if (_splitTabController.index == 0) {
      // Equal split
      splitType = SplitType.equal;
      final splitResult = ExpenseSplitter.calculateEqualSplit(
        totalAmount: totalAmount,
        userIds: _selectedEqualUsers.toList(),
      );
      splits = splitResult.entries
          .map(
            (e) => ExpenseSplit(
              id: 'sp_${DateTime.now().millisecondsSinceEpoch}_${e.key}',
              expenseId: '',
              userId: e.key,
              userName: _flatmateNames[e.key] ?? e.key,
              amount: e.value,
            ),
          )
          .toList();
    } else if (_splitTabController.index == 1) {
      // Ratio split
      splitType = SplitType.customRatio;
      final ratios = <String, double>{};
      for (final uid in _flatmateIds) {
        ratios[uid] = double.tryParse(_ratioControllers[uid]!.text.trim()) ?? 1.0;
      }
      final splitResult = ExpenseSplitter.calculateRatioSplit(
        totalAmount: totalAmount,
        ratios: ratios,
      );
      splits = splitResult.entries
          .map(
            (e) => ExpenseSplit(
              id: 'sp_${DateTime.now().millisecondsSinceEpoch}_${e.key}',
              expenseId: '',
              userId: e.key,
              userName: _flatmateNames[e.key] ?? e.key,
              amount: e.value,
            ),
          )
          .toList();
    } else {
      // Itemized split
      splitType = SplitType.itemized;
      final itemizedTotal = _itemizedEntries.fold<double>(0.0, (s, i) => s + i.amount);
      final taxesOrShared = totalAmount > itemizedTotal ? (totalAmount - itemizedTotal) : 0.0;

      final splitResult = ExpenseSplitter.calculateItemizedSplit(
        items: _itemizedEntries,
        sharedTaxesAndFees: taxesOrShared,
      );
      splits = splitResult.entries
          .map(
            (e) => ExpenseSplit(
              id: 'sp_${DateTime.now().millisecondsSinceEpoch}_${e.key}',
              expenseId: '',
              userId: e.key,
              userName: _flatmateNames[e.key] ?? e.key,
              amount: e.value,
            ),
          )
          .toList();
    }

    final newExpense = Expense(
      id: 'exp_${DateTime.now().millisecondsSinceEpoch}',
      flatId: widget.flatId,
      paidByUserId: _paidByUserId,
      paidByName: _paidByName,
      title: _titleController.text.trim(),
      amount: totalAmount,
      category: _category,
      description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
      date: DateTime.now(),
      splitType: splitType,
      splits: splits,
      createdAt: DateTime.now(),
    );

    Navigator.pop(context, newExpense);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add House Expense'),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Expense Title',
                hintText: 'e.g. WiFi bill, Cook salary, BigBasket groceries',
                border: OutlineInputBorder(),
              ),
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Total Amount (₹)',
                prefixText: '₹ ',
                border: OutlineInputBorder(),
              ),
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            const Text('Expense Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            _buildCategorySelector(),
            const SizedBox(height: 16),
            _buildPaidBySelector(),
            const SizedBox(height: 16),
            const Text('Split Calculation', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            TabBar(
              controller: _splitTabController,
              indicatorColor: Colors.teal.shade700,
              labelColor: Colors.teal.shade800,
              tabs: const [
                Tab(text: 'Equal Split'),
                Tab(text: 'Ratio Split'),
                Tab(text: 'Itemized Bill'),
              ],
            ),
            SizedBox(
              height: 200,
              child: TabBarView(
                controller: _splitTabController,
                children: [
                  _buildEqualSplitView(),
                  _buildRatioSplitView(),
                  _buildItemizedSplitView(),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _saveExpense,
              child: const Text(
                'Record & Calculate Splits',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: ExpenseCategory.values.map((cat) {
          final isSelected = _category == cat;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              avatar: ExpenseCategoryIcon(category: cat, radius: 12),
              label: Text(ExpenseCategoryIcon.getLabel(cat)),
              selected: isSelected,
              onSelected: (val) {
                if (val) setState(() => _category = cat);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPaidBySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Paid By', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _paidByUserId,
          decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true),
          items: _flatmateIds
              .map((id) => DropdownMenuItem(
                    value: id,
                    child: Text(_flatmateNames[id] ?? id),
                  ))
              .toList(),
          onChanged: (val) {
            if (val != null) {
              setState(() {
                _paidByUserId = val;
                _paidByName = _flatmateNames[val] ?? val;
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildEqualSplitView() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: _flatmateIds.map((id) {
        final isSelected = _selectedEqualUsers.contains(id);
        return CheckboxListTile(
          dense: true,
          title: Text(_flatmateNames[id] ?? id),
          value: isSelected,
          activeColor: Colors.teal.shade700,
          onChanged: (val) {
            setState(() {
              if (val == true) {
                _selectedEqualUsers.add(id);
              } else if (_selectedEqualUsers.length > 1) {
                _selectedEqualUsers.remove(id);
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildRatioSplitView() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: _flatmateIds.map((id) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Expanded(flex: 2, child: Text(_flatmateNames[id] ?? id)),
              Expanded(
                flex: 1,
                child: TextField(
                  controller: _ratioControllers[id],
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    suffixText: '%',
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildItemizedSplitView() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        ..._itemizedEntries.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${item.itemName} (₹${item.amount.toStringAsFixed(0)})',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  Text(
                    '${item.assignedUserIds.length} users',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            )),
        const SizedBox(height: 8),
        Text(
          'Taxes & delivery fees are automatically split proportionally.',
          style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
