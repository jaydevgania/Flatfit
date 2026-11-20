import 'package:flutter/material.dart';

enum BadgeSize { small, medium, large }

/// Visual badge presenting compatibility score (0-100) with color coding:
/// - Green (>= 80%): Great match
/// - Amber (60-79%): Good match
/// - Red (< 60%): Lower compatibility
class CompatibilityBadge extends StatelessWidget {
  final double score;
  final BadgeSize size;
  final bool showLabel;

  const CompatibilityBadge({
    super.key,
    required this.score,
    this.size = BadgeSize.medium,
    this.showLabel = false,
  });

  Color get _badgeColor {
    if (score >= 80.0) return const Color(0xFF10B981); // Emerald green
    if (score >= 60.0) return const Color(0xFFF59E0B); // Amber
    return const Color(0xFFEF4444); // Crimson red
  }

  Color get _backgroundColor {
    return _badgeColor.withOpacity(0.16);
  }

  String get _label {
    if (score >= 80.0) return 'Great Match';
    if (score >= 60.0) return 'Good Match';
    if (score >= 40.0) return 'Worth a Chat';
    return 'Might be Tricky';
  }

  @override
  Widget build(BuildContext context) {
    final int displayScore = score.round();

    double fontSize = 14;
    double paddingH = 10;
    double paddingV = 4;
    double iconSize = 14;

    if (size == BadgeSize.small) {
      fontSize = 11;
      paddingH = 6;
      paddingV = 2;
      iconSize = 11;
    } else if (size == BadgeSize.large) {
      fontSize = 20;
      paddingH = 14;
      paddingV = 6;
      iconSize = 20;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _badgeColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: _badgeColor.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.bolt_rounded,
            color: _badgeColor,
            size: iconSize,
          ),
          const SizedBox(width: 4),
          Text(
            '$displayScore%',
            style: TextStyle(
              color: _badgeColor,
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
              letterSpacing: -0.2,
            ),
          ),
          if (showLabel) ...[
            const SizedBox(width: 6),
            Text(
              '• $_label',
              style: TextStyle(
                color: _badgeColor,
                fontWeight: FontWeight.w600,
                fontSize: fontSize * 0.9,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
