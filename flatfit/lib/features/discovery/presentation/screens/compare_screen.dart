import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../matching/domain/profile.dart';
import '../providers/interest_provider.dart';
import '../providers/shortlist_provider.dart';
import '../widgets/compare_column.dart';

/// Side-by-side comparison screen for 2 to 3 candidate flatmate profiles.
class CompareScreen extends ConsumerStatefulWidget {
  final List<Profile> initialProfiles;

  const CompareScreen({
    super.key,
    this.initialProfiles = const [],
  });

  @override
  ConsumerState<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends ConsumerState<CompareScreen> {
  static const List<String> compareTopics = [
    'Cleanliness',
    'Sleep Schedule',
    'Smoking Policy',
    'Food / Diet',
    'Drinking',
    'Guests Policy',
    'Noise Level',
    'Pets Policy',
    'WFH Habits',
    'Rent Punctuality',
  ];

  // Mock answers map per profile ID
  final Map<String, Map<String, String>> _profileAnswers = {
    'p_rohan': {
      'Cleanliness': 'Very Tidy (daily)',
      'Sleep Schedule': 'Early Bird (10pm-6am)',
      'Smoking Policy': 'Never (Deal breaker)',
      'Food / Diet': 'Pure Veg friendly',
      'Drinking': 'Socially / Weekends',
      'Guests Policy': 'Daytime ok, no parties',
      'Noise Level': 'Quiet / Headphones',
      'Pets Policy': 'Pet friendly',
      'WFH Habits': 'Hybrid (2 days home)',
      'Rent Punctuality': 'Always 1st of month',
    },
    'p_priya': {
      'Cleanliness': 'Moderate / Weekend cleaning',
      'Sleep Schedule': 'Moderate (11pm-7am)',
      'Smoking Policy': 'Never',
      'Food / Diet': 'Vegetarian with eggs',
      'Drinking': 'Occasional drinks',
      'Guests Policy': 'Friends welcome',
      'Noise Level': 'Moderate music ok',
      'Pets Policy': 'Loves cats & dogs',
      'WFH Habits': 'Fully remote dev',
      'Rent Punctuality': 'Always on time',
    },
    'p_tanvi': {
      'Cleanliness': 'Neat Freak / Strict hygiene',
      'Sleep Schedule': 'Early Bird (11pm-6:30am)',
      'Smoking Policy': 'Never',
      'Food / Diet': 'Pure Veg only',
      'Drinking': 'Teetotaler',
      'Guests Policy': 'Rarely guests',
      'Noise Level': 'Silent study environment',
      'Pets Policy': 'No pets preferred',
      'WFH Habits': 'Office 5 days/week',
      'Rent Punctuality': 'Strict direct debit',
    },
    'p_aarav': {
      'Cleanliness': 'Relaxed / maid takes care',
      'Sleep Schedule': 'Night Owl (2am-9am)',
      'Smoking Policy': 'Occasional balcony',
      'Food / Diet': 'Non-vegetarian',
      'Drinking': 'Social / beer on weekends',
      'Guests Policy': 'Friends often over',
      'Noise Level': 'Movie screenings on weekends',
      'Pets Policy': 'Loves animals',
      'WFH Habits': 'Freelance from home',
      'Rent Punctuality': 'Within first week',
    },
  };

  @override
  Widget build(BuildContext context) {
    final shortlistState = ref.watch(shortlistProvider);
    final shortlistNotifier = ref.read(shortlistProvider.notifier);

    final profilesToCompare = shortlistState.selectedForCompare.isNotEmpty
        ? shortlistState.selectedForCompare
        : (widget.initialProfiles.isNotEmpty
            ? widget.initialProfiles
            : shortlistState.shortlisted.take(3).toList());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Compare Flatmates (${profilesToCompare.length}/3)',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (profilesToCompare.isNotEmpty)
            TextButton(
              onPressed: () => shortlistNotifier.clearCompareSelection(),
              child: const Text('Clear', style: TextStyle(color: Colors.red)),
            ),
        ],
      ),
      body: profilesToCompare.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.compare_arrows_rounded,
                      size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'No profiles selected to compare',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select 2 or 3 profiles from your Shortlist to compare habits side-by-side.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Go to Shortlist'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Info banner
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: const Color(0xFFEEF2FF),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, size: 16, color: Color(0xFF4F46E5)),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Comparing lifestyle habits, cleanliness, sleep, and budget side-by-side.',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF374151),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Side by side scrollable columns
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(12),
                    itemCount: profilesToCompare.length,
                    itemBuilder: (context, idx) {
                      final profile = profilesToCompare[idx];
                      final answers = _profileAnswers[profile.id] ??
                          {
                            for (var t in compareTopics)
                              t: 'Flexible / Standard'
                          };

                      return CompareColumn(
                        profile: profile,
                        score: 90.0 - (idx * 6),
                        answers: answers,
                        compareTopics: compareTopics,
                        onRemove: () => shortlistNotifier.toggleSelectForCompare(profile),
                        onConnect: () {
                          ref.read(interestProvider.notifier).sendInterest(
                                targetUserId: profile.id,
                              );
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
                ),
              ],
            ),
    );
  }
}
