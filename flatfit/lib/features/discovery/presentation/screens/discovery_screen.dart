import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/discovery_provider.dart';
import '../providers/filters_provider.dart';
import '../widgets/filter_chip_bar.dart';
import 'filters_screen.dart';
import 'group_search_screen.dart';
import 'interest_requests_screen.dart';
import 'list_view_screen.dart';
import 'locality_insights_screen.dart';
import 'saved_searches_screen.dart';
import 'shortlist_screen.dart';
import 'swipe_view_screen.dart';

/// Main Discovery hub for FlatFit.
///
/// Features:
/// - Seamless toggle between Tinder-style Swipe View and scrollable List View
/// - FilterChipBar with active filter count & one-tap locality filters
/// - Quick navigation to Shortlists, Interest Requests, Group Search & Locality Insights
class DiscoveryScreen extends ConsumerWidget {
  const DiscoveryScreen({super.key});

  void _openFilters(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FiltersScreen(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(discoveryProvider);
    final notifier = ref.read(discoveryProvider.notifier);
    final filters = ref.watch(filtersProvider);
    final filtersNotifier = ref.read(filtersProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 8),
            const Text(
              'FlatFit',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Color(0xFF111827),
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        actions: [
          // View Toggle Button (Swipe vs List)
          IconButton(
            tooltip: state.viewMode == DiscoveryViewMode.swipe
                ? 'Switch to List View'
                : 'Switch to Swipe Cards',
            icon: Icon(
              state.viewMode == DiscoveryViewMode.swipe
                  ? Icons.view_agenda_outlined
                  : Icons.view_carousel_rounded,
              color: const Color(0xFF4F46E5),
            ),
            onPressed: () => notifier.toggleViewMode(),
          ),

          // Locality Insights button
          IconButton(
            tooltip: 'Mumbai Locality Insights',
            icon: const Icon(Icons.map_outlined, color: Color(0xFF374151)),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const LocalityInsightsScreen()),
              );
            },
          ),

          // Groups / Squads
          IconButton(
            tooltip: 'Squads (Group Search)',
            icon: const Icon(Icons.groups_outlined, color: Color(0xFF374151)),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const GroupSearchScreen()),
              );
            },
          ),

          // Saved Searches
          IconButton(
            tooltip: 'Saved Searches',
            icon: const Icon(Icons.bookmark_border_rounded, color: Color(0xFF374151)),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SavedSearchesScreen()),
              );
            },
          ),

          // Shortlist Heart
          IconButton(
            tooltip: 'Shortlisted Flatmates',
            icon: const Icon(Icons.favorite_border_rounded, color: Color(0xFFEF4444)),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ShortlistScreen()),
              );
            },
          ),

          // Interest Requests Inbox
          IconButton(
            tooltip: 'Interest Requests',
            icon: const Icon(Icons.mail_outline_rounded, color: Color(0xFF374151)),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const InterestRequestsScreen()),
              );
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter Chip Bar
            FilterChipBar(
              filters: filters,
              onOpenFilters: () => _openFilters(context),
              onQuickLocalityToggle: (loc) {
                filtersNotifier.toggleLocality(loc);
                notifier.loadProfiles();
              },
              onResetFilters: () {
                filtersNotifier.resetFilters();
                notifier.loadProfiles();
              },
            ),

            // Active View: Swipe Card Stack vs Scrollable List
            Expanded(
              child: state.viewMode == DiscoveryViewMode.swipe
                  ? const SwipeViewScreen()
                  : const ListViewScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
