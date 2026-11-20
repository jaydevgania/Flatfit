import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/listing_filters.dart';
import '../../domain/listing_type.dart';
import '../providers/listings_provider.dart';
import '../widgets/listing_card.dart';
import 'create_listing_screen.dart';
import 'listing_detail_screen.dart';
import 'map_view_screen.dart';
import 'my_listings_screen.dart';

class ListingsScreen extends ConsumerWidget {
  const ListingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(listingsProvider);
    final notifier = ref.read(listingsProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Flats & Rooms',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Manage My Listings
          IconButton(
            icon: const Icon(Icons.manage_accounts_outlined, color: Color(0xFF475569)),
            tooltip: 'My Listings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyListingsScreen()),
              );
            },
          ),
          // Toggle List / Map View
          IconButton(
            icon: Icon(
              state.viewMode == ListingViewMode.list
                  ? Icons.map_outlined
                  : Icons.view_agenda_outlined,
              color: const Color(0xFF6366F1),
            ),
            tooltip: state.viewMode == ListingViewMode.list ? 'Map View' : 'List View',
            onPressed: notifier.toggleViewMode,
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick Filter Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Sublet / Short Stay filter
                  FilterChip(
                    label: const Text('Sublet / Short Stay'),
                    selected: state.filters.isSubletOnly,
                    onSelected: (_) => notifier.toggleSubletOnly(),
                    selectedColor: const Color(0xFF6366F1),
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: state.filters.isSubletOnly ? Colors.white : const Color(0xFF334155),
                    ),
                    backgroundColor: const Color(0xFFF1F5F9),
                  ),
                  const SizedBox(width: 8),
                  // Verified Flats only
                  FilterChip(
                    label: const Text('Verified Flats Only'),
                    selected: state.filters.isVerifiedOnly,
                    onSelected: (_) => notifier.toggleVerifiedOnly(),
                    selectedColor: const Color(0xFF0D9488),
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: state.filters.isVerifiedOnly ? Colors.white : const Color(0xFF334155),
                    ),
                    backgroundColor: const Color(0xFFF1F5F9),
                  ),
                  const SizedBox(width: 8),
                  // Have Room vs Need Flatmate toggle
                  ActionChip(
                    label: Text(
                      state.filters.listingType == null
                          ? 'All Types'
                          : state.filters.listingType!.displayName,
                    ),
                    avatar: const Icon(Icons.swap_horiz, size: 16),
                    onPressed: () {
                      _showTypeFilterDialog(context, state.filters, notifier);
                    },
                    backgroundColor: const Color(0xFFF1F5F9),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          // Body: List view or Map View
          Expanded(
            child: state.viewMode == ListingViewMode.map
                ? MapViewScreen(
                    listings: state.listings,
                    selectedListing: state.selectedListingForMap,
                    onSelectListing: (l) => notifier.selectListingForMap(l),
                  )
                : RefreshIndicator(
                    onRefresh: () => notifier.fetchListings(refresh: true),
                    child: state.isLoading && state.listings.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : state.listings.isEmpty
                            ? _buildEmptyState()
                            : ListView.builder(
                                itemCount: state.listings.length,
                                padding: const EdgeInsets.only(top: 8, bottom: 80),
                                itemBuilder: (context, index) {
                                  final listing = state.listings[index];
                                  return ListingCard(
                                    listing: listing,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ListingDetailScreen(
                                            listingId: listing.id,
                                            initialListing: listing,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateListingScreen()),
          );
        },
        backgroundColor: const Color(0xFF6366F1),
        icon: const Icon(Icons.add_home_outlined),
        label: const Text('Post Room'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.apartment, size: 64, color: Color(0xFFCBD5E1)),
            const SizedBox(height: 16),
            const Text(
              'No Listings Found',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Try clearing some filters or post your own room to find compatible flatmates.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF64748B)),
            ),
          ],
        ),
      ),
    );
  }

  void _showTypeFilterDialog(
    BuildContext context,
    ListingFilters filters,
    ListingsNotifier notifier,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Listing Category',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListTile(
              title: const Text('Show All Listings'),
              trailing: filters.listingType == null
                  ? const Icon(Icons.check, color: Color(0xFF6366F1))
                  : null,
              onTap: () {
                notifier.updateFilters(filters.copyWith(listingType: null));
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              title: const Text('Have a Room (Room Available)'),
              trailing: filters.listingType == ListingType.haveRoom
                  ? const Icon(Icons.check, color: Color(0xFF6366F1))
                  : null,
              onTap: () {
                notifier.updateFilters(filters.copyWith(listingType: ListingType.haveRoom));
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              title: const Text('Need Flatmate (Looking Together)'),
              trailing: filters.listingType == ListingType.needFlatmate
                  ? const Icon(Icons.check, color: Color(0xFF6366F1))
                  : null,
              onTap: () {
                notifier.updateFilters(filters.copyWith(listingType: ListingType.needFlatmate));
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }
}
