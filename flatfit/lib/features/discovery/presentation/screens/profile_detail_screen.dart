import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../matching/domain/profile.dart';
import '../providers/interest_provider.dart';
import '../providers/shortlist_provider.dart';
import '../widgets/compatibility_badge.dart';
import '../widgets/compatibility_breakdown.dart';
import '../widgets/interest_button.dart';

/// Full screen profile view showing photos, bio, questionnaire breakdown, and traits.
class ProfileDetailScreen extends ConsumerStatefulWidget {
  final Profile profile;
  final double score;
  final List<String> compatibleTopics;
  final List<String> watchOutTopics;

  const ProfileDetailScreen({
    super.key,
    required this.profile,
    this.score = 92.0,
    this.compatibleTopics = const ['Sleep Schedule', 'Cleanliness', 'Smoking Policy', 'Rent Punctuality'],
    this.watchOutTopics = const ['Weekend Socializing'],
  });

  @override
  ConsumerState<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends ConsumerState<ProfileDetailScreen> {
  int _activePhotoIndex = 0;

  @override
  Widget build(BuildContext context) {
    final shortlistState = ref.watch(shortlistProvider);
    final shortlistNotifier = ref.read(shortlistProvider.notifier);
    final isShortlisted = shortlistState.shortlistedIds.contains(widget.profile.id);

    final photos = widget.profile.photos.isNotEmpty
        ? widget.profile.photos
        : [widget.profile.displayPhoto];

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // App Bar with Photo Carousel
          SliverAppBar(
            expandedHeight: 380,
            pinned: true,
            backgroundColor: Colors.black,
            leading: CircleAvatar(
              backgroundColor: Colors.black45,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            actions: [
              CircleAvatar(
                backgroundColor: Colors.black45,
                child: IconButton(
                  icon: Icon(
                    isShortlisted ? Icons.favorite : Icons.favorite_border,
                    color: isShortlisted ? Colors.red : Colors.white,
                  ),
                  onPressed: () => shortlistNotifier.toggleShortlist(widget.profile),
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: Colors.black45,
                child: IconButton(
                  icon: const Icon(Icons.share, color: Colors.white),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile link copied!')),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  PageView.builder(
                    itemCount: photos.length,
                    onPageChanged: (idx) => setState(() => _activePhotoIndex = idx),
                    itemBuilder: (ctx, idx) {
                      return Image.network(
                        photos[idx],
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey.shade900,
                          child: const Icon(Icons.person, size: 80, color: Colors.white),
                        ),
                      );
                    },
                  ),
                  // Dots indicator
                  if (photos.length > 1)
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(photos.length, (idx) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: _activePhotoIndex == idx ? 18 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: _activePhotoIndex == idx ? Colors.white : Colors.white54,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          );
                        }),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Profile Body Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name, Age, Score Badge
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    '${widget.profile.fullName}, ${widget.profile.age}',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF111827),
                                    ),
                                  ),
                                ),
                                if (widget.profile.isVerified) ...[
                                  const SizedBox(width: 6),
                                  const Icon(
                                    Icons.verified_rounded,
                                    color: Color(0xFF0284C7),
                                    size: 22,
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.profile.companyOrCollege ??
                                  '${widget.profile.occupation} in Mumbai',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      CompatibilityBadge(
                        score: widget.score,
                        size: BadgeSize.large,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Key Stats Bar: Budget, Locality, Move-in
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          icon: Icons.currency_rupee_rounded,
                          title: 'Budget',
                          value: widget.profile.budgetDisplay,
                        ),
                        _buildStatDivider(),
                        _buildStatItem(
                          icon: Icons.location_on_outlined,
                          title: 'Locality',
                          value: widget.profile.locality ?? widget.profile.city,
                        ),
                        _buildStatDivider(),
                        _buildStatItem(
                          icon: Icons.calendar_today_rounded,
                          title: 'Move-in',
                          value: widget.profile.moveInDate != null
                              ? '${widget.profile.moveInDate!.day}/${widget.profile.moveInDate!.month}'
                              : 'Flexible',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Compatibility Insights Breakdown
                  CompatibilityBreakdown(
                    compatibleTopics: widget.compatibleTopics,
                    watchOutTopics: widget.watchOutTopics,
                  ),
                  const SizedBox(height: 20),

                  // Bio Section
                  if (widget.profile.bio != null && widget.profile.bio!.isNotEmpty) ...[
                    const Text(
                      'About Me',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.profile.bio!,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Key Traits Section
                  if (widget.profile.keyTraits.isNotEmpty) ...[
                    const Text(
                      'Lifestyle & Habits',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.profile.keyTraits.map((trait) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEF2FF),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFC7D2FE)),
                          ),
                          child: Text(
                            trait,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4338CA),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Preferred Localities
                  if (widget.profile.preferredLocalities.isNotEmpty) ...[
                    const Text(
                      'Preferred Areas in Mumbai',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.profile.preferredLocalities.map((loc) {
                        return Chip(
                          label: Text(loc, style: const TextStyle(fontSize: 12)),
                          backgroundColor: const Color(0xFFF3F4F6),
                          side: BorderSide.none,
                          avatar: const Icon(Icons.place_outlined, size: 14),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  const SizedBox(height: 60), // Spacing for bottom button
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Sticky Action Bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Shortlist button
              OutlinedButton.icon(
                onPressed: () => shortlistNotifier.toggleShortlist(widget.profile),
                icon: Icon(
                  isShortlisted ? Icons.favorite : Icons.favorite_border,
                  color: isShortlisted ? Colors.red : Colors.grey.shade700,
                ),
                label: Text(isShortlisted ? 'Saved' : 'Save'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey.shade800,
                  side: BorderSide(color: Colors.grey.shade300),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(width: 12),

              // Connect / Send interest button
              Expanded(
                child: InterestButton(
                  targetUserName: widget.profile.fullName,
                  onSend: (note, isSuper) async {
                    await ref.read(interestProvider.notifier).sendInterest(
                          targetUserId: widget.profile.id,
                          note: note,
                          isSuperInterest: isSuper,
                        );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF4F46E5)),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 32,
      color: Colors.grey.shade300,
    );
  }
}
