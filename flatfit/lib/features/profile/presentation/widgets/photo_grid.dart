import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../domain/profile_model.dart';

/// 5-slot photo grid with add, remove, and primary photo marker
class PhotoGrid extends StatelessWidget {
  final List<ProfilePhoto>? remotePhotos;
  final List<String>? localPhotoPaths;
  final VoidCallback onAddPhoto;
  final Function(int index) onRemovePhoto;
  final Function(int index)? onSetPrimary;
  final int maxSlots;

  const PhotoGrid({
    super.key,
    this.remotePhotos,
    this.localPhotoPaths,
    required this.onAddPhoto,
    required this.onRemovePhoto,
    this.onSetPrimary,
    this.maxSlots = 5,
  });

  int get _photoCount {
    if (remotePhotos != null) return remotePhotos!.length;
    if (localPhotoPaths != null) return localPhotoPaths!.length;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Profile Photos ($_photoCount/$maxSlots)',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            if (_photoCount < maxSlots)
              TextButton.icon(
                onPressed: onAddPhoto,
                icon: const Icon(Icons.add_a_photo, size: 18),
                label: const Text('Add Photo'),
              ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.85,
          ),
          itemCount: maxSlots,
          itemBuilder: (context, index) {
            return _buildSlot(context, index);
          },
        ),
      ],
    );
  }

  Widget _buildSlot(BuildContext context, int index) {
    final theme = Theme.of(context);

    // If slot has a photo
    if (index < _photoCount) {
      final isPrimary = index == 0;

      return Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isPrimary ? theme.colorScheme.primary : Colors.grey.shade300,
                width: isPrimary ? 2.5 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: _buildImage(index),
            ),
          ),

          // Primary badge
          if (isPrimary)
            Positioned(
              top: 6,
              left: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, size: 10, color: Colors.white),
                    SizedBox(width: 2),
                    Text(
                      'Primary',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Delete button
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => onRemovePhoto(index),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 14, color: Colors.white),
              ),
            ),
          ),
        ],
      );
    }

    // Empty placeholder slot
    final isNextSlot = index == _photoCount;
    return InkWell(
      onTap: isNextSlot ? onAddPhoto : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isNextSlot
                ? theme.colorScheme.primary.withValues(alpha: 0.5)
                : Colors.grey.shade300,
            style: isNextSlot ? BorderStyle.solid : BorderStyle.none,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isNextSlot ? Icons.add_circle_outline : Icons.photo_outlined,
              size: 28,
              color: isNextSlot ? theme.colorScheme.primary : Colors.grey.shade400,
            ),
            const SizedBox(height: 4),
            Text(
              index == 0 ? 'Main Photo' : 'Slot ${index + 1}',
              style: TextStyle(
                fontSize: 11,
                color: isNextSlot
                    ? theme.colorScheme.primary
                    : Colors.grey.shade500,
                fontWeight: isNextSlot ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(int index) {
    if (remotePhotos != null && index < remotePhotos!.length) {
      final photo = remotePhotos![index];
      return CachedNetworkImage(
        imageUrl: photo.url,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.grey.shade200,
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      );
    }

    if (localPhotoPaths != null && index < localPhotoPaths!.length) {
      final path = localPhotoPaths![index];
      if (path.startsWith('http')) {
        return CachedNetworkImage(
          imageUrl: path,
          fit: BoxFit.cover,
        );
      }
      return Image.file(
        File(path),
        fit: BoxFit.cover,
      );
    }

    return const SizedBox();
  }
}
