import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../domain/profile_model.dart';

/// Compact profile display card for lists and search results
class ProfileCard extends StatelessWidget {
  final Profile profile;
  final VoidCallback? onTap;
  final int? matchScore;

  const ProfileCard({
    super.key,
    required this.profile,
    this.onTap,
    this.matchScore,
  });

  String _formatBudget(int? min, int? max) {
    if (min == null && max == null) return 'Budget not set';
    if (min != null && max != null) {
      return '₹${(min / 1000).toStringAsFixed(0)}k - ₹${(max / 1000).toStringAsFixed(0)}k';
    }
    if (min != null) return 'From ₹${(min / 1000).toStringAsFixed(0)}k';
    return 'Up to ₹${(max! / 1000).toStringAsFixed(0)}k';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryPhoto = profile.photos.isNotEmpty
        ? profile.photos.firstWhere(
            (p) => p.isPrimary,
            orElse: () => profile.photos.first,
          )
        : null;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section: Photo Header with overlay badges
            Stack(
              children: [
                SizedBox(
                  height: 180,
                  width: double.infinity,
                  child: primaryPhoto != null
                      ? CachedNetworkImage(
                          imageUrl: primaryPhoto.url,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.person, size: 64, color: Colors.grey),
                          ),
                        )
                      : Container(
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.person, size: 64, color: Colors.grey),
                        ),
                ),

                // Match score badge
                if (matchScore != null)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade600,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.bolt, size: 14, color: Colors.white),
                          const SizedBox(width: 2),
                          Text(
                            '$matchScore% Match',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Housing goal badge
                if (profile.housingGoal != null)
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(profile.housingGoal!.emoji),
                          const SizedBox(width: 4),
                          Text(
                            profile.housingGoal!.label,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),

            // Bottom Section: Info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${profile.fullName}${profile.age != null ? ', ${profile.age}' : ''}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        _formatBudget(profile.budgetMin, profile.budgetMax),
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Occupation and City
                  Row(
                    children: [
                      if (profile.occupation != null) ...[
                        Text(
                          '${profile.occupation!.emoji} ${profile.occupation!.label}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('•', style: TextStyle(color: Colors.grey)),
                        const SizedBox(width: 8),
                      ],
                      if (profile.city != null)
                        Text(
                          profile.city!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade700,
                          ),
                        ),
                    ],
                  ),

                  // Localities
                  if (profile.preferredLocalities.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: profile.preferredLocalities.take(3).map((loc) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(
                            loc,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.black87,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
