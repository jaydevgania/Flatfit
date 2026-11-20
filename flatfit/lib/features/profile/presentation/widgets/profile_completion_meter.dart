import 'package:flutter/material.dart';

/// Animated circular or linear progress meter displaying profile completion percentage
class ProfileCompletionMeter extends StatelessWidget {
  final int percentage;
  final bool isCircular;
  final VoidCallback? onTapSuggestions;

  const ProfileCompletionMeter({
    super.key,
    required this.percentage,
    this.isCircular = false,
    this.onTapSuggestions,
  });

  Color _getStatusColor() {
    if (percentage >= 80) {
      return const Color(0xFF4CAF50); // Vibrant Green
    } else if (percentage >= 50) {
      return const Color(0xFFFFA000); // Amber
    } else {
      return const Color(0xFFE53935); // Red / Coral
    }
  }

  String _getTipText() {
    if (percentage >= 100) {
      return 'All set! Your profile is 100% complete.';
    } else if (percentage >= 80) {
      return 'Almost perfect! Complete verification to get top flatmate matches.';
    } else if (percentage >= 50) {
      return 'Good start! Add photos & lifestyle quiz to boost your match rate by 3x.';
    } else {
      return 'Complete basic info & budget to get discovered by flatmates.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    final theme = Theme.of(context);

    if (isCircular) {
      return _buildCircularMeter(statusColor, theme);
    }
    return _buildLinearMeter(statusColor, theme);
  }

  Widget _buildCircularMeter(Color statusColor, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: (percentage / 100).clamp(0.0, 1.0),
                  strokeWidth: 6,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                ),
                Center(
                  child: Text(
                    '$percentage%',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profile Strength',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getTipText(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinearMeter(Color statusColor, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Profile Strength: $percentage%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                  fontSize: 14,
                ),
              ),
              if (onTapSuggestions != null && percentage < 100)
                GestureDetector(
                  onTap: onTapSuggestions,
                  child: Text(
                    'Complete +',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: (percentage / 100).clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getTipText(),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
