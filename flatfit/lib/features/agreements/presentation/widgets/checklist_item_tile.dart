import 'package:flutter/material.dart';
import '../models/move_in_checklist_models.dart';

/// Reusable list tile displaying a move-in checklist inspection item.
class ChecklistItemTile extends StatelessWidget {
  final MoveInChecklistItem item;
  final ValueChanged<bool> onToggleComplete;
  final ValueChanged<ItemCondition>? onConditionChanged;
  final VoidCallback? onAddPhoto;
  final VoidCallback? onAddNotes;

  const ChecklistItemTile({
    super.key,
    required this.item,
    required this.onToggleComplete,
    this.onConditionChanged,
    this.onAddPhoto,
    this.onAddNotes,
  });

  Color _getConditionColor(ItemCondition condition) {
    switch (condition) {
      case ItemCondition.excellent:
      case ItemCondition.good:
        return Colors.green.shade700;
      case ItemCondition.minorWear:
        return Colors.orange.shade800;
      case ItemCondition.needsRepair:
      case ItemCondition.damaged:
      case ItemCondition.missing:
        return Colors.red.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    final conditionColor = _getConditionColor(item.condition);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: item.isCompleted ? Colors.grey.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: BorderSide(
          color: item.isCompleted ? Colors.green.shade200 : Colors.grey.shade200,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(
                  value: item.isCompleted,
                  activeColor: Colors.teal,
                  onChanged: (val) {
                    if (val != null) onToggleComplete(val);
                  },
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.item,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                          color: item.isCompleted ? Colors.grey.shade600 : Colors.black87,
                        ),
                      ),
                      Text(
                        item.area.name.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: conditionColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    item.condition.name.replaceAllMapped(
                      RegExp(r'([A-Z])'),
                      (m) => ' ${m.group(0)}',
                    ).toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: conditionColor,
                    ),
                  ),
                ),
              ],
            ),
            if (item.notes != null && item.notes!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(left: 48),
                child: Text(
                  'Note: ${item.notes}',
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 48),
              child: Row(
                children: [
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      minimumSize: const Size(0, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    icon: const Icon(Icons.camera_alt_outlined, size: 14),
                    label: Text(
                      item.photoUrls.isEmpty ? 'Add Photo' : '${item.photoUrls.length} Photos',
                      style: const TextStyle(fontSize: 11),
                    ),
                    onPressed: onAddPhoto,
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      minimumSize: const Size(0, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    icon: const Icon(Icons.edit_note, size: 14),
                    label: const Text('Add Note', style: TextStyle(fontSize: 11)),
                    onPressed: onAddNotes,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
