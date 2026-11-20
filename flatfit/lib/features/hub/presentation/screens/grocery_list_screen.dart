import 'package:flutter/material.dart';
import 'package:flatfit/features/hub/domain/models/hub_models.dart';

/// Screen managing the flat's shared grocery checklist and convert-to-expense flow.
class GroceryListScreen extends StatefulWidget {
  final String flatId;
  final String currentUserId;
  final String currentUserName;
  final List<GroceryItem>? items;

  const GroceryListScreen({
    super.key,
    required this.flatId,
    required this.currentUserId,
    required this.currentUserName,
    this.items,
  });

  @override
  State<GroceryListScreen> createState() => _GroceryListScreenState();
}

class _GroceryListScreenState extends State<GroceryListScreen> {
  late List<GroceryItem> _items;

  @override
  void initState() {
    super.initState();
    _items = widget.items != null ? List.from(widget.items!) : _getSampleItems();
  }

  List<GroceryItem> _getSampleItems() {
    return [
      GroceryItem(
        id: 'gro_1',
        flatId: widget.flatId,
        name: 'Amul Taaza Milk (2 Pouches)',
        quantity: '1 Litre',
        category: GroceryCategory.dairyAndEggs,
        addedByUserId: widget.currentUserId,
        addedByName: widget.currentUserName,
        estimatedCost: 66,
        createdAt: DateTime.now(),
      ),
      GroceryItem(
        id: 'gro_2',
        flatId: widget.flatId,
        name: 'Tata Salt & Fortune Sunflower Oil',
        quantity: '1L pouch',
        category: GroceryCategory.pantryAndSpices,
        addedByUserId: 'user_ananya',
        addedByName: 'Ananya Sharma',
        estimatedCost: 145,
        createdAt: DateTime.now(),
      ),
      GroceryItem(
        id: 'gro_3',
        flatId: widget.flatId,
        name: 'Vim Dishwash Gel & Scotch Brite',
        quantity: '500ml',
        category: GroceryCategory.cleaningAndToiletries,
        addedByUserId: 'user_kabir',
        addedByName: 'Kabir Mehta',
        isBought: true,
        boughtByUserId: widget.currentUserId,
        boughtByName: widget.currentUserName,
        estimatedCost: 110,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  void _showAddItemDialog() {
    final nameCtrl = TextEditingController();
    final qtyCtrl = TextEditingController();
    final costCtrl = TextEditingController();
    GroceryCategory selectedCat = GroceryCategory.pantryAndSpices;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Add Grocery Item'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Item Name',
                    hintText: 'e.g. Eggs, Coffee, Garbage bags',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: qtyCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Quantity',
                          hintText: 'e.g. 1 dozen / 500g',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: costCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Est. Cost',
                          prefixText: '₹ ',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<GroceryCategory>(
                  value: selectedCat,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: GroceryCategory.values
                      .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setDialogState(() => selectedCat = val);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade700,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (nameCtrl.text.trim().isEmpty) return;
                setState(() {
                  _items.insert(
                    0,
                    GroceryItem(
                      id: 'gro_${DateTime.now().millisecondsSinceEpoch}',
                      flatId: widget.flatId,
                      name: nameCtrl.text.trim(),
                      quantity: qtyCtrl.text.trim().isEmpty ? null : qtyCtrl.text.trim(),
                      estimatedCost: double.tryParse(costCtrl.text.trim()),
                      category: selectedCat,
                      addedByUserId: widget.currentUserId,
                      addedByName: widget.currentUserName,
                      createdAt: DateTime.now(),
                    ),
                  );
                });
                Navigator.pop(ctx);
              },
              child: const Text('Add to List'),
            ),
          ],
        ),
      ),
    );
  }

  void _splitBoughtItems() {
    final bought = _items.where((i) => i.isBought).toList();
    if (bought.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No purchased items to split. Mark items as bought first!')),
      );
      return;
    }

    final totalAmount = bought.fold<double>(0.0, (sum, item) => sum + (item.estimatedCost ?? 0.0));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Created ₹${totalAmount.toStringAsFixed(0)} Shared Grocery Expense in Expense Splitter!'),
        backgroundColor: Colors.teal.shade700,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pendingItems = _items.where((i) => !i.isBought).toList();
    final boughtItems = _items.where((i) => i.isBought).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shared Grocery List'),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.splitscreen),
            tooltip: 'Split Bought Items as Expense',
            onPressed: _splitBoughtItems,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          if (pendingItems.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'To Buy (${pendingItems.length})',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            ...pendingItems.map((item) => _buildGroceryTile(item)),
          ],
          if (boughtItems.isNotEmpty) ...[
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Recently Bought (${boughtItems.length})',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            ...boughtItems.map((item) => _buildGroceryTile(item)),
          ],
          const SizedBox(height: 80),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_shopping_cart),
        label: const Text('Add Grocery Item'),
        onPressed: _showAddItemDialog,
      ),
    );
  }

  Widget _buildGroceryTile(GroceryItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: item.isBought ? Colors.grey.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Checkbox(
          value: item.isBought,
          activeColor: Colors.teal.shade700,
          onChanged: (val) {
            setState(() {
              final idx = _items.indexWhere((i) => i.id == item.id);
              if (idx != -1) {
                _items[idx] = _items[idx].copyWith(
                  isBought: val ?? false,
                  boughtByUserId: (val == true) ? widget.currentUserId : null,
                  boughtByName: (val == true) ? widget.currentUserName : null,
                );
              }
            });
          },
        ),
        title: Text(
          item.name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14.5,
            decoration: item.isBought ? TextDecoration.lineThrough : null,
            color: item.isBought ? Colors.grey.shade500 : Colors.black87,
          ),
        ),
        subtitle: Text(
          '${item.quantity ?? "Standard"} • Added by ${item.addedByName.split(' ')[0]}',
          style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
        ),
        trailing: item.estimatedCost != null
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '₹${item.estimatedCost!.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.teal.shade900,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
