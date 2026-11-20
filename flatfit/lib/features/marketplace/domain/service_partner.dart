/// Supported service categories in FlatFit Marketplace.
enum ServiceCategory {
  movers,
  furnitureRental,
  cleaning,
  laundry,
  maid,
  cook,
  repairs,
  wifiSetup,
  insurance,
}

extension ServiceCategoryExtension on ServiceCategory {
  String get displayName {
    switch (this) {
      case ServiceCategory.movers:
        return 'Movers & Packers';
      case ServiceCategory.furnitureRental:
        return 'Furniture & Appliances';
      case ServiceCategory.cleaning:
        return 'Deep Cleaning';
      case ServiceCategory.laundry:
        return 'Laundry & Dry Clean';
      case ServiceCategory.maid:
        return 'Maid Matching';
      case ServiceCategory.cook:
        return 'Cook Matching';
      case ServiceCategory.repairs:
        return 'Plumber & Electrician';
      case ServiceCategory.wifiSetup:
        return 'WiFi & Gas Setup';
      case ServiceCategory.insurance:
        return 'Renters Insurance';
    }
  }

  String get iconName {
    switch (this) {
      case ServiceCategory.movers:
        return 'local_shipping';
      case ServiceCategory.furnitureRental:
        return 'chair';
      case ServiceCategory.cleaning:
        return 'cleaning_services';
      case ServiceCategory.laundry:
        return 'local_laundry_service';
      case ServiceCategory.maid:
        return 'badge';
      case ServiceCategory.cook:
        return 'restaurant';
      case ServiceCategory.repairs:
        return 'build';
      case ServiceCategory.wifiSetup:
        return 'wifi';
      case ServiceCategory.insurance:
        return 'verified_user';
    }
  }
}

/// A pricing tier or plan offered by a service partner.
class ServiceTier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String priceUnit; // e.g. "per month", "one-time", "per visit"
  final List<String> inclusions;

  const ServiceTier({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.priceUnit,
    required this.inclusions,
  });
}

/// Verified review for a service partner.
class PartnerReview {
  final String id;
  final String userName;
  final String? userPhotoUrl;
  final double rating;
  final String comment;
  final DateTime createdAt;

  const PartnerReview({
    required this.id,
    required this.userName,
    this.userPhotoUrl,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });
}

/// Entity representing a vetted third-party service provider in FlatFit.
class ServicePartner {
  final String id;
  final String name;
  final ServiceCategory category;
  final String description;
  final String city;
  final List<String> localities;
  final double rating;
  final int totalReviews;
  final String? contactPhone;
  final String? contactEmail;
  final String? website;
  final String? logoUrl;
  final bool isVerified;
  final double commissionPct; // e.g. 10.0 for 10%
  final List<ServiceTier> pricingTiers;
  final List<PartnerReview> reviews;

  const ServicePartner({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    this.city = 'Mumbai',
    this.localities = const [],
    this.rating = 4.8,
    this.totalReviews = 0,
    this.contactPhone,
    this.contactEmail,
    this.website,
    this.logoUrl,
    this.isVerified = true,
    this.commissionPct = 10.0,
    this.pricingTiers = const [],
    this.reviews = const [],
  });

  /// Starting price across all tiers.
  double get startingPrice {
    if (pricingTiers.isEmpty) return 0;
    return pricingTiers.map((t) => t.price).reduce((a, b) => a < b ? a : b);
  }
}
