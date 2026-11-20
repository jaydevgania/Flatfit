import 'package:flutter/material.dart';

class RentBadge extends StatelessWidget {
  final double rent;
  final double deposit;
  final double maintenance;
  final bool isCompact;

  const RentBadge({
    Key? key,
    required this.rent,
    this.deposit = 0,
    this.maintenance = 0,
    this.isCompact = false,
  }) : super(key: key);

  String _formatIndianCurrency(double amount) {
    final int val = amount.round();
    if (val >= 100000) {
      final lacs = (val / 100000).toStringAsFixed(1);
      return '₹${lacs}L';
    } else if (val >= 1000) {
      final thousands = val ~/ 1000;
      final remainder = val % 1000;
      if (remainder == 0) {
        return '₹$thousands,000';
      }
      return '₹$thousands,${remainder.toString().padLeft(3, '0')}';
    }
    return '₹$val';
  }

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A).withOpacity(0.85),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          '${_formatIndianCurrency(rent)}/mo',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Monthly rent
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Monthly Rent',
                style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 2),
              Text(
                '${_formatIndianCurrency(rent)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const Text(
                'per room',
                style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
          Container(height: 36, width: 1, color: const Color(0xFFCBD5E1)),
          // Security deposit
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Security Deposit',
                style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 2),
              Text(
                deposit > 0 ? _formatIndianCurrency(deposit) : '1 Month',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF334155),
                ),
              ),
              const Text(
                'Refundable',
                style: TextStyle(fontSize: 10, color: Color(0xFF059669)),
              ),
            ],
          ),
          Container(height: 36, width: 1, color: const Color(0xFFCBD5E1)),
          // Maintenance
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Maintenance',
                style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 2),
              Text(
                maintenance > 0 ? _formatIndianCurrency(maintenance) : 'Included',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF334155),
                ),
              ),
              const Text(
                'Society fee',
                style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
