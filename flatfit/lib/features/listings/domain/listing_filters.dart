class ListingFilters {
  final double? minRent;
  final double? maxRent;
  final String? city;
  final bool isSubletOnly;
  final bool isVerifiedOnly;

  const ListingFilters({
    this.minRent,
    this.maxRent,
    this.city,
    this.isSubletOnly = false,
    this.isVerifiedOnly = false,
  });

  Map<String, dynamic> toQueryParams() => {
        if (minRent != null) 'min_rent': minRent,
        if (maxRent != null) 'max_rent': maxRent,
        if (city != null) 'city': city,
        if (isSubletOnly) 'is_sublet': isSubletOnly,
        if (isVerifiedOnly) 'is_verified': isVerifiedOnly,
      };
}
