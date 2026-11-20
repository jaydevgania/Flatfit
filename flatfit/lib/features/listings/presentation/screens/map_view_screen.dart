import 'package:flutter/material.dart';
import '../../domain/listing_model.dart';
import '../widgets/listing_card.dart';
import 'listing_detail_screen.dart';

class MapViewScreen extends StatefulWidget {
  final List<Listing> listings;
  final Listing? selectedListing;
  final Function(Listing? listing) onSelectListing;

  const MapViewScreen({
    Key? key,
    required this.listings,
    this.selectedListing,
    required this.onSelectListing,
  }) : super(key: key);

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  Listing? _activeListing;

  @override
  void initState() {
    super.initState();
    _activeListing = widget.selectedListing ?? (widget.listings.isNotEmpty ? widget.listings.first : null);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Simulated Interactive Map Canvas (Mumbai Region)
        Container(
          color: const Color(0xFFE2E8F0),
          child: Stack(
            children: [
              // Map background grid illustration
              Positioned.fill(
                child: CustomPaint(
                  painter: MapGridPainter(),
                ),
              ),

              // Locality labels
              const Positioned(
                top: 80,
                left: 60,
                child: Text(
                  'BANDRA WEST',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF94A3B8),
                    letterSpacing: 2,
                  ),
                ),
              ),
              const Positioned(
                top: 190,
                right: 70,
                child: Text(
                  'POWAI / BKC',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF94A3B8),
                    letterSpacing: 2,
                  ),
                ),
              ),
              const Positioned(
                bottom: 240,
                left: 120,
                child: Text(
                  'ANDHERI WEST',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF94A3B8),
                    letterSpacing: 2,
                  ),
                ),
              ),

              // Interactive Listing Markers on Map
              ...widget.listings.asMap().entries.map((entry) {
                final idx = entry.key;
                final listing = entry.value;
                final isSelected = _activeListing?.id == listing.id;

                // Position markers dynamically
                final topPositions = [120.0, 220.0, 310.0, 160.0];
                final leftPositions = [90.0, 210.0, 140.0, 250.0];

                final top = topPositions[idx % topPositions.length];
                final left = leftPositions[idx % leftPositions.length];

                return Positioned(
                  top: top,
                  left: left,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _activeListing = listing;
                      });
                      widget.onSelectListing(listing);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF6366F1) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? Colors.white : const Color(0xFF6366F1),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.home,
                            size: 14,
                            color: isSelected ? Colors.white : const Color(0xFF6366F1),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '₹${(listing.rent / 1000).toStringAsFixed(0)}k',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),

        // Selected Listing Floating Card at Bottom
        if (_activeListing != null)
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: ListingCard(
              listing: _activeListing!,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ListingDetailScreen(
                      listingId: _activeListing!.id,
                      initialListing: _activeListing,
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

class MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..strokeWidth = 1;

    // Draw map road grids
    for (double i = 0; i < size.width; i += 60) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 60) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }

    // Draw main arterial road
    final roadPaint = Paint()
      ..color = const Color(0xFF94A3B8).withOpacity(0.4)
      ..strokeWidth = 8;
    canvas.drawLine(Offset(0, size.height * 0.3), Offset(size.width, size.height * 0.7), roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
