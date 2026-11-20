import 'furnishing_type.dart';
import 'listing_type.dart';

/// Photo attached to a property listing.
class ListingPhoto {
  final String id;
  final String listingId;
  final String url;
  final int position;
  final String? caption;

  const ListingPhoto({
    required this.id,
    required this.listingId,
    required this.url,
    this.position = 1,
    this.caption,
  });

  factory ListingPhoto.fromJson(Map<String, dynamic> json) {
    return ListingPhoto(
      id: json['id'] as String? ?? '',
      listingId: json['listing_id'] as String? ?? '',
      url: json['url'] as String? ?? '',
      position: json['position'] as int? ?? 1,
      caption: json['caption'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'listing_id': listingId,
      'url': url,
      'position': position,
      'caption': caption,
    };
  }
}

/// Profile summary of a flatmate currently living in the flat (shown with consent).
class FlatmateProfile {
  final String id;
  final String fullName;
  final int age;
  final String occupation;
  final String? avatarUrl;
  final String? bio;
  final bool isVerified;

  const FlatmateProfile({
    required this.id,
    required this.fullName,
    required this.age,
    required this.occupation,
    this.avatarUrl,
    this.bio,
    this.isVerified = true,
  });

  factory FlatmateProfile.fromJson(Map<String, dynamic> json) {
    return FlatmateProfile(
      id: json['id'] as String? ?? '',
      fullName: json['full_name'] as String? ?? json['fullName'] as String? ?? 'Flatmate',
      age: json['age'] as int? ?? 25,
      occupation: json['occupation'] as String? ?? 'Software Professional',
      avatarUrl: json['avatar_url'] as String? ?? json['avatarUrl'] as String?,
      bio: json['bio'] as String?,
      isVerified: json['is_verified'] as bool? ?? json['isVerified'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'age': age,
      'occupation': occupation,
      'avatar_url': avatarUrl,
      'bio': bio,
      'is_verified': isVerified,
    };
  }
}

/// Main Listing entity for FlatFit.
class Listing {
  final String id;
  final String ownerId;
  final ListingType type;
  final String title;
  final String? description;
  final double rent;
  final double deposit;
  final double maintenance;
  final FurnishingType furnishing;
  final String locality;
  final String city;
  final String? address;
  final double? latitude;
  final double? longitude;
  final RoomType roomType;
  final String? bhkType; // '1BHK', '2BHK', '3BHK', etc.
  final int? floorNumber;
  final int? totalFloors;
  final DateTime? availabilityDate;
  final bool isSublet;
  final bool isShortStay;
  final int? minStayMonths;
  final int qualityScore; // 0 - 100
  final bool isVerified;
  final Map<String, dynamic> houseRules; // quietHours, guests, smoking, pets, food
  final List<FlatmateProfile> currentFlatmates;
  final List<String> amenities;
  final List<ListingPhoto> photos;
  final int viewsCount;
  final ListingStatus status;
  final DateTime createdAt;

  const Listing({
    required this.id,
    required this.ownerId,
    required this.type,
    required this.title,
    this.description,
    required this.rent,
    this.deposit = 0,
    this.maintenance = 0,
    this.furnishing = FurnishingType.semiFurnished,
    required this.locality,
    this.city = 'Mumbai',
    this.address,
    this.latitude,
    this.longitude,
    this.roomType = RoomType.single,
    this.bhkType = '2BHK',
    this.floorNumber,
    this.totalFloors,
    this.availabilityDate,
    this.isSublet = false,
    this.isShortStay = false,
    this.minStayMonths = 6,
    this.qualityScore = 80,
    this.isVerified = false,
    this.houseRules = const {},
    this.currentFlatmates = const [],
    this.amenities = const [],
    this.photos = const [],
    this.viewsCount = 0,
    this.status = ListingStatus.active,
    required this.createdAt,
  });

  /// Cover photo URL (first photo or placeholder)
  String get coverPhotoUrl {
    if (photos.isNotEmpty) {
      return photos.first.url;
    }
    return 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800';
  }

  /// Calculates the listing quality score:
  /// completeness (description, amenities, rules) x photo count x verification boost
  static int calculateQualityScore({
    required bool hasDescription,
    required int photoCount,
    required int amenityCount,
    required bool hasHouseRules,
    required bool isVerified,
    required bool hasDepositDetails,
  }) {
    int score = 20; // Base score

    if (hasDescription) score += 15;
    if (photoCount >= 5) {
      score += 25;
    } else if (photoCount >= 2) {
      score += 15;
    } else if (photoCount >= 1) {
      score += 5;
    }

    if (amenityCount >= 6) {
      score += 15;
    } else if (amenityCount >= 3) {
      score += 10;
    }

    if (hasHouseRules) score += 10;
    if (hasDepositDetails) score += 5;
    if (isVerified) score += 10;

    return score.clamp(0, 100);
  }

  factory Listing.fromJson(Map<String, dynamic> json) {
    // Parse photos
    final rawPhotos = json['listing_photos'] as List<dynamic>? ??
        json['photos'] as List<dynamic>? ??
        [];
    final photosList = rawPhotos
        .map((p) => ListingPhoto.fromJson(p as Map<String, dynamic>))
        .toList();

    // Parse amenities
    final rawAmenities = json['listing_amenities'] as List<dynamic>? ??
        json['amenities'] as List<dynamic>? ??
        [];
    final amenitiesList = rawAmenities.map((a) {
      if (a is Map) return a['amenity'] as String? ?? '';
      return a.toString();
    }).where((s) => s.isNotEmpty).toList();

    // Parse flatmates
    final rawFlatmates = json['current_flatmates'] as List<dynamic>? ?? [];
    final flatmatesList = rawFlatmates
        .map((f) => FlatmateProfile.fromJson(f as Map<String, dynamic>))
        .toList();

    return Listing(
      id: json['id'] as String? ?? '',
      ownerId: json['owner_id'] as String? ?? json['ownerId'] as String? ?? '',
      type: ListingType.fromString(json['type']?.toString() ?? 'have_room'),
      title: json['title'] as String? ?? 'Flatmate Vacancy',
      description: json['description'] as String?,
      rent: (json['rent'] as num?)?.toDouble() ?? 15000.0,
      deposit: (json['deposit'] as num?)?.toDouble() ?? 30000.0,
      maintenance: (json['maintenance'] as num?)?.toDouble() ?? 0.0,
      furnishing: FurnishingType.fromString(json['furnishing']?.toString() ?? 'semi_furnished'),
      locality: json['locality'] as String? ?? 'Bandra',
      city: json['city'] as String? ?? 'Mumbai',
      address: json['address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      roomType: RoomType.fromString(json['room_type']?.toString() ?? 'single'),
      bhkType: json['bhk_type'] as String? ?? '2BHK',
      floorNumber: json['floor_number'] as int?,
      totalFloors: json['total_floors'] as int?,
      availabilityDate: json['availability_date'] != null
          ? DateTime.tryParse(json['availability_date'].toString())
          : null,
      isSublet: json['is_sublet'] as bool? ?? false,
      isShortStay: json['is_short_stay'] as bool? ?? false,
      minStayMonths: json['min_stay_months'] as int? ?? 6,
      qualityScore: json['quality_score'] as int? ?? 85,
      isVerified: json['is_verified'] as bool? ?? false,
      houseRules: json['house_rules'] != null && json['house_rules'] is Map
          ? Map<String, dynamic>.from(json['house_rules'] as Map)
          : {},
      currentFlatmates: flatmatesList,
      amenities: amenitiesList,
      photos: photosList,
      viewsCount: json['views_count'] as int? ?? 0,
      status: ListingStatus.fromString(json['status']?.toString() ?? 'active'),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner_id': ownerId,
      'type': type.toDbValue(),
      'title': title,
      'description': description,
      'rent': rent,
      'deposit': deposit,
      'maintenance': maintenance,
      'furnishing': furnishing.toDbValue(),
      'locality': locality,
      'city': city,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'room_type': roomType.name,
      'bhk_type': bhkType,
      'floor_number': floorNumber,
      'total_floors': totalFloors,
      'availability_date': availabilityDate?.toIso8601String(),
      'is_sublet': isSublet,
      'is_short_stay': isShortStay,
      'min_stay_months': minStayMonths,
      'quality_score': qualityScore,
      'is_verified': isVerified,
      'house_rules': houseRules,
      'current_flatmates': currentFlatmates.map((f) => f.toJson()).toList(),
      'amenities': amenities,
      'views_count': viewsCount,
      'status': status.toDbValue(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  Listing copyWith({
    String? id,
    String? ownerId,
    ListingType? type,
    String? title,
    String? description,
    double? rent,
    double? deposit,
    double? maintenance,
    FurnishingType? furnishing,
    String? locality,
    String? city,
    String? address,
    double? latitude,
    double? longitude,
    RoomType? roomType,
    String? bhkType,
    int? floorNumber,
    int? totalFloors,
    DateTime? availabilityDate,
    bool? isSublet,
    bool? isShortStay,
    int? minStayMonths,
    int? qualityScore,
    bool? isVerified,
    Map<String, dynamic>? houseRules,
    List<FlatmateProfile>? currentFlatmates,
    List<String>? amenities,
    List<ListingPhoto>? photos,
    int? viewsCount,
    ListingStatus? status,
    DateTime? createdAt,
  }) {
    return Listing(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      rent: rent ?? this.rent,
      deposit: deposit ?? this.deposit,
      maintenance: maintenance ?? this.maintenance,
      furnishing: furnishing ?? this.furnishing,
      locality: locality ?? this.locality,
      city: city ?? this.city,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      roomType: roomType ?? this.roomType,
      bhkType: bhkType ?? this.bhkType,
      floorNumber: floorNumber ?? this.floorNumber,
      totalFloors: totalFloors ?? this.totalFloors,
      availabilityDate: availabilityDate ?? this.availabilityDate,
      isSublet: isSublet ?? this.isSublet,
      isShortStay: isShortStay ?? this.isShortStay,
      minStayMonths: minStayMonths ?? this.minStayMonths,
      qualityScore: qualityScore ?? this.qualityScore,
      isVerified: isVerified ?? this.isVerified,
      houseRules: houseRules ?? this.houseRules,
      currentFlatmates: currentFlatmates ?? this.currentFlatmates,
      amenities: amenities ?? this.amenities,
      photos: photos ?? this.photos,
      viewsCount: viewsCount ?? this.viewsCount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
