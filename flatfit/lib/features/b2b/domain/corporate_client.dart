/// Corporate subscription tier.
enum CorporatePlan {
  basic,
  premium,
  enterprise,
}

/// A registered corporate client utilizing FlatFit for employee relocation.
class CorporateAccount {
  final String id;
  final String companyName;
  final String contactEmail;
  final String? contactPhone;
  final CorporatePlan plan;
  final int employeeCount;
  final int maxEmployees;
  final List<String> allowedEmailDomains; // e.g. ['@google.com']
  final bool isActive;
  final DateTime createdAt;

  const CorporateAccount({
    required this.id,
    required this.companyName,
    required this.contactEmail,
    this.contactPhone,
    this.plan = CorporatePlan.basic,
    this.employeeCount = 0,
    this.maxEmployees = 250,
    this.allowedEmailDomains = const [],
    this.isActive = true,
    required this.createdAt,
  });

  /// Check whether an employee email belongs to this corporate account.
  bool isDomainAllowed(String email) {
    final lower = email.trim().toLowerCase();
    return allowedEmailDomains.any((d) => lower.endsWith(d.toLowerCase()));
  }
}

/// Pre-populated seed corporate partner stubs.
class MockCorporateData {
  static final List<CorporateAccount> accounts = [
    CorporateAccount(
      id: 'corp_goog',
      companyName: 'Google India (BKC Hub)',
      contactEmail: 'relocations-india@google.com',
      plan: CorporatePlan.enterprise,
      employeeCount: 420,
      maxEmployees: 1000,
      allowedEmailDomains: ['@google.com'],
      createdAt: DateTime.now().subtract(const Duration(days: 180)),
    ),
    CorporateAccount(
      id: 'corp_amzn',
      companyName: 'Amazon Web Services (BKC)',
      contactEmail: 'hr-relocation@amazon.com',
      plan: CorporatePlan.enterprise,
      employeeCount: 310,
      maxEmployees: 800,
      allowedEmailDomains: ['@amazon.com'],
      createdAt: DateTime.now().subtract(const Duration(days: 120)),
    ),
  ];
}
