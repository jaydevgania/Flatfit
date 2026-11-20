import 'package:flutter/material.dart';
import 'package:flatfit/features/hub/domain/services/hub_service.dart';

/// Modal bottom sheet allowing users to publish one-tap guest & house announcements.
class GuestAnnouncementSheet extends StatefulWidget {
  final Function(GuestAnnouncementTemplate template, String? note) onAnnounce;

  const GuestAnnouncementSheet({
    super.key,
    required this.onAnnounce,
  });

  static Future<void> show(
    BuildContext context, {
    required Function(GuestAnnouncementTemplate template, String? note) onAnnounce,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => GuestAnnouncementSheet(onAnnounce: onAnnounce),
    );
  }

  @override
  State<GuestAnnouncementSheet> createState() => _GuestAnnouncementSheetState();
}

class _GuestAnnouncementSheetState extends State<GuestAnnouncementSheet> {
  GuestAnnouncementTemplate? _selectedTemplate;
  final _customNoteController = TextEditingController();

  @override
  void dispose() {
    _customNoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'One-Tap House Announcement',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Notify flatmates instantly with pre-filled guest or house alert templates.',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          ...GuestAnnouncementTemplate.presets.map((tmpl) {
            final isSelected = _selectedTemplate == tmpl;
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: isSelected ? Colors.teal.shade50 : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: BorderSide(
                  color: isSelected ? Colors.teal.shade600 : Colors.grey.shade200,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: ListTile(
                dense: true,
                title: Text(
                  tmpl.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: isSelected ? Colors.teal.shade900 : Colors.black87,
                  ),
                ),
                subtitle: Text(
                  tmpl.description,
                  style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
                ),
                trailing: isSelected
                    ? Icon(Icons.check_circle, color: Colors.teal.shade700)
                    : const Icon(Icons.radio_button_unchecked, size: 20),
                onTap: () {
                  setState(() => _selectedTemplate = tmpl);
                },
              ),
            );
          }),
          const SizedBox(height: 12),
          TextField(
            controller: _customNoteController,
            decoration: const InputDecoration(
              labelText: 'Optional Custom Note (e.g. "Arriving around 9 PM")',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.send_rounded),
              label: const Text(
                'Broadcast Announcement',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              onPressed: _selectedTemplate == null
                  ? null
                  : () {
                      widget.onAnnounce(
                        _selectedTemplate!,
                        _customNoteController.text.trim().isEmpty ? null : _customNoteController.text.trim(),
                      );
                      Navigator.pop(context);
                    },
            ),
          ),
        ],
      ),
    );
  }
}
