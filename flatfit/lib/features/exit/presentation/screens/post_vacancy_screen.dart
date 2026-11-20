import 'package:flutter/material.dart';
import '../../domain/models/exit_models.dart';

/// Screen enabling an exiting flatmate or remaining flatmates to publish a vacancy for an existing room.
class PostVacancyScreen extends StatefulWidget {
  final String flatId;
  final String currentUserId;

  const PostVacancyScreen({
    super.key,
    required this.flatId,
    required this.currentUserId,
  });

  @override
  State<PostVacancyScreen> createState() => _PostVacancyScreenState();
}

class _PostVacancyScreenState extends State<PostVacancyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController(text: 'Sunny Balcony Room in 3BHK Palm Breeze');
  final _rentController = TextEditingController(text: '15000');
  final _depositController = TextEditingController(text: '40000');
  final _bioController = TextEditingController(
    text: 'Looking for a chill, working professional flatmate. We are 2 techies working in BKC. Veg/Non-veg friendly.',
  );

  String _roomType = 'Private Room with Balcony';
  String _preferredGender = 'Any (Working Professional)';
  DateTime _availableFrom = DateTime.now().add(const Duration(days: 20));

  final List<String> _selectedAmenities = [
    'Attached Balcony',
    'AC & Wardrobe',
    'WiFi 300 Mbps',
    'Cook & Maid Active',
    'Gated Society & Gym',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _rentController.dispose();
    _depositController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _publishVacancy() {
    if (!_formKey.currentState!.validate()) return;

    final post = RoomVacancyPost(
      id: 'vac_${DateTime.now().millisecondsSinceEpoch}',
      flatId: widget.flatId,
      roomTitle: _titleController.text.trim(),
      roomType: _roomType,
      monthlyRent: double.tryParse(_rentController.text) ?? 15000,
      securityDeposit: double.tryParse(_depositController.text) ?? 40000,
      availableFromDate: _availableFrom,
      roomAmenities: _selectedAmenities,
      currentFlatmatesBio: _bioController.text.trim(),
      preferredFlatmateGender: _preferredGender,
      isVerifiedListing: true,
      isPublished: true,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Vacancy "${post.roomTitle}" published to FlatFit Discovery with Verified Badge!'),
        backgroundColor: Colors.teal.shade700,
      ),
    );

    Navigator.pop(context, post);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Room Vacancy'),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildVerifiedBadgeBanner(),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Listing Headline',
                border: OutlineInputBorder(),
              ),
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _rentController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Monthly Rent',
                      prefixText: '₹ ',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _depositController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Security Deposit',
                      prefixText: '₹ ',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _roomType,
              decoration: const InputDecoration(labelText: 'Room Type', border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'Private Room with Balcony', child: Text('Private Room with Balcony')),
                DropdownMenuItem(value: 'Master Bed with Attached Bath', child: Text('Master Bed with Attached Bath')),
                DropdownMenuItem(value: 'Shared Twin Room', child: Text('Shared Twin Room')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _roomType = val);
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _preferredGender,
              decoration: const InputDecoration(labelText: 'Preferred Flatmate', border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'Any (Working Professional)', child: Text('Any (Working Professional)')),
                DropdownMenuItem(value: 'Female Flatmate Only', child: Text('Female Flatmate Only')),
                DropdownMenuItem(value: 'Male Flatmate Only', child: Text('Male Flatmate Only')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _preferredGender = val);
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _bioController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'About Remaining Flatmates & Vibe',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Room & Flat Amenities', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: _selectedAmenities
                  .map((amenity) => Chip(
                        label: Text(amenity, style: const TextStyle(fontSize: 12)),
                        backgroundColor: Colors.teal.shade50,
                      ))
                  .toList(),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.rocket_launch),
              label: const Text(
                'Publish Room to FlatFit Search',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onPressed: _publishVacancy,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildVerifiedBadgeBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: BorderSide(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.verified, color: Colors.green.shade700, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Auto-Linked to Verified Co-Living Flat',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                    color: Colors.green.shade900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Your vacancy inherits the verified address and flatmate trust badges, boosting match requests by 3x.',
                  style: TextStyle(fontSize: 11.5, color: Colors.green.shade900),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
