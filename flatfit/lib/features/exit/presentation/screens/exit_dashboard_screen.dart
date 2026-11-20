import 'package:flutter/material.dart';
import '../../domain/models/exit_models.dart';
import '../widgets/exit_stepper.dart';
import 'post_vacancy_screen.dart';
import 'damage_inspection_screen.dart';
import 'deposit_settlement_screen.dart';
import 'handover_checklist_screen.dart';

/// Central dashboard for Module 10 (Replacement & Exit Protocol).
class ExitDashboardScreen extends StatefulWidget {
  final String flatId;
  final String currentUserId;
  final String currentUserName;

  const ExitDashboardScreen({
    super.key,
    required this.flatId,
    required this.currentUserId,
    this.currentUserName = 'Kabir Mehta',
  });

  @override
  State<ExitDashboardScreen> createState() => _ExitDashboardScreenState();
}

class _ExitDashboardScreenState extends State<ExitDashboardScreen> {
  late ExitRequest _exitRequest;

  @override
  void initState() {
    super.initState();
    _exitRequest = ExitRequest(
      id: 'exit_101',
      flatId: widget.flatId,
      userId: widget.currentUserId,
      userName: widget.currentUserName,
      roomName: 'Bedroom 2 (Private balcony room)',
      noticeDate: DateTime.now().subtract(const Duration(days: 10)),
      plannedExitDate: DateTime.now().add(const Duration(days: 20)),
      reason: 'Relocating to Bengaluru for job switch (Google Bangalore)',
      currentPhase: ExitPhase.findingReplacement,
      securityDepositHeld: 40000,
      refundVpa: 'kabir.mehta@paytm',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flatmate Replacement & Exit'),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExitTimelineStepper(currentPhase: _exitRequest.currentPhase),
            _buildNoticeCountdownBanner(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Text(
                'Exit Action Steps',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 8),
            _buildStepCard(
              title: '1. Post Vacancy to Find Replacement',
              subtitle: 'Publish your room directly to FlatFit matching to transfer security deposit smoothly.',
              icon: Icons.post_add,
              badge: 'ACTIVE STEP',
              badgeColor: Colors.teal.shade700,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PostVacancyScreen(
                      flatId: widget.flatId,
                      currentUserId: widget.currentUserId,
                    ),
                  ),
                );
              },
            ),
            _buildStepCard(
              title: '2. Move-Out Damage Inspection',
              subtitle: 'Document room condition, distinguish fair wear & tear from tenant damage.',
              icon: Icons.fact_check_outlined,
              badge: 'READY',
              badgeColor: Colors.blue.shade700,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DamageInspectionScreen(
                      exitRequestId: _exitRequest.id,
                      currentUserId: widget.currentUserId,
                    ),
                  ),
                );
              },
            ),
            _buildStepCard(
              title: '3. Deposit Return Calculator & Settle',
              subtitle: 'Itemize rent, utility shares & legal deductions. Transfer net refund via UPI.',
              icon: Icons.calculate_outlined,
              badge: 'READY',
              badgeColor: Colors.amber.shade800,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DepositSettlementScreen(
                      exitRequest: _exitRequest,
                      currentUserId: widget.currentUserId,
                    ),
                  ),
                );
              },
            ),
            _buildStepCard(
              title: '4. Society Handover & Keys Checklist',
              subtitle: 'Society move-out NOC, key handover, meter clearance, gate pass.',
              icon: Icons.vpn_key_outlined,
              badge: 'FINAL STEP',
              badgeColor: Colors.purple.shade700,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HandoverChecklistScreen(
                      exitRequestId: _exitRequest.id,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildNoticeCountdownBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(14),
        border: BorderSide(color: Colors.amber.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.amber.shade200,
            radius: 24,
            child: Icon(Icons.timer_outlined, color: Colors.amber.shade900, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_exitRequest.daysRemainingInNotice} Days Remaining in Notice Period',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.amber.shade900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Planned Move-Out: ${_exitRequest.plannedExitDate.toLocal().toString().split(' ')[0]} • Reason: ${_exitRequest.reason ?? "Relocation"}',
                  style: TextStyle(fontSize: 12, color: Colors.amber.shade900),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required String badge,
    required Color badgeColor,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(14),
        leading: CircleAvatar(
          backgroundColor: badgeColor.withOpacity(0.12),
          child: Icon(icon, color: badgeColor, size: 22),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      ),
    );
  }
}
