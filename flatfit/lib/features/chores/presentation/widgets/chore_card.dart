import 'package:flutter/material.dart';
import '../../domain/models/chore_models.dart';

/// Card displaying a chore assignment with completion toggle, effort points, and assignee chip.
class ChoreCard extends StatelessWidget {
  final ChoreAssignment assignment;
  final String currentUserId;
  final ValueChanged<bool> onToggleComplete;
  final VoidCallback? onNudge;
  final VoidCallback? onSwap;

  const ChoreCard({
    super.key,
    required this.assignment,
    required this.currentUserId,
    required this.onToggleComplete,
    this.onNudge,
    this.onSwap,
  });

  Color _getEffortColor(ChoreEffort effort) {
    switch (effort) {
      case ChoreEffort.light:
        return Colors.green.shade700;
      case ChoreEffort.medium:
        return Colors.orange.shade800;
      case ChoreEffort.heavy:
        return Colors.deepPurple.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAssignedToMe = assignment.userId == currentUserId;
    final isDone = assignment.isCompleted;
    final isLate = assignment.isOverdue;
    final effortColor = _getEffortColor(assignment.effort);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      elevation: isDone ? 0.5 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: isLate
              ? Colors.red.shade300
              : isDone
                  ? Colors.green.shade100
                  : Colors.grey.shade200,
        ),
      ),
      color: isDone ? Colors.grey.shade50 : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(
                  value: isDone,
                  activeColor: Colors.green.shade700,
                  onChanged: (val) {
                    if (val != null) onToggleComplete(val);
                  },
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        assignment.choreTitle,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          decoration: isDone ? TextDecoration.lineThrough : null,
                          color: isDone ? Colors.grey.shade500 : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            isAssignedToMe ? 'Assigned to you' : 'Assigned to ${assignment.userName}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isAssignedToMe ? FontWeight.bold : FontWeight.normal,
                              color: isAssignedToMe ? Colors.teal.shade800 : Colors.grey.shade600,
                            ),
                          ),
                          if (isLate) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'OVERDUE',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red.shade700,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: effortColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${assignment.effortPoints} pt${assignment.effortPoints > 1 ? "s" : ""}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: effortColor,
                    ),
                  ),
                ),
              ],
            ),
            if (!isDone) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (isAssignedToMe && onSwap != null)
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        minimumSize: const Size(0, 28),
                      ),
                      icon: const Icon(Icons.swap_horiz, size: 16),
                      label: const Text('Swap Chore', style: TextStyle(fontSize: 11)),
                      onPressed: onSwap,
                    ),
                  if (!isAssignedToMe && onNudge != null)
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        minimumSize: const Size(0, 28),
                      ),
                      icon: const Icon(Icons.notifications_active_outlined, size: 16, color: Colors.amber),
                      label: const Text('Send Nudge', style: TextStyle(fontSize: 11, color: Colors.amber)),
                      onPressed: onNudge,
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
