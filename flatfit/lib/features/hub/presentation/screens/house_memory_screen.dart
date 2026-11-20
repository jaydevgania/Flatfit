import 'package:flutter/material.dart';
import 'package:flatfit/features/hub/domain/models/hub_models.dart';
import '../widgets/appliance_card.dart';

/// Screen managing House Memory: appliance purchase logs, warranties, and technician contacts.
class HouseMemoryScreen extends StatefulWidget {
  final String flatId;
  final String currentUserId;

  const HouseMemoryScreen({
    super.key,
    required this.flatId,
    required this.currentUserId,
  });

  @override
  State<HouseMemoryScreen> createState() => _HouseMemoryScreenState();
}

class _HouseMemoryScreenState extends State<HouseMemoryScreen> {
  late List<ApplianceMemoryItem> _appliances;

  @override
  void initState() {
    super.initState();
    _appliances = _getSampleAppliances();
  }

  List<ApplianceMemoryItem> _getSampleAppliances() {
    return [
      ApplianceMemoryItem(
        id: 'app_1',
        flatId: widget.flatId,
        itemName: 'Samsung Double Door Inverter Refrigerator',
        brandAndModel: 'Samsung RT28T3722S9 (253 L)',
        description: 'Jointly purchased in Oct 2025; 10 year compressor warranty',
        boughtByName: 'Rohan & Ananya',
        cost: 26500,
        purchaseDate: DateTime(2025, 10, 15),
        warrantyExpiry: DateTime.now().add(const Duration(days: 310)),
        billReceiptUrl: 'https://flatfit.app/invoices/samsung_fridge.pdf',
        technicianContact: '1800-40-7267864 (Samsung Care)',
        condition: 'excellent',
        createdAt: DateTime.now(),
      ),
      ApplianceMemoryItem(
        id: 'app_2',
        flatId: widget.flatId,
        itemName: 'Kent Grand Plus RO Water Purifier',
        brandAndModel: 'Kent Grand+ 9L RO+UV+UF',
        description: 'AMC renewed with local Kent technician for filter change',
        boughtByName: 'Flat 402 Pool',
        cost: 14500,
        purchaseDate: DateTime(2024, 6, 1),
        warrantyExpiry: DateTime.now().add(const Duration(days: 45)),
        billReceiptUrl: 'https://flatfit.app/invoices/kent_ro.pdf',
        technicianContact: '+91 98201 44321 (Ramesh Kent)',
        condition: 'good',
        createdAt: DateTime.now(),
      ),
      ApplianceMemoryItem(
        id: 'app_3',
        flatId: widget.flatId,
        itemName: 'LG 7.5kg Front Load Washing Machine',
        brandAndModel: 'LG FHT1408ZWL',
        description: 'Direct Drive motor, purchased on Amazon India',
        boughtByName: 'Kabir Mehta',
        cost: 32000,
        purchaseDate: DateTime(2024, 2, 10),
        warrantyExpiry: DateTime.now().subtract(const Duration(days: 20)),
        billReceiptUrl: 'https://flatfit.app/invoices/lg_washing.pdf',
        technicianContact: '1800-315-9999 (LG Service)',
        condition: 'good',
        createdAt: DateTime.now(),
      ),
    ];
  }

  void _showAddApplianceDialog() {
    final nameCtrl = TextEditingController();
    final brandCtrl = TextEditingController();
    final costCtrl = TextEditingController();
    final techCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Appliance to House Memory'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Appliance Name',
                  hintText: 'e.g. Living Room AC, Microwave, Geyser',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: brandCtrl,
                decoration: const InputDecoration(
                  labelText: 'Brand & Model',
                  hintText: 'e.g. Daikin 1.5 Ton 5 Star',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: costCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Purchase Cost',
                  prefixText: '₹ ',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: techCtrl,
                decoration: const InputDecoration(
                  labelText: 'Service Technician Contact',
                  hintText: 'e.g. Urban Company or brand toll-free',
                  border: OutlineInputBorder(),
                ),
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
                _appliances.insert(
                  0,
                  ApplianceMemoryItem(
                    id: 'app_${DateTime.now().millisecondsSinceEpoch}',
                    flatId: widget.flatId,
                    itemName: nameCtrl.text.trim(),
                    brandAndModel: brandCtrl.text.trim().isEmpty ? null : brandCtrl.text.trim(),
                    cost: double.tryParse(costCtrl.text.trim()),
                    technicianContact: techCtrl.text.trim().isEmpty ? null : techCtrl.text.trim(),
                    purchaseDate: DateTime.now(),
                    warrantyExpiry: DateTime.now().add(const Duration(days: 365)),
                    createdAt: DateTime.now(),
                  ),
                );
              });
              Navigator.pop(ctx);
            },
            child: const Text('Add Appliance'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('House Memory & Warranties'),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              borderRadius: BorderRadius.circular(12),
              border: BorderSide(color: Colors.teal.shade100),
            ),
            child: Row(
              children: [
                Icon(Icons.shield_outlined, color: Colors.teal.shade800, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Track house asset purchases, active manufacturer warranties, and technician contacts so no flatmate loses receipts when maintenance is needed.',
                    style: TextStyle(fontSize: 12, color: Colors.teal.shade900, height: 1.3),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ..._appliances.map(
            (item) => ApplianceCard(
              item: item,
              onCallTechnician: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Dialing ${item.technicianContact}...')),
                );
              },
              onViewInvoice: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening digital purchase receipt & tax invoice...')),
                );
              },
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Log Appliance / Bill'),
        onPressed: _showAddApplianceDialog,
      ),
    );
  }
}
