import 'service_partner.dart';

/// Bundled package combining multiple services with a discounted rate.
class ServiceBundle {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final List<ServiceCategory> includedCategories;
  final List<String> highlights;
  final double originalPrice;
  final double discountedPrice;
  final double discountPercent;
  final String badgeText;
  final String? bannerImageUrl;

  const ServiceBundle({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.includedCategories,
    required this.highlights,
    required this.originalPrice,
    required this.discountedPrice,
    required this.discountPercent,
    required this.badgeText,
    this.bannerImageUrl,
  });

  double get savings => originalPrice - discountedPrice;
}

/// Pre-configured curated moving bundles for Mumbai flatmates.
class DefaultServiceBundles {
  static const List<ServiceBundle> all = [
    ServiceBundle(
      id: 'bundle_starter',
      title: 'Move-In Starter Pack',
      subtitle: 'Movers + Deep Clean + High-Speed WiFi Setup',
      description: 'Everything you need on Day 1. Movers pack and deliver your boxes, deep cleaning crew sanitizes your room and bathroom, and fiber broadband is installed before night.',
      includedCategories: [
        ServiceCategory.movers,
        ServiceCategory.cleaning,
        ServiceCategory.wifiSetup,
      ],
      highlights: [
        'Dedicated mini-truck & 2 packing professionals',
        'Hospital-grade bathroom & room deep cleaning',
        'Next-day 200 Mbps fiber WiFi installation with router',
      ],
      originalPrice: 8499,
      discountedPrice: 6999,
      discountPercent: 18,
      badgeText: 'MOST POPULAR',
    ),
    ServiceBundle(
      id: 'bundle_furnish',
      title: 'Furnish-My-Room Duo',
      subtitle: 'Queen Bed + Ortho Mattress + Study Desk + Wardrobe',
      description: 'Turn an unfurnished room into a stylish haven without buying expensive furniture. Free doorstep delivery, setup, and maintenance included.',
      includedCategories: [
        ServiceCategory.furnitureRental,
      ],
      highlights: [
        'Solid engineered wood queen bed with storage',
        '8-inch high-density orthopaedic mattress',
        'Ergonomic study desk & mesh chair',
        'Free maintenance & relocation assistance',
      ],
      originalPrice: 2499,
      discountedPrice: 1999,
      discountPercent: 20,
      badgeText: 'BEST VALUE',
    ),
    ServiceBundle(
      id: 'bundle_house_care',
      title: 'House Care Essentials',
      subtitle: 'Verified Maid + Experienced Cook Matching + Insurance',
      description: 'Take the hassle out of domestic help. Police-verified cook & maid matching with free 7-day replacement guarantee, plus ₹2 Lakh renters content insurance.',
      includedCategories: [
        ServiceCategory.maid,
        ServiceCategory.cook,
        ServiceCategory.insurance,
      ],
      highlights: [
        'Police-verified cook (breakfast + dinner trial)',
        'Vetted maid for sweeping, mopping & dusting',
        'Free replacement guarantee within 15 days',
        '₹2,00,000 personal content & gadget insurance',
      ],
      originalPrice: 4200,
      discountedPrice: 3499,
      discountPercent: 17,
      badgeText: 'PEACE OF MIND',
    ),
  ];
}
