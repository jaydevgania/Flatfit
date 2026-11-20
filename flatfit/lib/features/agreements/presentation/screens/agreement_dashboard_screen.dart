import 'package:flutter/material.dart';
import 'package:flatfit/features/agreements/domain/models/agreement_models.dart';
import 'package:flatfit/features/agreements/domain/models/legal_guidance_models.dart';
import 'package:flatfit/features/agreements/domain/services/agreement_builder.dart';
import '../widgets/agreement_card.dart';
import 'agreement_builder_screen.dart';
import 'agreement_details_screen.dart';
import 'legal_guidance_screen.dart';
import 'move_in_checklist_screen.dart';
import 'trial_agreement_screen.dart';

/// Central dashboard for Module 8 (Move-In & Agreements).
class AgreementDashboardScreen extends StatefulWidget {
  final String flatId;
  final String currentUserId;
  final String currentUserName;

  const AgreementDashboardScreen({
    super.key,
    required this.flatId,
    required this.currentUserId,
    this.currentUserName = 'Rohan Verma',
  });

  @override
  State<AgreementDashboardScreen> createState() => _AgreementDashboardScreenState();
}

class _AgreementDashboardScreenState extends State<AgreementDashboardScreen> {
  late List<FlatmateAgreement> _agreements;

  @override
  void initState() {
    super.initState();
    _agreements = _getSampleAgreements();
  }

  List<FlatmateAgreement> _getSampleAgreements() {
    final sampleConfig = HouseRulesConfig(
      monthlyRent: 42000,
      securityDeposit: 100000,
      quietHoursStart: '11:00 PM',
      quietHoursEnd: '07:30 AM',
      guestPolicy: 'Day visitors welcome. Overnight guests require 24 hours notice on House Hub.',
      chorePolicy: 'Rotated weekly via FlatFit Chore planner; dishes cleaned within 2 hours.',
      billSplitPolicy: 'Equal 3-way split for electricity, maid, cook, and 300 Mbps WiFi.',
      noticePeriodDays: 30,
      flatmateNames: ['Rohan Verma', 'Ananya Sharma', 'Kabir Mehta'],
    );

    final agreement = AgreementBuilder.createAgreement(
      id: 'agree_bandra_101',
      flatId: widget.flatId,
      title: 'Flat 402 Palm Breeze Co-Living Compact',
      config: sampleConfig,
      startDate: DateTime.now().subtract(const Duration(days: 15)),
      endDate: DateTime.now().add(const Duration(days: 350)),
      creatorUserId: widget.currentUserId,
      memberUserIds: [widget.currentUserId, 'user_ananya', 'user_kabir'],
    );

    final trialAgreement = AgreementBuilder.createTrialAgreement(
      id: 'trial_bandra_102',
      flatId: widget.flatId,
      trialType: AgreementType.trialWeek,
      perDayRent: 1400,
      securityHoldDeposit: 5000,
      startDate: DateTime.now().add(const Duration(days: 7)),
      creatorUserId: widget.currentUserId,
      memberUserIds: [widget.currentUserId, 'user_prospective'],
      flatAddress: 'Flat 402, Palm Breeze, Pali Hill, Bandra West, Mumbai',
    );

    return [agreement, trialAgreement];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Move-In & Agreements'),
        elevation: 0,
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.gavel_outlined),
            tooltip: 'Legal & Stamp Duty Guide',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LegalGuidanceScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildQuickActionBanner(context),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Active & Draft Agreements',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Create New'),
                    onPressed: () async {
                      final newAgreement = await Navigator.push<FlatmateAgreement>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AgreementBuilderScreen(
                            flatId: widget.flatId,
                            currentUserId: widget.currentUserId,
                          ),
                        ),
                      );
                      if (newAgreement != null) {
                        setState(() {
                          _agreements.insert(0, newAgreement);
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            ..._agreements.map((agreement) => AgreementCard(
                  agreement: agreement,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AgreementDetailsScreen(
                          agreement: agreement,
                          currentUserId: widget.currentUserId,
                          currentUserName: widget.currentUserName,
                        ),
                      ),
                    );
                  },
                )),
            const SizedBox(height: 16),
            _buildChecklistPromoCard(context),
            const SizedBox(height: 16),
            _buildTrialWeekPromoCard(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.teal.shade700,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Harmony through Clear Agreements',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Plain-language house rules, legally sound e-stamping guides, and move-in condition tracking for India.',
            style: TextStyle(
              color: Colors.teal.shade100,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.teal.shade800,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.checklist_rounded, size: 18),
                  label: const Text('Move-In Inspection'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MoveInChecklistScreen(
                          agreementId: _agreements.first.id,
                          currentUserId: widget.currentUserId,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade900,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.hourglass_bottom, size: 18),
                  label: const Text('Trial Stay Setup'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TrialAgreementScreen(
                          flatId: widget.flatId,
                          currentUserId: widget.currentUserId,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistPromoCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(14),
        border: BorderSide(color: Colors.blue.shade100),
      ),
      child: Row(
        children: [
          Icon(Icons.photo_camera_back_outlined, size: 36, color: Colors.blue.shade700),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Move-In Condition Photos & Meters',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Record initial electric/gas meter readings and pre-existing wall/fixture marks to ensure 100% deposit return.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue.shade900,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 16),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MoveInChecklistScreen(
                    agreementId: _agreements.first.id,
                    currentUserId: widget.currentUserId,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTrialWeekPromoCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(14),
        border: BorderSide(color: Colors.purple.shade100),
      ),
      child: Row(
        children: [
          Icon(Icons.bedtime_outlined, size: 36, color: Colors.purple.shade700),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Try Before You Commit: Trial Week',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '7-day live-in trial with flatmates with low refundable deposit to test quiet hours, cleanliness & vibe.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.purple.shade900,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 16),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TrialAgreementScreen(
                    flatId: widget.flatId,
                    currentUserId: widget.currentUserId,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
