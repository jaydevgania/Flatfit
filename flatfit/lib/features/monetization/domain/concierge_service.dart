/// Status of a bespoke matching concierge request.
enum ConciergeStatus {
  submitted,
  managerAssigned,
  matchingInProgress,
  interviewsScheduled,
  matchedSuccessfully,
}

/// Details of human-assisted matching concierge service.
class ConciergeServicePackage {
  final double fee; // ₹2,499
  final String title;
  final String description;
  final List<String> features;

  const ConciergeServicePackage({
    this.fee = 2499.0,
    this.title = 'FlatFit VIP Matching Concierge',
    this.description = 'Don\'t have time to browse and text dozens of profiles? Let our senior relocation specialists curate and arrange your ideal flatmate match within 7 days.',
    this.features = const [
      'Dedicated Relocation Manager assigned within 2 hours',
      '3 curated, pre-screened & phone-interviewed flatmate matches',
      'Accompanied in-person or video flat walkthroughs',
      'Landlord negotiation & rent agreement drafting included',
      'Move-in guarantee or 100% refund',
    ],
  });
}

/// An intake request submitted by a customer for VIP concierge matching.
class ConciergeRequest {
  final String id;
  final String userId;
  final String userName;
  final String userPhone;
  final double budgetMin;
  final double budgetMax;
  final List<String> preferredLocalities;
  final DateTime targetMoveInDate;
  final String dietaryPreference;
  final String workSchedule; // WFH / Office
  final String customRequirements;
  final ConciergeStatus status;
  final String? assignedManagerName;
  final DateTime submittedAt;

  const ConciergeRequest({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.budgetMin,
    required this.budgetMax,
    required this.preferredLocalities,
    required this.targetMoveInDate,
    required this.dietaryPreference,
    required this.workSchedule,
    required this.customRequirements,
    this.status = ConciergeStatus.submitted,
    this.assignedManagerName,
    required this.submittedAt,
  });
}
