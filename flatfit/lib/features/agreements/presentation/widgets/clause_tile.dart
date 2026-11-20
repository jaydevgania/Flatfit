import 'package:flutter/material.dart';
import 'package:flatfit/features/agreements/domain/models/agreement_models.dart';

/// Reusable card displaying an agreement clause with category icon and plain-language badge.
class ClauseTile extends StatelessWidget {
  final AgreementClause clause;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isEditable;

  const ClauseTile({
    super.key,
    required this.clause,
    this.onEdit,
    this.onDelete,
    this.isEditable = false,
  });

  IconData _getCategoryIcon(ClauseCategory category) {
    switch (category) {
      case ClauseCategory.rentAndDeposit:
        return Icons.currency_rupee;
      case ClauseCategory.quietHours:
        return Icons.nightlight_round;
      case ClauseCategory.guestsAndVisitors:
        return Icons.group;
      case ClauseCategory.choresAndCleanliness:
        return Icons.cleaning_services;
      case ClauseCategory.utilityBills:
        return Icons.receipt_long;
      case ClauseCategory.noticePeriod:
        return Icons.event_note;
      case ClauseCategory.exitAndDepositReturn:
        return Icons.handshake;
      case ClauseCategory.petsAndSmoking:
        return Icons.smoke_free;
      case ClauseCategory.foodAndKitchen:
        return Icons.restaurant;
      case ClauseCategory.disputeResolution:
        return Icons.forum;
    }
  }

  Color _getCategoryColor(ClauseCategory category) {
    switch (category) {
      case ClauseCategory.rentAndDeposit:
        return Colors.green.shade700;
      case ClauseCategory.quietHours:
        return Colors.indigo.shade600;
      case ClauseCategory.guestsAndVisitors:
        return Colors.teal.shade700;
      case ClauseCategory.choresAndCleanliness:
        return Colors.orange.shade800;
      case ClauseCategory.utilityBills:
        return Colors.blue.shade700;
      case ClauseCategory.noticePeriod:
        return Colors.purple.shade700;
      case ClauseCategory.exitAndDepositReturn:
        return Colors.deepOrange.shade700;
      case ClauseCategory.petsAndSmoking:
        return Colors.blueGrey.shade700;
      case ClauseCategory.foodAndKitchen:
        return Colors.amber.shade900;
      case ClauseCategory.disputeResolution:
        return Colors.cyan.shade800;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getCategoryColor(clause.category);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: color.withOpacity(0.12),
                  child: Icon(
                    _getCategoryIcon(clause.category),
                    size: 20,
                    color: color,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        clause.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        clause.category.name.replaceAllMapped(
                          RegExp(r'([A-Z])'),
                          (m) => ' ${m.group(0)}',
                        ).toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: color,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                if (clause.isMandatory)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(6),
                      border: BorderSide(color: Colors.red.shade200),
                    ),
                    child: Text(
                      'Core Rule',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.red.shade700,
                      ),
                    ),
                  ),
                if (isEditable) ...[
                  IconButton(
                    icon: const Icon(Icons.edit, size: 18),
                    onPressed: onEdit,
                  ),
                  if (!clause.isMandatory)
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                      onPressed: onDelete,
                    ),
                ],
              ],
            ),
            const SizedBox(height: 10),
            Text(
              clause.description,
              style: TextStyle(
                fontSize: 13.5,
                color: Colors.grey.shade800,
                height: 1.4,
              ),
            ),
            if (clause.amount != null && clause.amount! > 0) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Amount: ₹${clause.amount!.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade900,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
