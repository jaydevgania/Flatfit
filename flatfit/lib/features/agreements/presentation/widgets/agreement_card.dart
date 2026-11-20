import 'package:flutter/material.dart';
import '../models/agreement_models.dart';

/// Card summarizing an agreement on the dashboard.
class AgreementCard extends StatelessWidget {
  final FlatmateAgreement agreement;
  final VoidCallback onTap;

  const AgreementCard({
    super.key,
    required this.agreement,
    required this.onTap,
  });

  Color _getStatusColor(AgreementStatus status) {
    switch (status) {
      case AgreementStatus.active:
        return Colors.green.shade600;
      case AgreementStatus.draft:
        return Colors.amber.shade800;
      case AgreementStatus.terminated:
        return Colors.red.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(agreement.status);
    final isTrial = agreement.agreementType != AgreementType.fullStay;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isTrial ? Colors.purple.shade50 : Colors.teal.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      isTrial ? Icons.hourglass_top : Icons.gavel_rounded,
                      color: isTrial ? Colors.purple.shade700 : Colors.teal.shade700,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          agreement.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isTrial ? 'Trial Co-Living Compact' : 'Full Stay Flatmate Compact',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      agreement.status.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _infoColumn('Monthly Rent', agreement.rentAmount != null ? '₹${agreement.rentAmount!.toStringAsFixed(0)}' : 'N/A'),
                  _infoColumn('Security Deposit', agreement.depositAmount != null ? '₹${agreement.depositAmount!.toStringAsFixed(0)}' : 'N/A'),
                  _infoColumn('Clauses', '${agreement.clauses.length} Rules'),
                  _infoColumn('Signatures', '${agreement.signatures.length}/${agreement.memberUserIds.isNotEmpty ? agreement.memberUserIds.length : "All"}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
