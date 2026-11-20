import 'package:flutter/material.dart';
import '../../domain/models/exit_models.dart';

/// Screen allowing flatmates to conduct move-out damage inspection with clear legal protections.
class DamageInspectionScreen extends StatefulWidget {
  final String exitRequestId;
  final String currentUserId;

  const DamageInspectionScreen({
    super.key,
    required this.exitRequestId,
    required this.currentUserId,
  });

  @override
  State<DamageInspectionScreen> createState() => _DamageInspectionScreenState();
}

class _DamageInspectionScreenState extends State<DamageInspectionScreen> {
  late List<DamageInspectionItem> _items;

  @override
  void initState() {
    super.initState();
    _items = [
      const DamageInspectionItem(
        id: 'dmg_1',
        area: 'Bedroom Walls',
        itemDescription: 'Faint wall picture hook marks and sofa shadow',
        isNormalWearAndTear: true,
        estimatedRepairCost: 0.0,
      ),
      const DamageInspectionItem(
        id: 'dmg_2',
        area: 'Bathroom Door',
        itemDescription: 'Bottom water swelling & cracked lock latch',
        isNormalWearAndTear: false,
        estimatedRepairCost: 1200.0,
        photoUrl: 'https://flatfit.app/damages/latch_crack.jpg',
        isDeducted: true,
      ),
      const DamageInspectionItem(
        id: 'dmg_3',
        area: 'Window Blind',
        itemDescription: 'Balcony roller blind drawstring detached',
        isNormalWearAndTear: false,
        estimatedRepairCost: 450.0,
        isDeducted: true,
      ),
    ];
  }

  void _showAddItemDialog() {
    final areaCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final costCtrl = TextEditingController(text: '0');
    bool isWearAndTear = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Log Inspection Finding'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: areaCtrl,
                  decoration: const InputDecoration(labelText: 'Area / Fixture', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descCtrl,
                  decoration: const InputDecoration(labelText: 'Observation Description', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                CheckboxListTile(
                  title: const Text('Normal Wear & Tear?'),
                  subtitle: const Text('Under Model Tenancy Act, wear & tear cannot be deducted.'),
                  value: isWearAndTear,
                  onChanged: (val) {
                    setDialogState(() {
                      isWearAndTear = val ?? false;
                      if (isWearAndTear) costCtrl.text = '0';
                    });
                  },
                ),
                if (!isWearAndTear) ...[
                  const SizedBox(height: 8),
                  TextField(
                    controller: costCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Estimated Repair Cost',
                      prefixText: '₹ ',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal.shade700, foregroundColor: Colors.white),
              onPressed: () {
                if (areaCtrl.text.trim().isEmpty) return;
                setState(() {
                  _items.add(
                    DamageInspectionItem(
                      id: 'dmg_${DateTime.now().millisecondsSinceEpoch}',
                      area: areaCtrl.text.trim(),
                      itemDescription: descCtrl.text.trim(),
                      isNormalWearAndTear: isWearAndTear,
                      estimatedRepairCost: double.tryParse(costCtrl.text.trim()) ?? 0.0,
                      isDeducted: !isWearAndTear,
                    ),
                  );
                });
                Navigator.pop(ctx);
              },
              child: const Text('Add Finding'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalAgreedDeduction = _items
        .where((i) => !i.isNormalWearAndTear && i.isDeducted)
        .fold<double>(0.0, (s, i) => s + i.estimatedRepairCost);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Move-Out Damage Inspection'),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildLegalGuidelineCard(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Inspection Findings',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                'Total Repairs: ₹${totalAgreedDeduction.toStringAsFixed(0)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.red.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ..._items.map((item) => _buildItemTile(item)),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Damage inspection report locked and sent to Deposit Calculator!')),
              );
              Navigator.pop(context, _items);
            },
            child: const Text(
              'Confirm Inspection & Proceed to Settlement',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        onPressed: _showAddItemDialog,
        child: const Icon(Icons.add_a_photo_outlined),
      ),
    );
  }

  Widget _buildLegalGuidelineCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: BorderSide(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shield_outlined, color: Colors.blue.shade800),
              const SizedBox(width: 8),
              Text(
                'Wear & Tear Legal Standard',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.blue.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Under the Indian Model Tenancy Act, landlords and remaining flatmates cannot deduct security deposit for normal aging, minor paint discoloration, or natural fixture depreciation.',
            style: TextStyle(fontSize: 12, color: Colors.blue.shade900, height: 1.3),
          ),
        ],
      ),
    );
  }

  Widget _buildItemTile(DamageInspectionItem item) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: item.isNormalWearAndTear ? Colors.green.shade200 : Colors.red.shade200,
        ),
      ),
      child: ListTile(
        title: Text(item.area, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5)),
        subtitle: Text(
          item.itemDescription,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: item.isNormalWearAndTear ? Colors.green.shade50 : Colors.red.shade50,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                item.isNormalWearAndTear ? 'WEAR & TEAR (₹0)' : 'DEDUCT ₹${item.estimatedRepairCost.toStringAsFixed(0)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: item.isNormalWearAndTear ? Colors.green.shade800 : Colors.red.shade800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
