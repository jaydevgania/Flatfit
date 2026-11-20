import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flatfit/config/theme/app_colors.dart';
import 'package:flatfit/config/theme/app_dimensions.dart';
import 'package:flatfit/core/widgets/loading_skeleton.dart';

/// User avatar widget with cached image, initials fallback, and verified badge.
class AvatarWidget extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double size;
  final bool isVerified;
  final VoidCallback? onTap;
  final Color? borderColor;

  const AvatarWidget({
    super.key,
    this.imageUrl,
    this.name,
    this.size = AppDimensions.avatarMd,
    this.isVerified = false,
    this.onTap,
    this.borderColor,
  });

  String _getInitials(String? fullName) {
    if (fullName == null || fullName.trim().isEmpty) return '?';
    final parts = fullName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final badgeSize = size * 0.32;

    Widget avatarContent = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: borderColor != null
            ? Border.all(color: borderColor!, width: 2)
            : null,
      ),
      child: ClipOval(
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                width: size,
                height: size,
                fit: BoxFit.cover,
                placeholder: (context, url) => LoadingSkeleton.circle(size: size),
                errorWidget: (context, url, error) => _buildInitialsFallback(),
              )
            : _buildInitialsFallback(),
      ),
    );

    if (onTap != null) {
      avatarContent = GestureDetector(
        onTap: onTap,
        child: avatarContent,
      );
    }

    if (!isVerified) return avatarContent;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        avatarContent,
        Positioned(
          right: -2,
          bottom: -2,
          child: Container(
            width: badgeSize,
            height: badgeSize,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).scaffoldBackgroundColor,
                width: 2,
              ),
            ),
            child: Icon(
              Icons.check,
              size: badgeSize * 0.65,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInitialsFallback() {
    return Container(
      color: AppColors.secondary.withOpacity(0.15),
      alignment: Alignment.center,
      child: Text(
        _getInitials(name),
        style: TextStyle(
          fontSize: size * 0.4,
          fontWeight: FontWeight.w600,
          color: AppColors.secondary,
        ),
      ),
    );
  }
}
