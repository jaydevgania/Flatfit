import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/furnishing_type.dart';
import '../../domain/listing_model.dart';
import '../../domain/listing_type.dart';
import '../providers/listings_provider.dart';
import '../widgets/amenity_chips.dart';
import '../widgets/listing_quality_badge.dart';

class CreateListingScreen extends ConsumerStatefulWidget {
  const CreateListingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateListingScreen> createState() =>
      _CreateListingScreenState();
}

class _CreateListingScreenState extends ConsumerState<CreateListingScreen> {
  int _currentStep = 0;

  // Form Fields
  ListingType _listingType = ListingType.haveRoom;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _localityController =
      TextEditingController(text: 'Bandra West');
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _rentController =
      TextEditingController(text: '22000');
  final TextEditingController _depositController =
      TextEditingController(text: '44000');
  final TextEditingController _maintenanceController =
      TextEditingController(text: '1500');

  FurnishingType _furnishing = FurnishingType.fullyFurnished;
  RoomType _roomType = RoomType.single;
  String _bhkType = '2BHK';
  bool _isSublet = false;
  bool _isShortStay = false;
  int _minStayMonths = 6;

  // Photos (up to 10)
  final List<String> _photos = [
    'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800',
    'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800',
  ];

  // Amenities
  final List<String> _selectedAmenities = [
    'WiFi',
    'AC',
    'Washing Machine',
    'Geyser',
    'Power Backup',
    'Furnished Kitchen',
  ];

  // House Rules
  String _quietHours = '11:00 PM - 07:00 AM';
  String _guestsPolicy = 'Friends welcome with advance notice';
  String _smokingPolicy = 'Balcony only';
  String _petPolicy = 'Cat/dog friendly';
  String _foodPolicy = 'Veg & Non-Veg allowed';

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _localityController.dispose();
    _addressController.dispose();
    _rentController.dispose();
    _depositController.dispose();
    _maintenanceController.dispose();
    super.dispose();
  }

  int _calculateQuality() {
    return Listing.calculateQualityScore(
      hasDescription: _descController.text.trim().length > 30,
      photoCount: _photos.length,
      amenityCount: _selectedAmenities.length,
      hasHouseRules: true,
      isVerified: true,
      hasDepositDetails: (double.tryParse(_depositController.text) ?? 0) > 0,
    );
  }

  void _addMockPhoto() {
    if (_photos.length >= 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum 10 photos allowed')),
      );
      return;
    }
    setState(() {
      _photos.add('https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800');
    });
  }

  Future<void> _publishListing() async {
    final rent = double.tryParse(_rentController.text) ?? 15000;
    final deposit = double.tryParse(_depositController.text) ?? 30000;
    final maintenance = double.tryParse(_maintenanceController.text) ?? 0;

    final newListing = Listing(
      id: 'listing_${DateTime.now().millisecondsSinceEpoch}',
      ownerId: 'current_user',
      type: _listingType,
      title: _titleController.text.isNotEmpty
          ? _titleController.text
          : 'Spacious room in ${_localityController.text}',
      description: _descController.text.isNotEmpty
          ? _descController.text
          : 'Cozy and bright flat with great flatmates.',
      rent: rent,
      deposit: deposit,
      maintenance: maintenance,
      furnishing: _furnishing,
      locality: _localityController.text,
      city: 'Mumbai',
      address: _addressController.text,
      roomType: _roomType,
      bhkType: _bhkType,
      isSublet: _isSublet,
      isShortStay: _isShortStay,
      minStayMonths: _minStayMonths,
      qualityScore: _calculateQuality(),
      isVerified: true,
      houseRules: {
        'quiet_hours': _quietHours,
        'guests_allowed': _guestsPolicy,
        'smoking_allowed': _smokingPolicy,
        'pets_allowed': _petPolicy,
        'food_preference': _foodPolicy,
      },
      amenities: _selectedAmenities,
      createdAt: DateTime.now(),
    );

    final repo = ref.read(listingRepositoryProvider);
    await repo.createListing(listing: newListing, photoUrls: _photos);
    ref.read(listingsProvider.notifier).fetchListings(refresh: true);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Listing published successfully! Quality Score: 95%'),
          backgroundColor: Color(0xFF0D9488),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Post a Room / Listing'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF0F172A),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: ListingQualityBadge(
              qualityScore: _calculateQuality(),
              showLabel: false,
            ),
          ),
        ],
      ),
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _currentStep,
        onStepTapped: (step) => setState(() => _currentStep = step),
        onStepContinue: () {
          if (_currentStep < 5) {
            setState(() => _currentStep++);
          } else {
            _publishListing();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep--);
          } else {
            Navigator.pop(context);
          }
        },
        controlsBuilder: (context, details) {
          final isLast = _currentStep == 5;
          return Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: details.onStepContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(isLast ? 'Publish Listing' : 'Next Step'),
                  ),
                ),
                if (_currentStep > 0) ...[
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: details.onStepCancel,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Back'),
                  ),
                ],
              ],
            ),
          );
        },
        steps: [
          // Step 1: Basic Info & Type
          Step(
            title: const Text('Basics'),
            isActive: _currentStep >= 0,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Listing Category', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                RadioListTile<ListingType>(
                  title: const Text('Have a Room (Looking for Flatmate)'),
                  value: ListingType.haveRoom,
                  groupValue: _listingType,
                  onChanged: (val) => setState(() => _listingType = val!),
                ),
                RadioListTile<ListingType>(
                  title: const Text('Need Flatmate (Finding flat together)'),
                  value: ListingType.needFlatmate,
                  groupValue: _listingType,
                  onChanged: (val) => setState(() => _listingType = val!),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Headline Title *',
                    hintText: 'e.g. Master Bedroom in Bandra West 3BHK',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _localityController,
                  decoration: const InputDecoration(
                    labelText: 'Locality *',
                    hintText: 'e.g. Bandra West, Powai, Indiranagar',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),

          // Step 2: Photos (up to 10)
          Step(
            title: const Text('Photos'),
            isActive: _currentStep >= 1,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Photos (${_photos.length}/10)', style: const TextStyle(fontWeight: FontWeight.bold)),
                    TextButton.icon(
                      onPressed: _addMockPhoto,
                      icon: const Icon(Icons.add_a_photo),
                      label: const Text('Add Photo'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _photos.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final url = entry.value;
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(url, width: 90, height: 90, fit: BoxFit.cover),
                        ),
                        if (idx == 0)
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              color: Colors.black87,
                              child: const Text(
                                'Cover',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white, fontSize: 10),
                              ),
                            ),
                          ),
                        Positioned(
                          top: 2,
                          right: 2,
                          child: GestureDetector(
                            onTap: () => setState(() => _photos.removeAt(idx)),
                            child: const CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.red,
                              child: Icon(Icons.close, size: 12, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // Step 3: Property Details
          Step(
            title: const Text('Details'),
            isActive: _currentStep >= 2,
            content: Column(
              children: [
                DropdownButtonFormField<FurnishingType>(
                  value: _furnishing,
                  decoration: const InputDecoration(labelText: 'Furnishing Type', filled: true, fillColor: Colors.white),
                  items: FurnishingType.values.map((f) {
                    return DropdownMenuItem(value: f, child: Text(f.displayName));
                  }).toList(),
                  onChanged: (val) => setState(() => _furnishing = val!),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<RoomType>(
                  value: _roomType,
                  decoration: const InputDecoration(labelText: 'Room Type', filled: true, fillColor: Colors.white),
                  items: RoomType.values.map((r) {
                    return DropdownMenuItem(value: r, child: Text(r.displayName));
                  }).toList(),
                  onChanged: (val) => setState(() => _roomType = val!),
                ),
                const SizedBox(height: 12),
                SwitchListTile.adaptive(
                  title: const Text('Sublet / Short Stay for Interns'),
                  subtitle: const Text('Allow flexible 1-3 month stays'),
                  value: _isSublet,
                  onChanged: (val) => setState(() => _isSublet = val),
                ),
              ],
            ),
          ),

          // Step 4: Rent & Deposit
          Step(
            title: const Text('Rent'),
            isActive: _currentStep >= 3,
            content: Column(
              children: [
                TextField(
                  controller: _rentController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Monthly Rent (₹) *',
                    prefixText: '₹ ',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _depositController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Refundable Security Deposit (₹)',
                    prefixText: '₹ ',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _maintenanceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Monthly Maintenance (₹)',
                    prefixText: '₹ ',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),

          // Step 5: Amenities
          Step(
            title: const Text('Amenities'),
            isActive: _currentStep >= 4,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Select Available Amenities:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                AmenityChips(
                  amenities: const [
                    'WiFi',
                    'AC',
                    'Washing Machine',
                    'Geyser',
                    'Parking',
                    'Gym',
                    'Power Backup',
                    'Lift',
                    'Security',
                    'Furnished Kitchen',
                    'Balcony',
                    'Cook Available',
                    'Maid Service',
                  ],
                  isSelectable: true,
                  selectedAmenities: _selectedAmenities,
                  onToggle: (amenity) {
                    setState(() {
                      if (_selectedAmenities.contains(amenity)) {
                        _selectedAmenities.remove(amenity);
                      } else {
                        _selectedAmenities.add(amenity);
                      }
                    });
                  },
                ),
              ],
            ),
          ),

          // Step 6: House Rules & Description
          Step(
            title: const Text('Rules'),
            isActive: _currentStep >= 5,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _descController,
                  decoration: const InputDecoration(
                    labelText: 'Describe the flat & ideal flatmate vibe *',
                    hintText: 'Work hours, cleanliness preferences, cooking habits...',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _smokingPolicy,
                  decoration: const InputDecoration(labelText: 'Smoking Policy', filled: true, fillColor: Colors.white),
                  items: const [
                    DropdownMenuItem(value: 'No smoking', child: Text('Strictly No Smoking')),
                    DropdownMenuItem(value: 'Balcony only', child: Text('Balcony Only')),
                    DropdownMenuItem(value: 'Allowed', child: Text('Smoking Allowed')),
                  ],
                  onChanged: (val) => setState(() => _smokingPolicy = val!),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _foodPolicy,
                  decoration: const InputDecoration(labelText: 'Diet / Food Policy', filled: true, fillColor: Colors.white),
                  items: const [
                    DropdownMenuItem(value: 'Vegetarian only', child: Text('Strictly Vegetarian')),
                    DropdownMenuItem(value: 'Veg & Non-Veg allowed', child: Text('Veg & Non-Veg Allowed')),
                  ],
                  onChanged: (val) => setState(() => _foodPolicy = val!),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
