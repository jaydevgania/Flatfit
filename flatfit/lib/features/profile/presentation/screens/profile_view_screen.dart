import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/profile_model.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_completion_meter.dart';

/// Full profile view screen for own profile or other users
class ProfileViewScreen extends ConsumerStatefulWidget {
  final String? userId;

  const ProfileViewScreen({super.key, this.userId});

  @override
  ConsumerState<ProfileViewScreen> createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends ConsumerState<ProfileViewScreen> {
  int _currentPhotoIndex = 0;
  bool _isPlayingVoice = false;

  bool get _isOwnProfile =>
      widget.userId == null ||
      widget.userId == ref.read(profileRepositoryProvider).currentUserId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Watch profile: if userId given, watch otherUserProfileProvider, else watch profileProvider
    final profileAsync = widget.userId != null && !_isOwnProfile
        ? ref.watch(otherUserProfileProvider(widget.userId!))
        : ref.watch(profileProvider);

    return Scaffold(
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              Text('Error loading profile: $err'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  if (_isOwnProfile) {
                    ref.read(profileProvider.notifier).loadProfile();
                  } else {
                    ref.refresh(otherUserProfileProvider(widget.userId!));
                  }
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('Profile not found'));
          }
          return _buildProfileContent(context, profile, theme);
        },
      ),
    );
  }

  Widget _buildProfileContent(
      BuildContext context, Profile profile, ThemeData theme) {
    final photos = profile.photos;

    return CustomScrollView(
      slivers: [
        // Sliver AppBar with Photo Carousel
        SliverAppBar(
          expandedHeight: 380,
          pinned: true,
          actions: [
            if (_isOwnProfile)
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: 'Edit Profile',
                onPressed: () => context.push('/profile/edit'),
              )
            else
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () => _showProfileActions(context),
              ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: photos.isNotEmpty
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      PageView.builder(
                        itemCount: photos.length,
                        onPageChanged: (i) => setState(() => _currentPhotoIndex = i),
                        itemBuilder: (context, i) {
                          return CachedNetworkImage(
                            imageUrl: photos[i].url,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(
                              color: Colors.grey.shade200,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (_, __, ___) => const Center(
                              child: Icon(Icons.person, size: 80, color: Colors.grey),
                            ),
                          );
                        },
                      ),
                      // Carousel Indicator
                      Positioned(
                        bottom: 16,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            photos.length,
                            (index) => Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentPhotoIndex == index
                                    ? Colors.white
                                    : Colors.white.withValues(alpha: 0.4),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.person, size: 100, color: Colors.white),
                  ),
          ),
        ),

        // Profile Details Body
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name & Age Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${profile.fullName}${profile.age != null ? ', ${profile.age}' : ''}',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (profile.housingGoal != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.colorScheme.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          '${profile.housingGoal!.emoji} ${profile.housingGoal!.label}',
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

                // Occupation & City
                Row(
                  children: [
                    if (profile.occupation != null) ...[
                      Text(
                        '${profile.occupation!.emoji} ${profile.occupation!.label}',
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                      const SizedBox(width: 8),
                      const Text('•', style: TextStyle(color: Colors.grey)),
                      const SizedBox(width: 8),
                    ],
                    if (profile.city != null)
                      Text(
                        '📍 ${profile.city}',
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                // Voice / Video Intro Bar (if available)
                if (profile.voiceIntro != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.purple.shade50, Colors.pink.shade50],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.purple.shade100),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            _isPlayingVoice
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_fill,
                            size: 32,
                            color: Colors.purple,
                          ),
                          onPressed: () {
                            setState(() => _isPlayingVoice = !_isPlayingVoice);
                          },
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Voice Greeting',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              Text(
                                '${profile.voiceIntro!.durationSeconds}s intro clip',
                                style: const TextStyle(fontSize: 11, color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.graphic_eq, color: Colors.purple),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Completion Meter (only for own profile)
                if (_isOwnProfile) ...[
                  ProfileCompletionMeter(
                    percentage: profile.profileCompletion,
                    isCircular: false,
                    onTapSuggestions: () => context.push('/profile/edit'),
                  ),
                  const SizedBox(height: 20),
                ],

                // Budget & Stay Duration Grid
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Budget',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              profile.budgetMin != null && profile.budgetMax != null
                                  ? '₹${(profile.budgetMin! / 1000).toStringAsFixed(0)}k - ₹${(profile.budgetMax! / 1000).toStringAsFixed(0)}k'
                                  : 'Negotiable',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(height: 30, width: 1, color: Colors.grey.shade300),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Stay Duration',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              profile.stayDuration ?? 'Flexible',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Preferred Localities
                if (profile.preferredLocalities.isNotEmpty) ...[
                  Text(
                    'Preferred Localities',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: profile.preferredLocalities.map((loc) {
                      return Chip(
                        avatar: const Icon(Icons.location_on, size: 14),
                        label: Text(loc, style: const TextStyle(fontSize: 12)),
                        backgroundColor: Colors.blue.shade50,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                ],

                // Bio
                if (profile.bio != null && profile.bio!.isNotEmpty) ...[
                  Text(
                    'About Me',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    profile.bio!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Lifestyle Questionnaire link or summary
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  color: Colors.deepPurple.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.psychology_outlined,
                          size: 32,
                          color: Colors.deepPurple,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Lifestyle Compatibility',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _isOwnProfile
                                    ? 'Take or update your 20-question lifestyle quiz.'
                                    : 'Check compatibility breakdown with ${profile.fullName}.',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.deepPurple,
                          ),
                          onPressed: () => context.push('/questionnaire'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showProfileActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share Profile'),
              onTap: () => Navigator.pop(ctx),
            ),
            ListTile(
              leading: const Icon(Icons.block, color: Colors.orange),
              title: const Text('Block User'),
              onTap: () => Navigator.pop(ctx),
            ),
            ListTile(
              leading: const Icon(Icons.report, color: Colors.red),
              title: const Text('Report User'),
              onTap: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }
}
