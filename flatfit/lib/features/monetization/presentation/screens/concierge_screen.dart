import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/concierge_service.dart';
import '../providers/monetization_provider.dart';

class ConciergeScreen extends ConsumerStatefulWidget {
  const ConciergeScreen({super.key});

  @override
  ConsumerState<ConciergeScreen> createState() => _ConciergeScreenState();
}

class _ConciergeScreenState extends ConsumerState<ConciergeScreen> {
  final ConciergeServicePackage _package = const ConciergeServicePackage();
  final TextEditingController _nameController = TextEditingController(text: 'Jay Sharma');
  final TextEditingController _phoneController = TextEditingController(text: '+91 98201 12345');
  final TextEditingController _localitiesController = TextEditingController(text: 'Bandra West, Khar, Pali Hill');
  final TextEditingController _notesController = TextEditingController(
    text: 'Looking for non-smoking flatmate, quiet weeknights, vegetarian kitchen preferred.',
  );
  RangeValues _budgetRange = const RangeValues(25000, 45000);
  DateTime _moveInDate = DateTime.now().add(const Duration(days: 14));
  String _diet = 'Vegetarian';
  String _workSchedule = 'Hybrid (Office 3 days, WFH 2 days)';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _localitiesController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    setState(() => _isSubmitting = true);

    final req = ConciergeRequest(
      id: 'cr_${DateTime.now().millisecondsSinceEpoch}',
      userId: 'current_user_1',
      userName: _nameController.text,
      userPhone: _phoneController.text,
      budgetMin: _budgetRange.start,
      budgetMax: _budgetRange.end,
      preferredLocalities: _localitiesController.text.split(',').map((s) => s.trim()).toList(),
      targetMoveInDate: _moveInDate,
      dietaryPreference: _diet,
      workSchedule: _workSchedule,
      customRequirements: _notesController.text,
      submittedAt: DateTime.now(),
    );

    final success = await ref.read(monetizationProvider.notifier).requestConcierge(req);
    setState(() => _isSubmitting = false);

    if (mounted) {
      if (success) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text('Concierge Request Received! 🤝'),
            content: const Text(
              'Your VIP Matching Manager (Rhea Malhotra) has been assigned. She will review your preferences and call you on your phone within 2 hours with initial match recommendations.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('Great!'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VIP Matching Concierge'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFF3730A3)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(Icons.support_agent, color: Colors.amberAccent, size: 48),
                  const SizedBox(height: 10),
                  Text(
                    _package.title,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _package.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.35),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '₹${_package.fee.toInt()} One-time • 100% Match Guarantee',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text('Features Included:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 8),
            ..._package.features.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      const Icon(Icons.check, color: Color(0xFF4F46E5), size: 16),
                      const SizedBox(width: 8),
                      Expanded(child: Text(f, style: const TextStyle(fontSize: 12))),
                    ],
                  ),
                )),
            const SizedBox(height: 24),

            // Form
            const Text('Your Flatmate Requirements', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 14),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Your Name',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Contact Phone Number',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _localitiesController,
              decoration: InputDecoration(
                labelText: 'Target Localities (comma separated)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 16),

            // Budget slider
            Text(
              'Monthly Room Budget: ₹${_budgetRange.start.toInt()} – ₹${_budgetRange.end.toInt()}',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            RangeSlider(
              values: _budgetRange,
              min: 10000,
              max: 90000,
              divisions: 16,
              activeColor: const Color(0xFF4F46E5),
              onChanged: (val) => setState(() => _budgetRange = val),
            ),
            const SizedBox(height: 12),

            // Custom Notes
            TextField(
              controller: _notesController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'Specific lifestyle boundaries & non-negotiables',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _isSubmitting ? null : _handleSubmit,
                child: Text(
                  _isSubmitting ? 'Submitting...' : 'Request VIP Concierge (₹2,499)',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
