import 'package:flutter/material.dart';
import '../models/hub_models.dart';

/// Card displaying appliance details, purchase date, warranty badge, and technician contact.
class ApplianceCard extends StatelessWidget {
  final ApplianceMemoryItem item;
  final VoidCallback? onCallTechnician;
  final VoidCallback? onViewInvoice;

  const ApplianceCard({
    super.key,
    required this.item,
    this.onCallTechnician,
    this.onViewInvoice,
  });

  @override
  Widget build(BuildContext context) {
    final isWarrantyActive = item.isUnderWarranty;
    final remainingDays = item.warrantyDaysRemaining;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
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
                  radius: 20,
                  backgroundColor: Colors.teal.shade50,
                  child: Icon(Icons.kitchen_outlined, color: Colors.teal.shade800, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.itemName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      if (item.brandAndModel != null)
                        Text(
                          item.brandAndModel!,
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isWarrantyActive ? Colors.green.shade50 : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(6),
                    border: BorderSide(
                      color: isWarrantyActive ? Colors.green.shade200 : Colors.red.shade200,
                    ),
                  ),
                  child: Text(
                    isWarrantyActive
                        ? (remainingDays != null ? '$remainingDays days warranty' : 'Under Warranty')
                        : 'Warranty Expired',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isWarrantyActive ? Colors.green.shade800 : Colors.red.shade800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (item.cost != null)
                  _specColumn('Purchased For', '₹${item.cost!.toStringAsFixed(0)}'),
                if (item.purchaseDate != null)
                  _specColumn('Purchase Date', item.purchaseDate!.toIso8601String().split('T').first),
                if (item.boughtByName != null)
                  _specColumn('Purchased By', item.boughtByName!),
              ],
            ),
            if (item.technicianContact != null || item.billReceiptUrl != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  if (item.technicianContact != null)
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        minimumSize: const Size(0, 32),
                      ),
                      icon: const Icon(Icons.phone, size: 14, color: Colors.teal),
                      label: Text(
                        'Service: ${item.technicianContact}',
                        style: const TextStyle(fontSize: 11),
                      ),
                      onPressed: onCallTechnician,
                    ),
                  const Spacer(),
                  if (item.billReceiptUrl != null)
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        minimumSize: const Size(0, 32),
                      ),
                      icon: const Icon(Icons.receipt, size: 14),
                      label: const Text('View Bill', style: TextStyle(fontSize: 11)),
                      onPressed: onViewInvoice,
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _specColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 10.5, color: Colors.grey.shade500)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
