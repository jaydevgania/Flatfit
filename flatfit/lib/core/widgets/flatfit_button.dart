import 'package:flutter/material.dart';
import 'package:flatfit/config/theme/app_colors.dart';
import 'package:flatfit/config/theme/app_dimensions.dart';
import 'package:flatfit/config/theme/app_text_styles.dart';

enum FlatFitButtonVariant { primary, secondary, outline, text }

/// Reusable branded button supporting primary, secondary, outline, and text variants.
class FlatFitButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final FlatFitButtonVariant variant;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final double height;

  const FlatFitButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = FlatFitButtonVariant.primary,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.height = AppDimensions.buttonHeight,
  });

  const FlatFitButton.secondary({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.height = AppDimensions.buttonHeight,
  }) : variant = FlatFitButtonVariant.secondary;

  const FlatFitButton.outline({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.height = AppDimensions.buttonHeight,
  }) : variant = FlatFitButtonVariant.outline;

  const FlatFitButton.text({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.height = AppDimensions.buttonHeightSmall,
  }) : variant = FlatFitButtonVariant.text;

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = isLoading ? null : onPressed;

    Widget content = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                variant == FlatFitButtonVariant.primary
                    ? Colors.white
                    : AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.spacingMd),
        ] else if (icon != null) ...[
          Icon(icon, size: 20),
          const SizedBox(width: AppDimensions.spacingSm),
        ],
        Text(text),
      ],
    );

    Widget button;

    switch (variant) {
      case FlatFitButtonVariant.primary:
        button = ElevatedButton(
          onPressed: effectiveOnPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
            ),
            textStyle: AppTextStyles.buttonLarge,
          ),
          child: content,
        );
        break;

      case FlatFitButtonVariant.secondary:
        button = ElevatedButton(
          onPressed: effectiveOnPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
            ),
            textStyle: AppTextStyles.buttonLarge,
          ),
          child: content,
        );
        break;

      case FlatFitButtonVariant.outline:
        button = OutlinedButton(
          onPressed: effectiveOnPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
            ),
            textStyle: AppTextStyles.buttonLarge,
          ),
          child: content,
        );
        break;

      case FlatFitButtonVariant.text:
        button = TextButton(
          onPressed: effectiveOnPressed,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: AppTextStyles.buttonMedium,
          ),
          child: content,
        );
        break;
    }

    return SizedBox(
      height: height,
      width: isFullWidth ? double.infinity : null,
      child: button,
    );
  }
}
