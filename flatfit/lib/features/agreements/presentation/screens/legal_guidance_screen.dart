import 'package:flutter/material.dart';
import '../models/legal_guidance_models.dart';

/// Screen providing state-wise rent agreement rules (Maharashtra, Karnataka, Delhi),
/// e-stamping step-by-step instructions, and an interactive stamp duty calculator.
class LegalGuidanceScreen extends StatefulWidget {
  const LegalGuidanceScreen({super.key});

  @override
  State<LegalGuidanceScreen> createState() => _LegalGuidanceScreenState();
}

class _LegalGuidanceScreenState extends State<LegalGuidanceScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _rentCalcController = TextEditingController(text: '45000');
  final _depositCalcController = TextEditingController(text: '150000');
  int _durationMonths = 11;
  StateCode _selectedState = StateCode.maharashtra;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _rentCalcController.dispose();
    _depositCalcController.dispose();
    super.dispose();
  }

  double _getCalculatedDuty() {
    final rent = double.tryParse(_rentCalcController.text) ?? 45000;
    final deposit = double.tryParse(_depositCalcController.text) ?? 150000;

    final rule = StateRentRule.presets.firstWhere(
      (r) => r.stateCode == _selectedState,
      orElse: () => StateRentRule.presets.first,
    );

    return rule.estimateStampDuty(
      monthlyRent: rent,
      deposit: deposit,
      durationMonths: _durationMonths,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rent Agreement & e-Stamping Guide'),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.amber,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.teal.shade100,
          tabs: const [
            Tab(text: 'Maharashtra'),
            Tab(text: 'Karnataka'),
            Tab(text: 'Delhi-NCR'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildStateView(StateRentRule.presets[0]),
          _buildStateView(StateRentRule.presets[1]),
          _buildStateView(StateRentRule.presets[2]),
        ],
      ),
    );
  }

  Widget _buildStateView(StateRentRule rule) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeroCard(rule),
        const SizedBox(height: 16),
        _buildCalculatorCard(rule),
        const SizedBox(height: 16),
        _buildSectionTitle('Required Documents', Icons.description_outlined),
        const SizedBox(height: 8),
        ...rule.requiredDocuments.map((doc) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle_outline, size: 18, color: Colors.teal),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      doc,
                      style: const TextStyle(fontSize: 13, height: 1.3),
                    ),
                  ),
                ],
              ),
            )),
        const SizedBox(height: 16),
        _buildSectionTitle('Police Verification Process', Icons.security),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(10),
            border: BorderSide(color: Colors.amber.shade200),
          ),
          child: Text(
            rule.policeVerificationProcess,
            style: TextStyle(fontSize: 13, color: Colors.amber.shade900, height: 1.4),
          ),
        ),
        const SizedBox(height: 16),
        _buildSectionTitle('Common Pitfalls to Avoid', Icons.warning_amber_rounded),
        const SizedBox(height: 8),
        ...rule.commonPitfalls.map((pitfall) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.close, size: 18, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      pitfall,
                      style: const TextStyle(fontSize: 13, height: 1.3),
                    ),
                  ),
                ],
              ),
            )),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildHeroCard(StateRentRule rule) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    rule.agreementName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: rule.isERegistrationMandatory ? Colors.red.shade100 : Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    rule.isERegistrationMandatory ? 'e-Reg Mandatory' : 'Notary Allowed',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: rule.isERegistrationMandatory ? Colors.red.shade900 : Colors.blue.shade900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Governed by: ${rule.governingAct}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            _infoRow('Registration Mode:', rule.registrationRequirements),
            const SizedBox(height: 8),
            _infoRow('Official Portal:', rule.eStampingPortal),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculatorCard(StateRentRule rule) {
    final duty = _getCalculatedDuty();

    return Card(
      elevation: 2,
      color: Colors.teal.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.teal.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calculate_outlined, color: Colors.teal.shade800),
                const SizedBox(width: 8),
                Text(
                  'Stamp Duty & Fee Estimator (${rule.stateName.split(' ')[0]})',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _rentCalcController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Monthly Rent',
                      prefixText: '₹',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => setState(() {
                      _selectedState = rule.stateCode;
                    }),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _depositCalcController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Deposit',
                      prefixText: '₹',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => setState(() {
                      _selectedState = rule.stateCode;
                    }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Estimated Government Stamp Duty',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        '₹${duty.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal.shade900,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '11 Months Lease',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.teal.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.teal.shade800),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(fontSize: 12.5, color: Colors.grey.shade800, height: 1.3),
        ),
      ],
    );
  }
}
