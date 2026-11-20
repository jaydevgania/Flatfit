import 'package:flutter/material.dart';

class EmergencyContact {
  String name;
  String relationship;
  String phone;

  EmergencyContact({
    required this.name,
    required this.relationship,
    required this.phone,
  });
}

class EmergencyContactsForm extends StatefulWidget {
  final List<EmergencyContact> initialContacts;
  final Function(List<EmergencyContact> contacts) onSave;

  const EmergencyContactsForm({
    Key? key,
    required this.initialContacts,
    required this.onSave,
  }) : super(key: key);

  @override
  State<EmergencyContactsForm> createState() => _EmergencyContactsFormState();
}

class _EmergencyContactsFormState extends State<EmergencyContactsForm> {
  late List<EmergencyContact> _contacts;

  @override
  void initState() {
    super.initState();
    _contacts = List.from(widget.initialContacts);
    if (_contacts.isEmpty) {
      _contacts.add(EmergencyContact(name: 'Mom / Dad', relationship: 'Parent', phone: '+91 98765 43210'));
    }
  }

  void _addContactDialog() {
    if (_contacts.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum 3 emergency contacts allowed.')),
      );
      return;
    }

    final nameController = TextEditingController();
    final relController = TextEditingController();
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Emergency Contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            TextField(
              controller: relController,
              decoration: const InputDecoration(labelText: 'Relationship (e.g. Sister, Friend)'),
            ),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone (+91)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && phoneController.text.isNotEmpty) {
                setState(() {
                  _contacts.add(
                    EmergencyContact(
                      name: nameController.text.trim(),
                      relationship: relController.text.trim(),
                      phone: phoneController.text.trim(),
                    ),
                  );
                });
                widget.onSave(_contacts);
                Navigator.pop(ctx);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1)),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Emergency Contacts (Up to 3)',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            if (_contacts.length < 3)
              TextButton.icon(
                onPressed: _addContactDialog,
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Contact'),
              ),
          ],
        ),
        const SizedBox(height: 8),
        ..._contacts.asMap().entries.map((entry) {
          final idx = entry.key;
          final contact = entry.value;

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(0xFFEEF2FF),
                  child: Icon(Icons.person_outline, size: 18, color: Color(0xFF6366F1)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${contact.name} (${contact.relationship})',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                      ),
                      Text(
                        contact.phone,
                        style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20, color: Colors.grey),
                  onPressed: () {
                    setState(() {
                      _contacts.removeAt(idx);
                    });
                    widget.onSave(_contacts);
                  },
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}
