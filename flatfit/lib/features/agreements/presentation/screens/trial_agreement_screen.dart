import 'package:flutter/material.dart';
import 'package:flatfit/features/agreements/domain/models/agreement_models.dart';
import 'package:flatfit/features/agreements/domain/services/agreement_builder.dart';

/// Screen for creating and reviewing a Trial Week or 1-Day trial agreement.
class TrialAgreementScreen extends StatefulWidget {
  final String flatId;
  final String currentUserId;

  const TrialAgreementScreen({
    super.key,
    required this.flatId,
    required this.currentUserId,
  });

  @override
  State<TrialAgreementScreen> createState() => _TrialAgreementScreenState();
}

class _TrialAgreementScreenState extends State<TrialAgreementScreen> {
  AgreementType _selectedType = AgreementType.trialWeek;
  final _perDayRentController = TextEditingController(text: '1200');
  final _securityHoldController = TextEditingController(text: '5000');
  final _prospectiveFlatmateController = TextEditingController(text: 'Aarav Malhotra');
  final _flatAddressController = TextEditingController(
    text: 'Flat 402, Palm Breeze, Pali Hill, Bandra West, Mumbai',
  );

  DateTime _startDate = DateTime.now().add(const Duration(days: 3));

  @override
  void dispose() {
    _perDayRentController.dispose();
    _securityHoldController.dispose();
    _prospectiveFlatmateController.dispose();
    _flatAddressController.dispose();
    super.dispose();
  }

  void _createTrialAgreement() {
    final perDayRent = double.tryParse(_perDayRentController.text) ?? 1200;
    final securityHold = double.tryParse(_securityHoldController.text) ?? 5000;

    final agreement = AgreementBuilder.createTrialAgreement(
      id: 'trial_${DateTime.now().millisecondsSinceEpoch}',
      flatId: widget.flatId,
      trialType: _selectedType,
      perDayRent: perDayRent,
      securityHoldDeposit: securityHold,
      startDate: _startDate,
      creatorUserId: widget.currentUserId,
      memberUserIds: [widget.currentUserId, 'user_trial_candidate'],
      flatAddress: _flatAddressController.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Trial Agreement created for ${_prospectiveFlatmateController.text}! Sent for review.'),
        backgroundColor: Colors.purple.shade700,
      ),
    );

    Navigator.pop(context, agreement);
  }

  @override
  Widget build(BuildContext context) {
    final isWeek = _selectedType == AgreementType.trialWeek;
    final days = isWeek ? 7 : 1;
    final perDay = double.tryParse(_perDayRentController.text) ?? 1200;
    final totalStayRent = perDay * days;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Trial Stay Agreement'),
        backgroundColor: Colors.purple.shade700,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildInfoBanner(),
          const SizedBox(height: 16),
          const Text(
            'Select Trial Duration',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTypeRadioCard(
                  type: AgreementType.trialWeek,
                  title: '7-Day Trial Week',
                  subtitle: 'Ideal for experiencing real routines, cooking & chores',
                  icon: Icons.calendar_view_week,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTypeRadioCard(
                  type: AgreementType.dayTrial,
                  title: '1-Day Day-Long Trial',
                  subtitle: 'Work-from-home test day + dinner to test vibe',
                  icon: Icons.today,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Financial Terms for Trial',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _perDayRentController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Per-Day Contribution',
                    prefixText: '₹ ',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _securityHoldController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Refundable Security Hold',
                    prefixText: '₹ ',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Stay Rent ($days day${days > 1 ? "s" : ""}):',
                  style: TextStyle(color: Colors.purple.shade900, fontWeight: FontWeight.w600),
                ),
                Text(
                  '₹${totalStayRent.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple.shade900,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Candidate & Flat Details',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _prospectiveFlatmateController,
            decoration: const InputDecoration(
              labelText: 'Prospective Flatmate Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _flatAddressController,
            decoration: const InputDecoration(
              labelText: 'Flat Address',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          _buildGuaranteesList(),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: _createTrialAgreement,
            child: const Text(
              'Generate & Send Trial Agreement',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(12),
        border: BorderSide(color: Colors.purple.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.shield_outlined, color: Colors.purple.shade700, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Zero-Lock-In Flatmate Trial',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.purple.shade900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Test compatibility before committing to a 11-month lease. If it’s not a match, deposit is refunded in 24 hours.',
                  style: TextStyle(fontSize: 12, color: Colors.purple.shade900),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeRadioCard({
    required AgreementType type,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = _selectedType == type;

    return InkWell(
      onTap: () => setState(() => _selectedType = type),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: BorderSide(
            color: isSelected ? Colors.purple.shade700 : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.purple.shade700 : Colors.grey.shade600,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isSelected ? Colors.purple.shade900 : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600, height: 1.2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuaranteesList() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Trial Agreement Protections:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 8),
          _bulletPoint('Trial stays do not establish tenancy or tenant rights.'),
          _bulletPoint('Security hold is returned via UPI within 24 hours if match is declined.'),
          _bulletPoint('Guest agrees to quiet hours & identity verification before check-in.'),
        ],
      ),
    );
  }

  Widget _bulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }
}
