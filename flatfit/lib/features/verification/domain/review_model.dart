class UserReview {
  final String id;
  final String reviewerId;
  final String revieweeId;
  final String reviewerName;
  final int rating;
  final int stayDurationMonths;
  final DateTime createdAt;

  const UserReview({
    required this.id,
    required this.reviewerId,
    required this.revieweeId,
    required this.reviewerName,
    required this.rating,
    required this.stayDurationMonths,
    required this.createdAt,
  });

  bool get meetsStayRequirement => stayDurationMonths >= 1;
}
