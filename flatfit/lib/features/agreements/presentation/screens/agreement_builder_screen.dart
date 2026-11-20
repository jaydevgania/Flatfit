import 'package:flutter/material.dart';
import 'package:flatfit/features/agreements/domain/models/agreement_models.dart';
import 'package:flatfit/features/agreements/domain/services/agreement_builder.dart';

/// Interactive builder for configuring and generating house rules and co-living agreements.
class AgreementBuilderScreen extends StatefulWidget {
  final String flatId;
  final String currentUserId;

  const AgreementBuilderScreen({
    super.key,
    required this.flatId,
    required this.currentUserId,
  });

  @override
  State<AgreementBuilderScreen> createState() => _AgreementBuilderScreenState();
}

class _AgreementBuilderScreenState extends State<AgreementBuilderScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController(text: 'Palm Breeze Co-Living Compact');
  final _rentController = TextEditingController(text: '45000');
  final _depositController = TextEditingController(text: '120000');
  final _noticeController = TextEditingController(text: '30');

  String _quietStart = '11:00 PM';
  String _quietEnd = '07:30 AM';
  String _guestOption = 'Overnight guests allowed with 24h prior WhatsApp notice';
  String _dietOption = 'Both veg and non-veg permitted; separate shelf in fridge';
  String _smokingOption = 'Balcony smoking only; clean ashtrays after use';
  String _choreOption = 'Weekly rotation on FlatFit; wash individual dishes immediately';

  final List<String> _flatmates = ['Rohan Verma', 'Ananya Sharma', 'Kabir Mehta'];
  final _flatmateInputController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _rentController.dispose();
    _depositController.dispose();
    _noticeController.dispose();
    _flatmateInputController.dispose();
    super.dispose();
  }

  void _generateAgreement() {
    if (!_formKey.currentState!.validate()) return;

    final config = HouseRulesConfig(
      monthlyRent: double.tryParse(_rentController.text) ?? 45000,
      securityDeposit: double.tryParse(_depositController.text) ?? 120000,
      quietHoursStart: _quietStart,
      quietHoursEnd: _quietEnd,
      guestPolicy: _guestOption,
      foodDietPolicy: _dietOption,
      smokingDrinkingPolicy: _smokingOption,
      chorePolicy: _choreOption,
      noticePeriodDays: int.tryParse(_noticeController.text) ?? 30,
      flatmateNames: _flatmates,
    );

    final agreement = AgreementBuilder.createAgreement(
      id: 'agree_${DateTime.now().millisecondsSinceEpoch}',
      flatId: widget.flatId,
      title: _titleController.text.trim(),
      config: config,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 335)), // 11 months
      creatorUserId: widget.currentUserId,
      memberUserIds: [widget.currentUserId, 'user_ananya', 'user_kabir'],
    );

    Navigator.pop(context, agreement);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Build House Agreement'),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionHeader('1. Core Agreement Details', Icons.info_outline),
            const SizedBox(height: 12),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Agreement Name',
                hintText: 'e.g. Bandra Palm Breeze Flatmate Compact',
                border: OutlineInputBorder(),
              ),
              validator: (v) => (v == null || v.isEmpty) ? 'Please enter a title' : null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _rentController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Total Monthly Rent (₹)',
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
                      labelText: 'Total Deposit (₹)',
                      prefixText: '₹ ',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('2. Plain-Language House Rules', Icons.home_outlined),
            const SizedBox(height: 12),
            _buildDropdown(
              label: 'Quiet Hours Schedule',
              value: '$_quietStart - $_quietEnd',
              options: [
                '11:00 PM - 07:30 AM',
                '10:30 PM - 07:00 AM',
                '12:00 AM - 08:00 AM',
              ],
              onChanged: (val) {
                if (val != null) {
                  final parts = val.split(' - ');
                  setState(() {
                    _quietStart = parts[0];
                    _quietEnd = parts[1];
                  });
                }
              },
            ),
            const SizedBox(height: 12),
            _buildDropdown(
              label: 'Overnight Guests Policy',
              value: _guestOption,
              options: [
                'Overnight guests allowed with 24h prior WhatsApp notice',
                'Guests allowed anytime; respect shared spaces',
                'Overnight guests restricted to weekends only',
                'No overnight guests without unanimous agreement',
              ],
              onChanged: (val) {
                if (val != null) setState(() => _guestOption = val);
              },
            ),
            const SizedBox(height: 12),
            _buildDropdown(
              label: 'Kitchen & Dietary Preferences',
              value: _dietOption,
              options: [
                'Both veg and non-veg permitted; separate shelf in fridge',
                'Strictly vegetarian kitchen and utensils',
                'Eggs permitted, non-veg from outside delivery only',
                'Full kitchen freedom; clean up after every use',
              ],
              onChanged: (val) {
                if (val != null) setState(() => _dietOption = val);
              },
            ),
            const SizedBox(height: 12),
            _buildDropdown(
              label: 'Smoking & Balcony Policy',
              value: _smokingOption,
              options: [
                'Balcony smoking only; clean ashtrays after use',
                'Strictly smoke-free flat (including balcony)',
                'Social drinking & balcony smoking permitted',
              ],
              onChanged: (val) {
                if (val != null) setState(() => _smokingOption = val);
              },
            ),
            const SizedBox(height: 12),
            _buildDropdown(
              label: 'Chores & Daily Cleaning',
              value: _choreOption,
              options: [
                'Weekly rotation on FlatFit; wash individual dishes immediately',
                'Daily rotation for trash & common areas; maid handles dusting',
                'Split cost for cook & deep cleaner evenly',
              ],
              onChanged: (val) {
                if (val != null) setState(() => _choreOption = val);
              },
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('3. Notice Period & Exit Policy', Icons.exit_to_app),
            const SizedBox(height: 12),
            TextFormField(
              controller: _noticeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Notice Period (Days)',
                helperText: 'Standard co-living notice period in India is 30 days',
                border: OutlineInputBorder(),
              ),
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('4. Co-Living Flatmates', Icons.group_outlined),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: _flatmates
                  .map((name) => Chip(
                        label: Text(name),
                        avatar: CircleAvatar(
                          backgroundColor: Colors.teal.shade100,
                          child: Text(
                            name[0],
                            style: TextStyle(color: Colors.teal.shade900, fontSize: 12),
                          ),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _generateAgreement,
              child: const Text(
                'Generate Agreement Clauses',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.teal.shade800),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.teal.shade900,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: options.contains(value) ? value : options.first,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
      isExpanded: true,
      items: options
          .map((opt) => DropdownMenuItem(
                value: opt,
                child: Text(
                  opt,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13),
                ),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}
