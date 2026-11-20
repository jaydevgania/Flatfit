/// Type of managed residential housing operator.
enum OperatorType {
  pg,
  coliving,
}

/// An operator managing multiple properties or paying-guest accommodations.
class OperatorAccount {
  final String id;
  final String name;
  final OperatorType type;
  final String contactEmail;
  final String contactPhone;
  final int propertiesCount;
  final List<String> cities;
  final double commissionPct; // standard 5.0% for managed operators
  final bool isVerified;
  final bool isActive;
  final DateTime createdAt;

  const OperatorAccount({
    required this.id,
    required this.name,
    required this.type,
    required this.contactEmail,
    required this.contactPhone,
    required this.propertiesCount,
    this.cities = const ['Mumbai'],
    this.commissionPct = 5.0,
    this.isVerified = true,
    this.isActive = true,
    required this.createdAt,
  });
}

/// Webhook event payload for B2B inventory synchronization.
class OperatorInventorySyncEvent {
  final String operatorId;
  final String propertyId;
  final String roomNumber;
  final int totalBeds;
  final int availableBeds;
  final double monthlyRent;
  final DateTime updatedAt;

  const OperatorInventorySyncEvent({
    required this.operatorId,
    required this.propertyId,
    required this.roomNumber,
    required this.totalBeds,
    required this.availableBeds,
    required this.monthlyRent,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'operator_id': operatorId,
        'property_id': propertyId,
        'room_number': roomNumber,
        'total_beds': totalBeds,
        'available_beds': availableBeds,
        'monthly_rent': monthlyRent,
        'updated_at': updatedAt.toIso8601String(),
      };
}

/// Seed list of top PG / co-living operator stubs.
class MockOperatorData {
  static final List<OperatorAccount> accounts = [
    OperatorAccount(
      id: 'op_zolo_mumbai',
      name: 'Zolo Stays Living Spaces',
      type: OperatorType.coliving,
      contactEmail: 'partnerships@zolostays.com',
      contactPhone: '+91 80 4022 1234',
      propertiesCount: 24,
      cities: ['Mumbai', 'Navi Mumbai', 'Thane'],
      commissionPct: 5.0,
      createdAt: DateTime.now().subtract(const Duration(days: 300)),
    ),
    OperatorAccount(
      id: 'op_stanza_mumbai',
      name: 'Stanza Living Mumbai Hub',
      type: OperatorType.coliving,
      contactEmail: 'connect@stanzaliving.com',
      contactPhone: '+91 11 4112 5678',
      propertiesCount: 18,
      cities: ['Mumbai'],
      commissionPct: 5.0,
      createdAt: DateTime.now().subtract(const Duration(days: 210)),
    ),
  ];
}
