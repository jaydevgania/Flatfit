import 'furnishing_type.dart';
import 'listing_type.dart';

class Listing {
  final String id;
  final String ownerId;
  final ListingType type;
  final String title;
  final double rent;
  final double deposit;
  final String locality;
  final String city;
  final double latitude;
  final double longitude;
  final FurnishingType furnishing;
  final DateTime createdAt;

  const Listing({
    required this.id,
    required this.ownerId,
    required this.type,
    required this.title,
    required this.rent,
    required this.deposit,
    required this.locality,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.furnishing,
    required this.createdAt,
  });

  static int calculateQualityScore({
    required bool hasDescription,
    required int photoCount,
    required int amenityCount,
    required bool hasHouseRules,
    required bool isVerified,
    required bool hasDepositDetails,
  }) {
    var score = 20;
    if (hasDescription) score += 15;
    score += photoCount >= 5 ? 25 : photoCount * 5;
    if (amenityCount >= 6) score += 15;
    if (hasHouseRules) score += 10;
    if (hasDepositDetails) score += 5;
    if (isVerified) score += 10;
    return score > 100 ? 100 : score;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'owner_id': ownerId,
        'type': type == ListingType.haveRoom ? 'have_room' : 'looking_for_room',
        'title': title,
        'rent': rent,
        'deposit': deposit,
        'locality': locality,
        'city': city,
        'latitude': latitude,
        'longitude': longitude,
        'furnishing': furnishing == FurnishingType.fullyFurnished
            ? 'fully_furnished'
            : furnishing == FurnishingType.semiFurnished
                ? 'semi_furnished'
                : 'unfurnished',
        'created_at': createdAt.toIso8601String(),
      };

  factory Listing.fromJson(Map<String, dynamic> json) => Listing(
        id: json['id'] as String,
        ownerId: json['owner_id'] as String,
        type: json['type'] == 'looking_for_room'
            ? ListingType.lookingForRoom
            : ListingType.haveRoom,
        title: json['title'] as String,
        rent: (json['rent'] as num).toDouble(),
        deposit: (json['deposit'] as num).toDouble(),
        locality: json['locality'] as String,
        city: json['city'] as String,
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
        furnishing: json['furnishing'] == 'fully_furnished'
            ? FurnishingType.fullyFurnished
            : json['furnishing'] == 'semi_furnished'
                ? FurnishingType.semiFurnished
                : FurnishingType.unfurnished,
        createdAt: DateTime.parse(json['created_at'] as String),
      );
}
