/// Package details for purchasing a Verified Listing Badge for a property.
class VerifiedListingPackage {
  final double fee; // ₹299
  final String title;
  final String subtitle;
  final List<String> benefits;
  final int boostedPlacementDays;

  const VerifiedListingPackage({
    this.fee = 299.0,
    this.title = 'FlatFit Verified Listing Badge',
    this.subtitle = 'Get 4.2x more tenant inquiries and fast-track your flatmate search',
    this.benefits = const [
      'In-person or live video verification of property and room',
      'Official Green Verified Property Badge on listing card',
      'Top-of-feed pinned placement across your locality for 14 days',
      'Spam & fraud protection shield',
      '100% money-back guarantee if you don\'t find a match in 14 days',
    ],
    this.boostedPlacementDays = 14,
  });
}

/// A purchased verification request for a listing.
class VerifiedListingPurchase {
  final String id;
  final String listingId;
  final String ownerId;
  final double amountPaid;
  final String paymentId;
  final DateTime purchasedAt;
  final bool isAuditCompleted;

  const VerifiedListingPurchase({
    required this.id,
    required this.listingId,
    required this.ownerId,
    required this.amountPaid,
    required this.paymentId,
    required this.purchasedAt,
    this.isAuditCompleted = false,
  });
}
