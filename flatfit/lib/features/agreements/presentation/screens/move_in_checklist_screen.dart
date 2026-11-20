import 'package:flutter/material.dart';
import '../models/move_in_checklist_models.dart';
import '../widgets/checklist_item_tile.dart';

/// Screen enabling flatmates to inspect and document condition on move-in day.
class MoveInChecklistScreen extends StatefulWidget {
  final String agreementId;
  final String currentUserId;

  const MoveInChecklistScreen({
    super.key,
    required this.agreementId,
    required this.currentUserId,
  });

  @override
  State<MoveInChecklistScreen> createState() => _MoveInChecklistScreenState();
}

class _MoveInChecklistScreenState extends State<MoveInChecklistScreen> {
  late List<MoveInChecklistItem> _items;
  final _electricMeterController = TextEditingController(text: '42180.5');
  final _gasMeterController = TextEditingController(text: '128.4');

  @override
  void initState() {
    super.initState();
    _items = _getDefaultChecklist();
  }

  @override
  void dispose() {
    _electricMeterController.dispose();
    _gasMeterController.dispose();
    super.dispose();
  }

  List<MoveInChecklistItem> _getDefaultChecklist() {
    return [
      MoveInChecklistItem(
        id: 'chk_1',
        agreementId: widget.agreementId,
        userId: widget.currentUserId,
        item: 'Master Bedroom AC cooling & remote',
        area: ChecklistArea.appliances,
        condition: ItemCondition.good,
        isCompleted: true,
      ),
      MoveInChecklistItem(
        id: 'chk_2',
        agreementId: widget.agreementId,
        userId: widget.currentUserId,
        item: 'Living room wall paint & drill holes',
        area: ChecklistArea.livingRoom,
        condition: ItemCondition.minorWear,
        notes: 'Small patch near TV unit scuffed; photographed',
        photoUrls: ['https://flatfit.app/mock_damage_1.jpg'],
        isCompleted: true,
      ),
      MoveInChecklistItem(
        id: 'chk_3',
        agreementId: widget.agreementId,
        userId: widget.currentUserId,
        item: 'Geyser working & bathroom faucet leakage',
        area: ChecklistArea.bathroom,
        condition: ItemCondition.good,
      ),
      MoveInChecklistItem(
        id: 'chk_4',
        agreementId: widget.agreementId,
        userId: widget.currentUserId,
        item: 'Kitchen RO water purifier filter status',
        area: ChecklistArea.kitchen,
        condition: ItemCondition.needsRepair,
        notes: 'TDS reads 240; landlord notified to replace pre-filter',
      ),
      MoveInChecklistItem(
        id: 'chk_5',
        agreementId: widget.agreementId,
        userId: widget.currentUserId,
        item: 'Main door keys (2 sets) & society intercom',
        area: ChecklistArea.doorsWindowsKeys,
        condition: ItemCondition.good,
        isCompleted: true,
      ),
      MoveInChecklistItem(
        id: 'chk_6',
        agreementId: widget.agreementId,
        userId: widget.currentUserId,
        item: 'Refrigerator cooling & freezer tray integrity',
        area: ChecklistArea.appliances,
        condition: ItemCondition.good,
      ),
    ];
  }

  void _showAddNotesDialog(MoveInChecklistItem item) {
    final noteCtrl = TextEditingController(text: item.notes);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Condition Notes: ${item.item}'),
        content: TextField(
          controller: noteCtrl,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Describe pre-existing marks, paint scratches, or fixture issues...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final idx = _items.indexWhere((i) => i.id == item.id);
                if (idx != -1) {
                  _items[idx] = _items[idx].copyWith(notes: noteCtrl.text.trim());
                }
              });
              Navigator.pop(ctx);
            },
            child: const Text('Save Note'),
          ),
        ],
      ),
    );
  }

  void _simulateAddPhoto(MoveInChecklistItem item) {
    setState(() {
      final idx = _items.indexWhere((i) => i.id == item.id);
      if (idx != -1) {
        final currentPhotos = List<String>.from(_items[idx].photoUrls)
          ..add('https://flatfit.app/photo_${DateTime.now().millisecondsSinceEpoch}.jpg');
        _items[idx] = _items[idx].copyWith(photoUrls: currentPhotos);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Condition photo captured & timestamped with geotag.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = _items.where((i) => i.isCompleted).length;
    final progress = _items.isNotEmpty ? completedCount / _items.length : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Move-In Inspection'),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          _buildProgressBanner(completedCount, progress),
          _buildMeterReadingSection(),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Room Condition Checklist',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Item'),
                  onPressed: () {
                    setState(() {
                      _items.add(
                        MoveInChecklistItem(
                          id: 'chk_${DateTime.now().millisecondsSinceEpoch}',
                          agreementId: widget.agreementId,
                          userId: widget.currentUserId,
                          item: 'Wardrobe mirrors & drawers',
                          area: ChecklistArea.bedroom,
                        ),
                      );
                    });
                  },
                ),
              ],
            ),
          ),
          ..._items.map(
            (item) => ChecklistItemTile(
              item: item,
              onToggleComplete: (val) {
                setState(() {
                  final idx = _items.indexWhere((i) => i.id == item.id);
                  if (idx != -1) {
                    _items[idx] = _items[idx].copyWith(
                      isCompleted: val,
                      completedAt: val ? DateTime.now() : null,
                    );
                  }
                });
              },
              onAddPhoto: () => _simulateAddPhoto(item),
              onAddNotes: () => _showAddNotesDialog(item),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.verified),
              label: const Text(
                'Complete & Sign Move-In Inspection',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Move-in checklist locked and shared with all flatmates & landlord!'),
                  ),
                );
                Navigator.pop(context);
              },
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildProgressBanner(int completedCount, double progress) {
    return Container(
      color: Colors.teal.shade50,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Inspection Progress',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.teal.shade900,
                ),
              ),
              Text(
                '$completedCount of ${_items.length} verified',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Colors.teal.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.teal.shade100,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.teal.shade700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeterReadingSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: BorderSide(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.speed, color: Colors.amber.shade800),
              const SizedBox(width: 8),
              const Text(
                'Day 1 Utility Meter Readings',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Record starting readings so you never pay for past tenants’ electricity or piped gas consumption.',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _electricMeterController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Electricity (kWh)',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.camera_alt_outlined, size: 18),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _gasMeterController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Piped Gas (SCM)',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.camera_alt_outlined, size: 18),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
