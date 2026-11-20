import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../matching/domain/profile.dart';
import '../providers/discovery_provider.dart';
import '../widgets/swipe_card.dart';
import 'profile_detail_screen.dart';

/// Tinder-style card stack with swipe left, right, and up (super-interest).
///
/// Features:
/// - 3-card parallax stack
/// - Spring-animated card dismissal
/// - Bottom quick action buttons (Rewind, Pass, Super Interest, Like)
/// - Empty feed state with refresh action
class SwipeViewScreen extends ConsumerWidget {
  const SwipeViewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(discoveryProvider);
    final notifier = ref.read(discoveryProvider.notifier);

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.profiles.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_search_rounded,
                  size: 48,
                  color: Color(0xFF4F46E5),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'No more profiles in this area!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Try broadening your budget or expanding preferred localities in Mumbai.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => notifier.loadProfiles(),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Refresh Feed'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final topProfile = state.profiles.first;

    return Column(
      children: [
        // Card Stack Area
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Stack(
              children: [
                // 3rd card in stack (parallax background)
                if (state.profiles.length > 2)
                  Transform.scale(
                    scale: 0.90,
                    child: Transform.translate(
                      offset: const Offset(0, 24),
                      child: Opacity(
                        opacity: 0.5,
                        child: SwipeCard(
                          profile: state.profiles[2],
                          compatibilityScore: 78.0,
                          isTopCard: false,
                        ),
                      ),
                    ),
                  ),

                // 2nd card in stack (intermediate parallax)
                if (state.profiles.length > 1)
                  Transform.scale(
                    scale: 0.95,
                    child: Transform.translate(
                      offset: const Offset(0, 12),
                      child: Opacity(
                        opacity: 0.85,
                        child: SwipeCard(
                          profile: state.profiles[1],
                          compatibilityScore: 84.0,
                          isTopCard: false,
                        ),
                      ),
                    ),
                  ),

                // Top active draggable card
                SwipeCard(
                  key: ValueKey(topProfile.id),
                  profile: topProfile,
                  compatibilityScore: 92.0,
                  isTopCard: true,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ProfileDetailScreen(profile: topProfile),
                      ),
                    );
                  },
                  onSwipeLeft: () => notifier.swipeLeft(topProfile.id),
                  onSwipeRight: () => notifier.swipeRight(topProfile.id),
                  onSwipeUp: () => notifier.swipeUp(topProfile.id),
                ),
              ],
            ),
          ),
        ),

        // Bottom Action Controls
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Rewind / Refresh button
              _buildRoundActionBtn(
                icon: Icons.replay_rounded,
                color: const Color(0xFFF59E0B),
                size: 46,
                onPressed: () => notifier.loadProfiles(),
              ),

              // Pass (Left Swipe) button
              _buildRoundActionBtn(
                icon: Icons.close_rounded,
                color: const Color(0xFFEF4444),
                size: 60,
                onPressed: () => notifier.swipeLeft(topProfile.id),
              ),

              // Super Interest (Up Swipe) button
              _buildRoundActionBtn(
                icon: Icons.star_rounded,
                color: const Color(0xFF3B82F6),
                size: 48,
                onPressed: () => notifier.swipeUp(topProfile.id),
              ),

              // Like / Connect (Right Swipe) button
              _buildRoundActionBtn(
                icon: Icons.favorite_rounded,
                color: const Color(0xFF10B981),
                size: 60,
                onPressed: () => notifier.swipeRight(topProfile.id),
              ),

              // Info / Detail button
              _buildRoundActionBtn(
                icon: Icons.info_outline_rounded,
                color: const Color(0xFF8B5CF6),
                size: 46,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ProfileDetailScreen(profile: topProfile),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRoundActionBtn({
    required IconData icon,
    required Color color,
    required double size,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.4), width: 1.5),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, color: color, size: size * 0.52),
        onPressed: onPressed,
      ),
    );
  }
}
