import 'package:flutter/material.dart';
import '../../domain/models/exit_models.dart';

/// Screen guiding flatmates through physical handover, keys return, and society move-out clearances.
class HandoverChecklistScreen extends StatefulWidget {
  final String exitRequestId;

  const HandoverChecklistScreen({
    super.key,
    required this.exitRequestId,
  });

  @override
  State<HandoverChecklistScreen> createState() => _HandoverChecklistScreenState();
}

class _HandoverChecklistScreenState extends State<HandoverChecklistScreen> {
  late List<HandoverItem> _items;

  @override
  void initState() {
    super.initState();
    _items = [
      const HandoverItem(
        id: 'hnd_1',
        title: 'Handover Main Door & Bedroom Keys',
        description: 'Return physical duplicate key sets and wardrobe locker keys to remaining flatmates.',
        isCompleted: true,
      ),
      const HandoverItem(
        id: 'hnd_2',
        title: 'Society Move-Out Gate Pass / NOC',
        description: 'Submit move-out letter to housing society office; ensure lift padding & security clearance are arranged.',
        isCompleted: true,
      ),
      const HandoverItem(
        id: 'hnd_3',
        title: 'Clear Domestic Staff (Maid & Cook) Dues',
        description: 'Ensure pro-rata salary for current month is paid to cook and maid.',
        isCompleted: true,
      ),
      const HandoverItem(
        id: 'hnd_4',
        title: 'Remove All Personal Belongings & Furniture',
        description: 'Verify bedroom, bathroom shelf, and fridge are completely cleared of personal items.',
        isCompleted: false,
      ),
      const HandoverItem(
        id: 'hnd_5',
        title: 'Security Deposit Refund Received & Confirmed',
        description: 'Verify full net deposit credited to recipient bank account / UPI ID.',
        isCompleted: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = _items.where((i) => i.isCompleted).length;
    final isAllDone = completedCount == _items.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Move-Out Handover Checklist'),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildProgressCard(completedCount, _items.length),
          const SizedBox(height: 16),
          const Text(
            'Physical Handover Items',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          ..._items.map((item) => _buildChecklistTile(item)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: isAllDone ? Colors.green.shade700 : Colors.teal.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.check_circle_outline),
            label: Text(
              isAllDone ? 'Handover Completed & Archiving Stay' : 'Complete Handover Protocol',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Handover protocol finalized. Farewell and best wishes! 🏡✨')),
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(int completed, int total) {
    final pct = total > 0 ? (completed / total) : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(14),
        border: BorderSide(color: Colors.teal.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Handover Completion',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.teal.shade900,
                ),
              ),
              Text(
                '$completed of $total steps completed',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.teal.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 8,
              backgroundColor: Colors.teal.shade100,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.teal.shade700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistTile(HandoverItem item) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Checkbox(
          value: item.isCompleted,
          activeColor: Colors.teal.shade700,
          onChanged: (val) {
            setState(() {
              final idx = _items.indexWhere((i) => i.id == item.id);
              if (idx != -1) {
                _items[idx] = _items[idx].copyWith(
                  isCompleted: val ?? false,
                  completedAt: (val == true) ? DateTime.now() : null,
                );
              }
            });
          },
        ),
        title: Text(
          item.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14.5,
            decoration: item.isCompleted ? TextDecoration.lineThrough : null,
            color: item.isCompleted ? Colors.grey.shade600 : Colors.black87,
          ),
        ),
        subtitle: Text(
          item.description,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ),
    );
  }
}
