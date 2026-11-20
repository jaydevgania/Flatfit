import 'package:flutter/material.dart';
import 'package:flatfit/config/theme/app_colors.dart';
import 'package:flatfit/config/theme/app_dimensions.dart';
import 'package:flatfit/config/theme/app_text_styles.dart';
import 'package:flatfit/core/widgets/flatfit_button.dart';

/// App error widget with illustrative icon, description, and retry action.
class AppErrorWidget extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final String retryLabel;

  const AppErrorWidget({
    super.key,
    this.title = 'Something went wrong',
    this.message = 'We encountered an error while loading. Please try again.',
    this.onRetry,
    this.retryLabel = 'Try Again',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacing3xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacingXxl),
              decoration: BoxDecoration(
                color: AppColors.errorLight.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 56,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingXl),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.headlineSmall,
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondaryLight,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppDimensions.spacingXxl),
              FlatFitButton(
                text: retryLabel,
                onPressed: onRetry,
                isFullWidth: false,
                icon: Icons.refresh_rounded,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
