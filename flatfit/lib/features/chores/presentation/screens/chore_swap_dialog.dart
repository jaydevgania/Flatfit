import 'package:flutter/material.dart';
import '../../domain/models/chore_models.dart';

/// Dialog allowing a flatmate to request swapping a chore with another flatmate.
class ChoreSwapDialog extends StatefulWidget {
  final ChoreAssignment assignment;
  final Map<String, String> memberNames;
  final String currentUserId;
  final Function(String targetUserId, String message) onSwapProposed;

  const ChoreSwapDialog({
    super.key,
    required this.assignment,
    required this.memberNames,
    required this.currentUserId,
    required this.onSwapProposed,
  });

  @override
  State<ChoreSwapDialog> createState() => _ChoreSwapDialogState();
}

class _ChoreSwapDialogState extends State<ChoreSwapDialog> {
  late String _selectedTargetUser;
  final _messageController = TextEditingController(
    text: 'Hey! I have a late office shift today; can we swap chores this week?',
  );

  @override
  void initState() {
    super.initState();
    final otherUsers = widget.memberNames.keys.where((k) => k != widget.currentUserId).toList();
    _selectedTargetUser = otherUsers.isNotEmpty ? otherUsers.first : '';
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final otherUsers = widget.memberNames.keys.where((k) => k != widget.currentUserId).toList();

    return AlertDialog(
      title: const Text('Swap Chore with Flatmate'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chore: "${widget.assignment.choreTitle}" (${widget.assignment.effortPoints} pts)',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5),
            ),
            const SizedBox(height: 12),
            const Text('Swap with:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: _selectedTargetUser.isNotEmpty ? _selectedTargetUser : null,
              decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true),
              items: otherUsers
                  .map((uid) => DropdownMenuItem(
                        value: uid,
                        child: Text(widget.memberNames[uid] ?? uid),
                      ))
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedTargetUser = val);
              },
            ),
            const SizedBox(height: 12),
            const Text('Reason / Note:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 6),
            TextField(
              controller: _messageController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Add a friendly note explaining why you want to swap...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal.shade700,
            foregroundColor: Colors.white,
          ),
          onPressed: _selectedTargetUser.isEmpty
              ? null
              : () {
                  widget.onSwapProposed(_selectedTargetUser, _messageController.text.trim());
                  Navigator.pop(context);
                },
          child: const Text('Send Swap Request'),
        ),
      ],
    );
  }
}
