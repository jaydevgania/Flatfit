import '../domain/listing_filters.dart';
import '../domain/listing_model.dart';
import '../domain/listing_type.dart';
import 'listing_data_source.dart';

abstract class ListingRepository {
  Future<List<Listing>> getListings({
    ListingFilters? filters,
    int page = 1,
    int pageSize = 20,
  });
  Future<Listing?> getListingById(String id);
  Future<List<Listing>> getMyListings(String ownerId);
  Future<Listing> createListing({
    required Listing listing,
    required List<String> photoUrls,
  });
  Future<void> updateListing(Listing listing);
  Future<void> deleteListing(String id);
  Future<void> toggleListingStatus(String id, ListingStatus newStatus);
  int calculateQualityScore(Listing listing);
}

class ListingRepositoryImpl implements ListingRepository {
  final ListingDataSource _dataSource;

  ListingRepositoryImpl({ListingDataSource? dataSource})
      : _dataSource = dataSource ?? ListingDataSource();

  @override
  Future<List<Listing>> getListings({
    ListingFilters? filters,
    int page = 1,
    int pageSize = 20,
  }) async {
    final rawList = await _dataSource.fetchListings(
      filters: filters,
      page: page,
      pageSize: pageSize,
    );
    return rawList.map((item) => Listing.fromJson(item)).toList();
  }

  @override
  Future<Listing?> getListingById(String id) async {
    final raw = await _dataSource.fetchListingById(id);
    if (raw == null) return null;
    await _dataSource.incrementViews(id);
    return Listing.fromJson(raw);
  }

  @override
  Future<List<Listing>> getMyListings(String ownerId) async {
    final rawList = await _dataSource.fetchUserListings(ownerId);
    return rawList.map((item) => Listing.fromJson(item)).toList();
  }

  @override
  Future<Listing> createListing({
    required Listing listing,
    required List<String> photoUrls,
  }) async {
    final computedQuality = calculateQualityScore(listing);
    final listingData = {
      'owner_id': listing.ownerId,
      'type': listing.type.toDbValue(),
      'title': listing.title,
      'description': listing.description,
      'rent': listing.rent,
      'deposit': listing.deposit,
      'maintenance': listing.maintenance,
      'furnishing': listing.furnishing.toDbValue(),
      'locality': listing.locality,
      'city': listing.city,
      'address': listing.address,
      'latitude': listing.latitude,
      'longitude': listing.longitude,
      'room_type': listing.roomType.name,
      'bhk_type': listing.bhkType,
      'floor_number': listing.floorNumber,
      'total_floors': listing.totalFloors,
      'availability_date': listing.availabilityDate?.toIso8601String(),
      'is_sublet': listing.isSublet,
      'is_short_stay': listing.isShortStay,
      'min_stay_months': listing.minStayMonths,
      'quality_score': computedQuality,
      'is_verified': listing.isVerified,
      'house_rules': listing.houseRules,
      'status': listing.status.toDbValue(),
    };

    final result = await _dataSource.insertListing(
      listingData,
      photoUrls,
      listing.amenities,
    );
    return Listing.fromJson(result);
  }

  @override
  Future<void> updateListing(Listing listing) async {
    final data = {
      'title': listing.title,
      'description': listing.description,
      'rent': listing.rent,
      'deposit': listing.deposit,
      'maintenance': listing.maintenance,
      'furnishing': listing.furnishing.toDbValue(),
      'locality': listing.locality,
      'address': listing.address,
      'is_sublet': listing.isSublet,
      'is_short_stay': listing.isShortStay,
      'house_rules': listing.houseRules,
      'status': listing.status.toDbValue(),
    };
    await _dataSource.updateListing(listing.id, data);
  }

  @override
  Future<void> deleteListing(String id) async {
    await _dataSource.deleteListing(id);
  }

  @override
  Future<void> toggleListingStatus(String id, ListingStatus newStatus) async {
    await _dataSource.updateListing(id, {'status': newStatus.toDbValue()});
  }

  @override
  int calculateQualityScore(Listing listing) {
    return Listing.calculateQualityScore(
      hasDescription: listing.description != null && listing.description!.length > 30,
      photoCount: listing.photos.length,
      amenityCount: listing.amenities.length,
      hasHouseRules: listing.houseRules.isNotEmpty,
      isVerified: listing.isVerified,
      hasDepositDetails: listing.deposit > 0,
    );
  }
}
