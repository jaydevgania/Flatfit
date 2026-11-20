import 'package:flutter/material.dart';
import '../../domain/verification_type.dart';

class VerificationBadge extends StatelessWidget {
  final VerificationType type;
  final VerificationStatus status;
  final bool isCompact;

  const VerificationBadge({
    Key? key,
    required this.type,
    required this.status,
    this.isCompact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDone = status == VerificationStatus.verified;
    final color = status.color;

    if (isCompact) {
      return Tooltip(
        message: '${type.displayName}: ${status.displayName}',
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.4)),
          ),
          child: Icon(type.icon, size: 14, color: color),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isDone ? Icons.check_circle : type.icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            type.displayName,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
