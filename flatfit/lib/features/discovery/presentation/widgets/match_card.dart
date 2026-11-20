import 'package:flutter/material.dart';
import '../../matching/domain/profile.dart';
import 'compatibility_badge.dart';
import 'compatibility_breakdown.dart';

/// Compact profile card used in the scrollable list view.
class MatchCard extends StatelessWidget {
  final Profile profile;
  final double score;
  final List<String> compatibleTopics;
  final List<String> watchOutTopics;
  final bool isShortlisted;
  final VoidCallback? onTap;
  final VoidCallback? onShortlistToggle;
  final VoidCallback? onSendInterest;

  const MatchCard({
    super.key,
    required this.profile,
    this.score = 85.0,
    this.compatibleTopics = const [],
    this.watchOutTopics = const [],
    this.isShortlisted = false,
    this.onTap,
    this.onShortlistToggle,
    this.onSendInterest,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: Avatar thumbnail, Name/Details, Compatibility Badge
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Photo thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.network(
                      profile.displayPhoto,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 72,
                        height: 72,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.person, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Name, age, verified, occupation, locality
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                '${profile.fullName}, ${profile.age}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1F2937),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (profile.isVerified) ...[
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.verified_rounded,
                                size: 16,
                                color: Color(0xFF0284C7),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          profile.companyOrCollege ?? profile.occupation,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined,
                                size: 13, color: Colors.grey.shade500),
                            const SizedBox(width: 2),
                            Text(
                              profile.locality ?? profile.city,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '• ${profile.budgetDisplay}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF111827),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Score badge
                  CompatibilityBadge(score: score, size: BadgeSize.small),
                ],
              ),

              const SizedBox(height: 10),
              const Divider(height: 1, thickness: 0.8),
              const SizedBox(height: 8),

              // Compatibility breakdown snippet
              CompatibilityBreakdown(
                compatibleTopics: compatibleTopics,
                watchOutTopics: watchOutTopics,
                isCompact: true,
              ),

              const SizedBox(height: 10),

              // Bottom action row: Key traits & Quick actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // First 2 key traits
                  Expanded(
                    child: Wrap(
                      spacing: 4,
                      children: profile.keyTraits.take(2).map((t) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            t,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF4B5563),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  // Actions: Shortlist heart & Connect button
                  Row(
                    children: [
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        icon: Icon(
                          isShortlisted
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: isShortlisted ? Colors.red : Colors.grey,
                          size: 22,
                        ),
                        onPressed: onShortlistToggle,
                      ),
                      const SizedBox(width: 4),
                      ElevatedButton(
                        onPressed: onSendInterest,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4F46E5),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                          visualDensity: VisualDensity.compact,
                        ),
                        child: const Text(
                          'Connect',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
