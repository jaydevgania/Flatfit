import 'package:flutter/material.dart';
import '../../domain/conversation_safety.dart';

/// Reusable banner displayed inside chat threads when scam signals or risky patterns are detected.
class SafetyWarningBanner extends StatelessWidget {
  final SafetyWarning warning;
  final VoidCallback? onDismiss;
  final VoidCallback? onReport;

  const SafetyWarningBanner({
    super.key,
    required this.warning,
    this.onDismiss,
    this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    final isCritical = warning.riskLevel == SafetyRiskLevel.critical;
    final isHigh = warning.riskLevel == SafetyRiskLevel.high;

    final bgColor = isCritical
        ? const Color(0xFFFEF2F2)
        : isHigh
            ? const Color(0xFFFFFBEB)
            : const Color(0xFFEFF6FF);

    final borderColor = isCritical
        ? const Color(0xFFFCA5A5)
        : isHigh
            ? const Color(0xFFFCD34D)
            : const Color(0xFF93C5FD);

    final iconColor = isCritical
        ? const Color(0xFFDC2626)
        : isHigh
            ? const Color(0xFFD97706)
            : const Color(0xFF2563EB);

    final textColor = isCritical
        ? const Color(0xFF991B1B)
        : isHigh
            ? const Color(0xFF92400E)
            : const Color(0xFF1E40AF);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isCritical ? Icons.gpp_bad : Icons.shield_outlined,
                color: iconColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  warning.title,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              if (onDismiss != null)
                InkWell(
                  onTap: onDismiss,
                  child: Icon(Icons.close, size: 18, color: textColor.withOpacity(0.6)),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            warning.description,
            style: TextStyle(color: textColor.withOpacity(0.9), fontSize: 12, height: 1.3),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'Safety Tip: ${warning.safetyTip}',
              style: TextStyle(color: textColor, fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),
          if (isCritical || isHigh) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (onReport != null)
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFDC2626),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      visualDensity: VisualDensity.compact,
                    ),
                    icon: const Icon(Icons.report_problem, size: 14),
                    label: const Text('Report User', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    onPressed: onReport,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
