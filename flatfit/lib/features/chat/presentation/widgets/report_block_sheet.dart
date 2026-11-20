import 'package:flutter/material.dart';

class ReportBlockSheet extends StatefulWidget {
  final String targetUserName;
  final Function(String reason, String? description) onReport;
  final VoidCallback onBlock;

  const ReportBlockSheet({
    Key? key,
    required this.targetUserName,
    required this.onReport,
    required this.onBlock,
  }) : super(key: key);

  static void show(
    BuildContext context, {
    required String targetUserName,
    required Function(String reason, String? description) onReport,
    required VoidCallback onBlock,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ReportBlockSheet(
          targetUserName: targetUserName,
          onReport: onReport,
          onBlock: onBlock,
        ),
      ),
    );
  }

  @override
  State<ReportBlockSheet> createState() => _ReportBlockSheetState();
}

class _ReportBlockSheetState extends State<ReportBlockSheet> {
  String? _selectedReason;
  final TextEditingController _detailsController = TextEditingController();
  bool _isSubmitted = false;

  final List<String> _reportReasons = [
    'Demanding advance deposit without agreement',
    'Off-platform payment or contact insistence',
    'Inappropriate language or harassment',
    'Fake profile or impersonation',
    'Misleading room listing information',
    'Spam or advertising commercial services',
  ];

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  void _submitReport() {
    if (_selectedReason == null) return;
    widget.onReport(_selectedReason!, _detailsController.text.trim());
    setState(() {
      _isSubmitted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isSubmitted) {
      return Container(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.green, size: 52),
            const SizedBox(height: 14),
            const Text(
              'Report Submitted',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Thank you for keeping FlatFit safe. Our moderation team reviews reports within 1 hour.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Safety & Moderation',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Options for ${widget.targetUserName}',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
          const Divider(height: 24),
          const Text(
            'Select Reason to Report:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          ..._reportReasons.map((reason) {
            return RadioListTile<String>(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(reason, style: const TextStyle(fontSize: 13)),
              value: reason,
              groupValue: _selectedReason,
              activeColor: const Color(0xFF6366F1),
              onChanged: (val) {
                setState(() {
                  _selectedReason = val;
                });
              },
            );
          }).toList(),
          const SizedBox(height: 8),
          TextField(
            controller: _detailsController,
            decoration: InputDecoration(
              hintText: 'Additional details (optional)...',
              hintStyle: const TextStyle(fontSize: 13),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red.shade700,
                    side: BorderSide(color: Colors.red.shade300),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onBlock();
                  },
                  child: const Text('Block User'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _selectedReason != null ? _submitReport : null,
                  child: const Text('Submit Report'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
