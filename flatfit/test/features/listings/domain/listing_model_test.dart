import 'package:flutter_test/flutter_test.dart';
import '../../../../flatfit/lib/features/listings/domain/furnishing_type.dart';
import '../../../../flatfit/lib/features/listings/domain/listing_filters.dart';
import '../../../../flatfit/lib/features/listings/domain/listing_model.dart';
import '../../../../flatfit/lib/features/listings/domain/listing_type.dart';

void main() {
  group('Listing Domain and Quality Score Tests', () {
    test('Listing Quality Score calculation formula', () {
      // Base (20) + desc (15) + 5 photos (25) + 6 amenities (15) + house rules (10) + deposit (5) + verified (10) = 100
      final perfectScore = Listing.calculateQualityScore(
        hasDescription: true,
        photoCount: 5,
        amenityCount: 7,
        hasHouseRules: true,
        isVerified: true,
        hasDepositDetails: true,
      );
      expect(perfectScore, 100);

      // Incomplete listing
      final lowScore = Listing.calculateQualityScore(
        hasDescription: false,
        photoCount: 0,
        amenityCount: 1,
        hasHouseRules: false,
        isVerified: false,
        hasDepositDetails: false,
      );
      expect(lowScore, 20); // base score only
    });

    test('Listing json serialization with PostGIS compatibility', () {
      final listing = Listing(
        id: 'list_123',
        ownerId: 'owner_99',
        type: ListingType.haveRoom,
        title: 'Bandra West 2BHK Room',
        rent: 25000,
        deposit: 50000,
        locality: 'Bandra West',
        city: 'Mumbai',
        latitude: 19.0596,
        longitude: 72.8295,
        furnishing: FurnishingType.fullyFurnished,
        createdAt: DateTime.now(),
      );

      final json = listing.toJson();
      expect(json['id'], 'list_123');
      expect(json['type'], 'have_room');
      expect(json['rent'], 25000.0);
      expect(json['furnishing'], 'fully_furnished');

      final deserialized = Listing.fromJson(json);
      expect(deserialized.id, 'list_123');
      expect(deserialized.type, ListingType.haveRoom);
      expect(deserialized.rent, 25000.0);
      expect(deserialized.furnishing, FurnishingType.fullyFurnished);
    });

    test('ListingFilters query params generation', () {
      const filters = ListingFilters(
        minRent: 15000,
        maxRent: 35000,
        city: 'Mumbai',
        isSubletOnly: true,
        isVerifiedOnly: true,
      );

      final params = filters.toQueryParams();
      expect(params['min_rent'], 15000.0);
      expect(params['max_rent'], 35000.0);
      expect(params['city'], 'Mumbai');
      expect(params['is_sublet'], true);
      expect(params['is_verified'], true);
    });
  });
}
