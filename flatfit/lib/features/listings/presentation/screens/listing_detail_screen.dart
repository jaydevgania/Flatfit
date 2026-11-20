import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/furnishing_type.dart';
import '../../domain/listing_model.dart';
import '../providers/listings_provider.dart';
import '../widgets/amenity_chips.dart';
import '../widgets/current_flatmates_section.dart';
import '../widgets/house_rules_section.dart';
import '../widgets/listing_photo_carousel.dart';
import '../widgets/listing_quality_badge.dart';
import '../widgets/rent_badge.dart';
import '../widgets/verified_badge.dart';

class ListingDetailScreen extends ConsumerStatefulWidget {
  final String listingId;
  final Listing? initialListing;

  const ListingDetailScreen({
    Key? key,
    required this.listingId,
    this.initialListing,
  }) : super(key: key);

  @override
  ConsumerState<ListingDetailScreen> createState() =>
      _ListingDetailScreenState();
}

class _ListingDetailScreenState extends ConsumerState<ListingDetailScreen> {
  Listing? _listing;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _listing = widget.initialListing;
    if (_listing == null) {
      _loadListing();
    }
  }

  Future<void> _loadListing() async {
    setState(() => _isLoading = true);
    final repo = ref.read(listingRepositoryProvider);
    final fetched = await repo.getListingById(widget.listingId);
    if (mounted) {
      setState(() {
        _listing = fetched;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final listing = _listing;
    if (listing == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Listing not found')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // App Bar with Photo Carousel
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.black45,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.black45,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.share, color: Colors.white, size: 20),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Listing link copied to clipboard!')),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: ListingPhotoCarousel(photos: listing.photos),
            ),
          ),

          // Content body
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badges: Verified & Quality Score
                  Row(
                    children: [
                      VerifiedBadge(isVerified: listing.isVerified),
                      const SizedBox(width: 8),
                      ListingQualityBadge(qualityScore: listing.qualityScore),
                      const Spacer(),
                      Text(
                        '${listing.viewsCount} views',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Title & Location
                  Text(
                    listing.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Color(0xFF6366F1)),
                      const SizedBox(width: 4),
                      Text(
                        '${listing.address ?? listing.locality}, ${listing.city}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF475569),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Rent, Deposit & Maintenance Info
                  RentBadge(
                    rent: listing.rent,
                    deposit: listing.deposit,
                    maintenance: listing.maintenance,
                  ),
                  const SizedBox(height: 20),

                  // Property Overview Grid
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            _buildInfoTile(
                              Icons.bed_outlined,
                              'Room Type',
                              listing.roomType.displayName,
                            ),
                            _buildInfoTile(
                              Icons.apartment_outlined,
                              'BHK Configuration',
                              listing.bhkType ?? '2BHK',
                            ),
                          ],
                        ),
                        const Divider(height: 20),
                        Row(
                          children: [
                            _buildInfoTile(
                              listing.furnishing.icon,
                              'Furnishing',
                              listing.furnishing.displayName,
                            ),
                            _buildInfoTile(
                              Icons.calendar_month_outlined,
                              'Min Stay Duration',
                              '${listing.minStayMonths ?? 6} Months',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),

                  // Description
                  const Text(
                    'About this Space & Living Setup',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    listing.description ?? 'No description provided.',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF334155),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Amenities
                  const Text(
                    'Amenities & Appliances',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  AmenityChips(amenities: listing.amenities),
                  const SizedBox(height: 24),

                  // Current Flatmates
                  CurrentFlatmatesSection(flatmates: listing.currentFlatmates),
                  const SizedBox(height: 24),

                  // House Rules
                  HouseRulesSection(houseRules: listing.houseRules),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Chat opened with ${listing.locality} flatmate!'),
                        backgroundColor: const Color(0xFF6366F1),
                      ),
                    );
                  },
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: const Text('Connect & Chat'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: const Color(0xFF6366F1)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
