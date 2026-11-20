import 'package:flutter/material.dart';
import '../widgets/emergency_contacts_form.dart';
import '../widgets/safety_sos_button.dart';
import '../widgets/women_only_toggle.dart';

class SafetyCenterScreen extends StatefulWidget {
  const SafetyCenterScreen({Key? key}) : super(key: key);

  @override
  State<SafetyCenterScreen> createState() => _SafetyCenterScreenState();
}

class _SafetyCenterScreenState extends State<SafetyCenterScreen> {
  bool _isWomenOnlyEnabled = false;
  bool _isLiveLocationShared = false;
  final List<EmergencyContact> _emergencyContacts = [
    EmergencyContact(name: 'Aditi (Sister)', relationship: 'Family', phone: '+91 98201 12345'),
    EmergencyContact(name: 'Rajesh (Friend)', relationship: 'Friend', phone: '+91 98192 67890'),
  ];

  void _triggerEmergencySos() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 8),
            Text('SOS Alert Triggered'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Emergency SMS with your current GPS coordinates has been dispatched to your contacts:',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 8),
            ..._emergencyContacts.map((c) => Text('• ${c.name} (${c.phone})', style: const TextStyle(fontWeight: FontWeight.bold))),
            const SizedBox(height: 12),
            const Text('Local authorities helpline: 112 (National Emergency Number in India)'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Dismiss Alert'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('FlatFit Safety & Trust Hub'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // High Visibility Emergency SOS Button
            const Text(
              'Emergency Quick Assistance',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Press and hold for 2 seconds to alert trusted contacts with live GPS location.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            SafetySosButton(onTriggerSos: _triggerEmergencySos),
            const SizedBox(height: 28),

            // Women-Only Mode Toggle
            WomenOnlyToggle(
              isEnabled: _isWomenOnlyEnabled,
              onChanged: (val) {
                setState(() => _isWomenOnlyEnabled = val);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      val
                          ? 'Women-Only Mode Activated: Listings and matches filtered.'
                          : 'Women-Only Mode Deactivated.',
                    ),
                    backgroundColor: const Color(0xFFDB2777),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Emergency Contacts Management
            EmergencyContactsForm(
              initialContacts: _emergencyContacts,
              onSave: (contacts) {
                setState(() {
                  _emergencyContacts.clear();
                  _emergencyContacts.addAll(contacts);
                });
              },
            ),
            const SizedBox(height: 24),

            // Co-Living Safety Principles
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Flatmate Safety Checklist',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('1. Never transfer security deposit to personal accounts before seeing the flat in person.', style: TextStyle(fontSize: 12, height: 1.4)),
                  SizedBox(height: 6),
                  Text('2. Insist on FlatFit digital agreement with clear exit and notice periods.', style: TextStyle(fontSize: 12, height: 1.4)),
                  SizedBox(height: 6),
                  Text('3. Schedule your first flatmate conversation at a neutral public cafe.', style: TextStyle(fontSize: 12, height: 1.4)),
                  SizedBox(height: 6),
                  Text('4. Confirm KYC badge on profile before signing any lease.', style: TextStyle(fontSize: 12, height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
