import 'package:flutter/material.dart';

class VerifiedBadge extends StatelessWidget {
  final bool isVerified;
  final bool isCompact;

  const VerifiedBadge({
    Key? key,
    required this.isVerified,
    this.isCompact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isVerified) return const SizedBox.shrink();

    if (isCompact) {
      return Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFF0D9488),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 4,
            ),
          ],
        ),
        child: const Icon(
          Icons.verified,
          color: Colors.white,
          size: 14,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFCCFBF1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF5EEAD4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.verified, color: Color(0xFF0F766E), size: 14),
          SizedBox(width: 4),
          Text(
            'Verified Flat',
            style: TextStyle(
              color: Color(0xFF0F766E),
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
