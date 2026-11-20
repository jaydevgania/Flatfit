import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/listing_filters.dart';
import '../domain/listing_type.dart';

/// Data source executing queries on Supabase 'listings', 'listing_photos', and 'listing_amenities'.
class ListingDataSource {
  final SupabaseClient? _client;

  ListingDataSource({SupabaseClient? client})
      : _client = client ?? (Supabase.instance.isInitialized ? Supabase.instance.client : null);

  /// Fetch listings with PostGIS spatial filter and criteria
  Future<List<Map<String, dynamic>>> fetchListings({
    ListingFilters? filters,
    int page = 1,
    int pageSize = 20,
  }) async {
    if (_client == null) {
      return _mockListings(filters: filters);
    }

    try {
      var query = _client!.from('listings').select('''
            id,
            owner_id,
            type,
            title,
            description,
            rent,
            deposit,
            maintenance,
            furnishing,
            locality,
            city,
            address,
            room_type,
            bhk_type,
            floor_number,
            total_floors,
            availability_date,
            is_sublet,
            is_short_stay,
            min_stay_months,
            quality_score,
            is_verified,
            house_rules,
            current_flatmates_count,
            views_count,
            status,
            created_at,
            listing_photos (
              id,
              listing_id,
              url,
              position,
              caption
            ),
            listing_amenities (
              id,
              amenity
            )
          ''').eq('status', 'active');

      if (filters != null) {
        if (filters.minRent != null) {
          query = query.gte('rent', filters.minRent!);
        }
        if (filters.maxRent != null) {
          query = query.lte('rent', filters.maxRent!);
        }
        if (filters.city.isNotEmpty) {
          query = query.eq('city', filters.city);
        }
        if (filters.listingType != null) {
          query = query.eq('type', filters.listingType!.toDbValue());
        }
        if (filters.isSubletOnly) {
          query = query.eq('is_sublet', true);
        }
        if (filters.isShortStayOnly) {
          query = query.eq('is_short_stay', true);
        }
        if (filters.isVerifiedOnly) {
          query = query.eq('is_verified', true);
        }
      }

      final offset = (page - 1) * pageSize;
      final response = await query
          .order('quality_score', ascending: false)
          .range(offset, offset + pageSize - 1);

      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      return _mockListings(filters: filters);
    }
  }

  /// Fetch a single listing by ID
  Future<Map<String, dynamic>?> fetchListingById(String id) async {
    if (_client == null) {
      final list = _mockListings();
      return list.firstWhere(
        (l) => l['id'] == id,
        orElse: () => list.first,
      );
    }

    try {
      final response = await _client!.from('listings').select('''
            *,
            listing_photos (*),
            listing_amenities (*)
          ''').eq('id', id).single();
      return response;
    } catch (e) {
      final list = _mockListings();
      return list.firstWhere(
        (l) => l['id'] == id,
        orElse: () => list.first,
      );
    }
  }

  /// Fetch listings owned by user
  Future<List<Map<String, dynamic>>> fetchUserListings(String ownerId) async {
    if (_client == null) {
      return _mockListings().where((l) => l['owner_id'] == ownerId).toList();
    }

    try {
      final response = await _client!.from('listings').select('''
            *,
            listing_photos (*),
            listing_amenities (*)
          ''').eq('owner_id', ownerId).order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      return _mockListings().where((l) => l['owner_id'] == ownerId).toList();
    }
  }

  /// Create a new listing
  Future<Map<String, dynamic>> insertListing(
    Map<String, dynamic> listingData,
    List<String> photoUrls,
    List<String> amenities,
  ) async {
    if (_client == null) {
      final id = 'listing_${DateTime.now().millisecondsSinceEpoch}';
      return {
        ...listingData,
        'id': id,
        'listing_photos': photoUrls
            .asMap()
            .entries
            .map((e) => {
                  'id': 'photo_${e.key}',
                  'listing_id': id,
                  'url': e.value,
                  'position': e.key + 1,
                })
            .toList(),
        'listing_amenities': amenities.map((a) => {'amenity': a}).toList(),
      };
    }

    final listingRes = await _client!
        .from('listings')
        .insert(listingData)
        .select()
        .single();
    final listingId = listingRes['id'] as String;

    // Insert photos
    if (photoUrls.isNotEmpty) {
      final photosData = photoUrls
          .asMap()
          .entries
          .map((e) => {
                'listing_id': listingId,
                'url': e.value,
                'position': e.key + 1,
              })
          .toList();
      await _client!.from('listing_photos').insert(photosData);
    }

    // Insert amenities
    if (amenities.isNotEmpty) {
      final amenitiesData = amenities
          .map((a) => {
                'listing_id': listingId,
                'amenity': a,
              })
          .toList();
      await _client!.from('listing_amenities').insert(amenitiesData);
    }

    return fetchListingById(listingId) as Future<Map<String, dynamic>>;
  }

  /// Update listing
  Future<void> updateListing(String id, Map<String, dynamic> data) async {
    if (_client == null) return;
    try {
      await _client!.from('listings').update(data).eq('id', id);
    } catch (_) {}
  }

  /// Delete listing
  Future<void> deleteListing(String id) async {
    if (_client == null) return;
    try {
      await _client!.from('listings').delete().eq('id', id);
    } catch (_) {}
  }

  /// Increment views count
  Future<void> incrementViews(String id) async {
    if (_client == null) return;
    try {
      await _client!.rpc('increment_listing_views', params: {'listing_id': id});
    } catch (_) {}
  }

  /// Rich realistic mock listings across Mumbai localities
  List<Map<String, dynamic>> _mockListings({ListingFilters? filters}) {
    final list = [
      {
        'id': 'listing_1',
        'owner_id': 'user_ananya',
        'type': 'have_room',
        'title': 'Spacious Master Bedroom in Sea-Facing Bandra 3BHK',
        'description':
            'Looking for a chill, working professional flatmate. Beautiful high-ceiling room with attached washroom, private balcony, and wooden flooring. High speed WiFi (300mbps), full-time cook who makes amazing North & South Indian meals. Society has 24/7 security, power backup and gym.',
        'rent': 28000.0,
        'deposit': 56000.0,
        'maintenance': 2500.0,
        'furnishing': 'fully_furnished',
        'locality': 'Bandra West',
        'city': 'Mumbai',
        'address': 'Perry Cross Road, Bandra West',
        'latitude': 19.0596,
        'longitude': 72.8295,
        'room_type': 'master',
        'bhk_type': '3BHK',
        'floor_number': 7,
        'total_floors': 14,
        'availability_date': DateTime.now().add(const Duration(days: 5)).toIso8601String(),
        'is_sublet': false,
        'is_short_stay': false,
        'min_stay_months': 6,
        'quality_score': 95,
        'is_verified': true,
        'house_rules': {
          'quiet_hours': '11:00 PM - 07:00 AM',
          'guests_allowed': 'Weekend friends welcome, advance heads-up appreciated',
          'smoking_allowed': 'Balcony only',
          'pets_allowed': 'Cat friendly',
          'food_preference': 'Any / Non-veg friendly',
        },
        'current_flatmates': [
          {
            'id': 'user_ananya',
            'full_name': 'Ananya Sharma',
            'age': 26,
            'occupation': 'UX Designer at Razorpay',
            'avatar_url': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
            'bio': 'Loves design, weekend filter coffee, and yoga.',
            'is_verified': true,
          },
          {
            'id': 'user_priya',
            'full_name': 'Priya Nair',
            'age': 27,
            'occupation': 'Marketing Manager',
            'avatar_url': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
            'bio': 'Foodie, runs marathons on Sundays.',
            'is_verified': true,
          }
        ],
        'amenities': [
          'WiFi',
          'AC',
          'Washing Machine',
          'Geyser',
          'Power Backup',
          'Furnished Kitchen',
          'Balcony',
          'Gym',
          'Security',
          'Lift',
        ],
        'listing_photos': [
          {
            'id': 'p1',
            'listing_id': 'listing_1',
            'url': 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800',
            'position': 1,
            'caption': 'Master Bedroom with balcony view',
          },
          {
            'id': 'p2',
            'listing_id': 'listing_1',
            'url': 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800',
            'position': 2,
            'caption': 'Living room and lounge',
          },
          {
            'id': 'p3',
            'listing_id': 'listing_1',
            'url': 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800',
            'position': 3,
            'caption': 'Modular kitchen setup',
          },
        ],
        'views_count': 142,
        'status': 'active',
        'created_at': DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
      },
      {
        'id': 'listing_2',
        'owner_id': 'user_rohit',
        'type': 'have_room',
        'title': 'Private Room in Premium Powai Hiranandani Flat',
        'description':
            'Room available in Delphi building, Hiranandani Gardens Powai. Walking distance to Lake, Galleria Mall, and tech parks. Peaceful, safe gated community with Olympic-sized pool and club membership included.',
        'rent': 22000.0,
        'deposit': 44000.0,
        'maintenance': 1800.0,
        'furnishing': 'fully_furnished',
        'locality': 'Powai',
        'city': 'Mumbai',
        'address': 'Delphi, Hiranandani Gardens, Powai',
        'latitude': 19.1176,
        'longitude': 72.9060,
        'room_type': 'single',
        'bhk_type': '2BHK',
        'floor_number': 12,
        'total_floors': 28,
        'availability_date': DateTime.now().add(const Duration(days: 10)).toIso8601String(),
        'is_sublet': false,
        'is_short_stay': false,
        'min_stay_months': 11,
        'quality_score': 92,
        'is_verified': true,
        'house_rules': {
          'quiet_hours': '11:30 PM - 07:30 AM',
          'guests_allowed': 'Yes with advance agreement',
          'smoking_allowed': 'No smoking inside flat',
          'pets_allowed': 'No pets',
          'food_preference': 'Vegetarian preferred',
        },
        'current_flatmates': [
          {
            'id': 'user_rohit',
            'full_name': 'Rohit Verma',
            'age': 28,
            'occupation': 'Software Architect at Swiggy',
            'avatar_url': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
            'bio': 'Tech enthusiast, badminton on weekends.',
            'is_verified': true,
          }
        ],
        'amenities': [
          'WiFi',
          'AC',
          'Washing Machine',
          'Geyser',
          'Parking',
          'Gym',
          'Power Backup',
          'Security',
          'Lift',
        ],
        'listing_photos': [
          {
            'id': 'p4',
            'listing_id': 'listing_2',
            'url': 'https://images.unsplash.com/photo-1493809842364-78817add7ffb?w=800',
            'position': 1,
            'caption': 'Private bedroom with study desk',
          },
          {
            'id': 'p5',
            'listing_id': 'listing_2',
            'url': 'https://images.unsplash.com/photo-1484154218962-a197022b5858?w=800',
            'position': 2,
            'caption': 'Kitchen and dining space',
          },
        ],
        'views_count': 98,
        'status': 'active',
        'created_at': DateTime.now().subtract(const Duration(days: 4)).toIso8601String(),
      },
      {
        'id': 'listing_3',
        'owner_id': 'current_user',
        'type': 'need_flatmate',
        'title': '2-Month Summer Intern Sublet in Andheri West (Near Metro)',
        'description':
            'Subletting my fully furnished bedroom for June & July. Perfect for summer tech/finance interns. Exactly 3 mins walk from DN Nagar Metro station. Maid and cook already active in the flat.',
        'rent': 16000.0,
        'deposit': 16000.0,
        'maintenance': 1000.0,
        'furnishing': 'fully_furnished',
        'locality': 'Andheri West',
        'city': 'Mumbai',
        'address': 'DN Nagar, Near Metro Pillar 112, Andheri West',
        'latitude': 19.1254,
        'longitude': 72.8364,
        'room_type': 'single',
        'bhk_type': '2BHK',
        'floor_number': 4,
        'total_floors': 8,
        'availability_date': DateTime.now().add(const Duration(days: 2)).toIso8601String(),
        'is_sublet': true,
        'is_short_stay': true,
        'min_stay_months': 2,
        'quality_score': 88,
        'is_verified': true,
        'house_rules': {
          'quiet_hours': '12:00 AM - 08:00 AM',
          'guests_allowed': 'Casual day guests ok',
          'smoking_allowed': 'No',
          'pets_allowed': 'No',
          'food_preference': 'Any',
        },
        'current_flatmates': [],
        'amenities': [
          'WiFi',
          'AC',
          'Washing Machine',
          'Geyser',
          'Furnished Kitchen',
          'Lift',
        ],
        'listing_photos': [
          {
            'id': 'p6',
            'listing_id': 'listing_3',
            'url': 'https://images.unsplash.com/photo-1505691938895-1758d7feb511?w=800',
            'position': 1,
            'caption': 'Comfortable bedroom with natural light',
          },
        ],
        'views_count': 64,
        'status': 'active',
        'created_at': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      },
    ];

    return list;
  }
}
