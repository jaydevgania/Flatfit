import 'package:flutter/material.dart';

class ListingQualityBadge extends StatelessWidget {
  final int qualityScore; // 0 - 100
  final bool showLabel;

  const ListingQualityBadge({
    Key? key,
    required this.qualityScore,
    this.showLabel = true,
  }) : super(key: key);

  Color _getScoreColor() {
    if (qualityScore >= 90) return const Color(0xFF059669); // Emerald
    if (qualityScore >= 75) return const Color(0xFF2563EB); // Blue
    if (qualityScore >= 60) return const Color(0xFFD97706); // Amber
    return const Color(0xFFDC2626); // Red
  }

  String _getScoreLabel() {
    if (qualityScore >= 90) return 'Top Quality (Verified Details)';
    if (qualityScore >= 75) return 'Good Quality';
    if (qualityScore >= 60) return 'Basic Details';
    return 'Incomplete Info';
  }

  @override
  Widget build(BuildContext context) {
    final color = _getScoreColor();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.stars, color: color, size: 14),
          const SizedBox(width: 4),
          Text(
            '$qualityScore% Score',
            style: TextStyle(
              color: color,
              fontSize: 11.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (showLabel) ...[
            const SizedBox(width: 6),
            Text(
              '• ${_getScoreLabel()}',
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
