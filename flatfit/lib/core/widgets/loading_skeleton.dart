import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flatfit/config/theme/app_colors.dart';
import 'package:flatfit/config/theme/app_dimensions.dart';

/// Shimmer loading placeholder for skeleton screens.
class LoadingSkeleton extends StatelessWidget {
  final double? width;
  final double height;
  final double borderRadius;
  final ShapeBorder? shape;

  const LoadingSkeleton({
    super.key,
    this.width,
    required this.height,
    this.borderRadius = AppDimensions.radiusSm,
    this.shape,
  });

  const LoadingSkeleton.circle({
    super.key,
    required double size,
  })  : width = size,
        height = size,
        borderRadius = size / 2,
        shape = const CircleBorder();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? AppColors.shimmerBaseDark : AppColors.shimmerBaseLight;
    final highlightColor =
        isDark ? AppColors.shimmerHighlightDark : AppColors.shimmerHighlightLight;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: shape != null
            ? ShapeDecoration(
                color: baseColor,
                shape: shape!,
              )
            : BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
      ),
    );
  }
}
