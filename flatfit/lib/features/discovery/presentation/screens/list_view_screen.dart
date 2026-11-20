import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flatfit/features/matching/presentation/providers/matching_provider.dart';
import '../providers/discovery_provider.dart';
import '../providers/interest_provider.dart';
import '../providers/shortlist_provider.dart';
import '../widgets/match_card.dart';
import 'profile_detail_screen.dart';

/// Scrollable list view of potential flatmate matches with sorting and quick actions.
class ListViewScreen extends ConsumerWidget {
  const ListViewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discoveryState = ref.watch(discoveryProvider);
    final matchesState = ref.watch(matchesProvider);
    final shortlistState = ref.watch(shortlistProvider);
    final shortlistNotifier = ref.read(shortlistProvider.notifier);
    final interestNotifier = ref.read(interestProvider.notifier);

    if (discoveryState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (discoveryState.profiles.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.search_off_rounded, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'No matches found for your filters',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Try adjusting your budget or selecting more localities.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(discoveryProvider.notifier).loadProfiles(),
                child: const Text('Reset & Refresh'),
              ),
            ],
          ),
        ),
      );
    }

    // Map matched profiles with precomputed scores if available
    final scoreMap = <String, double>{};
    final compatTopicsMap = <String, List<String>>{};
    final watchOutTopicsMap = <String, List<String>>{};

    for (final m in matchesState.matches) {
      scoreMap[m.profile.id] = m.score;
      compatTopicsMap[m.profile.id] = m.compatibleTopics;
      watchOutTopicsMap[m.profile.id] = m.watchOutTopics;
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(discoveryProvider.notifier).loadProfiles();
        await ref.read(matchesProvider.notifier).loadMatches();
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        itemCount: discoveryState.profiles.length,
        itemBuilder: (context, index) {
          final profile = discoveryState.profiles[index];
          final score = scoreMap[profile.id] ?? 85.0;
          final compat = compatTopicsMap[profile.id] ??
              ['Sleep Schedule', 'Cleanliness', 'Smoking Policy'];
          final watchOut = watchOutTopicsMap[profile.id] ?? [];
          final isShortlisted = shortlistState.shortlistedIds.contains(profile.id);

          return MatchCard(
            profile: profile,
            score: score,
            compatibleTopics: compat,
            watchOutTopics: watchOut,
            isShortlisted: isShortlisted,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ProfileDetailScreen(
                    profile: profile,
                    score: score,
                    compatibleTopics: compat,
                    watchOutTopics: watchOut,
                  ),
                ),
              );
            },
            onShortlistToggle: () {
              shortlistNotifier.toggleShortlist(profile);
            },
            onSendInterest: () {
              interestNotifier.sendInterest(targetUserId: profile.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Interest sent to ${profile.fullName}!'),
                  backgroundColor: const Color(0xFF10B981),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
