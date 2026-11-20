import 'furnishing_type.dart';
import 'listing_type.dart';

/// Filters model for searching flatmate listings in FlatFit.
class ListingFilters {
  final double? minRent;
  final double? maxRent;
  final List<String> localities;
  final String city;
  final ListingType? listingType;
  final List<FurnishingType> furnishingTypes;
  final List<RoomType> roomTypes;
  final bool isSubletOnly;
  final bool isShortStayOnly;
  final bool isVerifiedOnly;
  final String? preferredGender; // 'any', 'male', 'female'
  final int? minQualityScore;
  final DateTime? availableBefore;

  const ListingFilters({
    this.minRent,
    this.maxRent,
    this.localities = const [],
    this.city = 'Mumbai',
    this.listingType,
    this.furnishingTypes = const [],
    this.roomTypes = const [],
    this.isSubletOnly = false,
    this.isShortStayOnly = false,
    this.isVerifiedOnly = false,
    this.preferredGender,
    this.minQualityScore,
    this.availableBefore,
  });

  bool get hasActiveFilters {
    return minRent != null ||
        maxRent != null ||
        localities.isNotEmpty ||
        listingType != null ||
        furnishingTypes.isNotEmpty ||
        roomTypes.isNotEmpty ||
        isSubletOnly ||
        isShortStayOnly ||
        isVerifiedOnly ||
        preferredGender != null ||
        minQualityScore != null;
  }

  ListingFilters copyWith({
    double? minRent,
    double? maxRent,
    List<String>? localities,
    String? city,
    ListingType? listingType,
    List<FurnishingType>? furnishingTypes,
    List<RoomType>? roomTypes,
    bool? isSubletOnly,
    bool? isShortStayOnly,
    bool? isVerifiedOnly,
    String? preferredGender,
    int? minQualityScore,
    DateTime? availableBefore,
  }) {
    return ListingFilters(
      minRent: minRent ?? this.minRent,
      maxRent: maxRent ?? this.maxRent,
      localities: localities ?? this.localities,
      city: city ?? this.city,
      listingType: listingType ?? this.listingType,
      furnishingTypes: furnishingTypes ?? this.furnishingTypes,
      roomTypes: roomTypes ?? this.roomTypes,
      isSubletOnly: isSubletOnly ?? this.isSubletOnly,
      isShortStayOnly: isShortStayOnly ?? this.isShortStayOnly,
      isVerifiedOnly: isVerifiedOnly ?? this.isVerifiedOnly,
      preferredGender: preferredGender ?? this.preferredGender,
      minQualityScore: minQualityScore ?? this.minQualityScore,
      availableBefore: availableBefore ?? this.availableBefore,
    );
  }

  ListingFilters reset() {
    return const ListingFilters(city: 'Mumbai');
  }

  Map<String, dynamic> toQueryParams() {
    final Map<String, dynamic> params = {};
    if (minRent != null) params['min_rent'] = minRent;
    if (maxRent != null) params['max_rent'] = maxRent;
    if (localities.isNotEmpty) params['localities'] = localities;
    if (city.isNotEmpty) params['city'] = city;
    if (listingType != null) params['type'] = listingType!.toDbValue();
    if (isSubletOnly) params['is_sublet'] = true;
    if (isShortStayOnly) params['is_short_stay'] = true;
    if (isVerifiedOnly) params['is_verified'] = true;
    return params;
  }
}
