import 'package:flutter/material.dart';

/// Button that triggers the "Send Interest" flow with an optional introductory note.
class InterestButton extends StatefulWidget {
  final String targetUserName;
  final Future<void> Function(String? note, bool isSuperInterest) onSend;
  final bool isSuper;

  const InterestButton({
    super.key,
    required this.targetUserName,
    required this.onSend,
    this.isSuper = false,
  });

  @override
  State<InterestButton> createState() => _InterestButtonState();
}

class _InterestButtonState extends State<InterestButton> {
  bool _isSending = false;

  void _showNoteDialog() {
    final noteController = TextEditingController();
    bool superChoice = widget.isSuper;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        superChoice ? Icons.star_rounded : Icons.favorite_rounded,
                        color: superChoice ? Colors.amber : const Color(0xFF4F46E5),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        superChoice
                            ? 'Super Interest in ${widget.targetUserName}'
                            : 'Connect with ${widget.targetUserName}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add a short intro note to stand out (optional):',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: noteController,
                    maxLines: 3,
                    maxLength: 140,
                    decoration: InputDecoration(
                      hintText:
                          'Hey! Looking for a 2BHK flatmate in Bandra. Would love to connect!',
                      hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Checkbox(
                        value: superChoice,
                        activeColor: const Color(0xFF4F46E5),
                        onChanged: (val) {
                          setModalState(() {
                            superChoice = val ?? false;
                          });
                        },
                      ),
                      const Text(
                        'Send as Super Interest ⭐ (priority alert)',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: superChoice
                            ? const Color(0xFFF59E0B)
                            : const Color(0xFF4F46E5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.of(ctx).pop();
                        setState(() => _isSending = true);
                        try {
                          await widget.onSend(
                            noteController.text.trim().isEmpty
                                ? null
                                : noteController.text.trim(),
                            superChoice,
                          );
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Interest sent to ${widget.targetUserName}!'),
                                backgroundColor: const Color(0xFF10B981),
                              ),
                            );
                          }
                        } finally {
                          if (mounted) setState(() => _isSending = false);
                        }
                      },
                      child: Text(
                        superChoice ? 'Send Super Interest ⭐' : 'Send Interest',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isSending) {
      return const SizedBox(
        width: 32,
        height: 32,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (widget.isSuper) {
      return ElevatedButton.icon(
        onPressed: _showNoteDialog,
        icon: const Icon(Icons.star_rounded, size: 18, color: Colors.white),
        label: const Text('Super Interest'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF59E0B),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }

    return ElevatedButton.icon(
      onPressed: _showNoteDialog,
      icon: const Icon(Icons.favorite_rounded, size: 18, color: Colors.white),
      label: const Text('Send Interest'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4F46E5),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
