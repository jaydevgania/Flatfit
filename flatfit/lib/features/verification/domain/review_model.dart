/// Post-stay review model between flatmates.
class UserReview {
  final String id;
  final String reviewerId;
  final String revieweeId;
  final String reviewerName;
  final String? reviewerAvatarUrl;
  final String? flatId;
  final int rating; // 1 - 5 stars
  final String? comment;
  final List<String> tags; // predefined tags from ReviewTags
  final String? privateFeedback; // only visible to FlatFit team / admin
  final int stayDurationMonths; // must be >= 1 (30+ days co-living)
  final bool isAnonymous;
  final DateTime createdAt;

  const UserReview({
    required this.id,
    required this.reviewerId,
    required this.revieweeId,
    required this.reviewerName,
    this.reviewerAvatarUrl,
    this.flatId,
    required this.rating,
    this.comment,
    this.tags = const [],
    this.privateFeedback,
    this.stayDurationMonths = 1,
    this.isAnonymous = false,
    required this.createdAt,
  });

  /// FlatFit rule: Reviews can only be left after 30+ days of living together.
  bool get meetsStayRequirement => stayDurationMonths >= 1;

  factory UserReview.fromJson(Map<String, dynamic> json) {
    final rawTags = json['tags'] as List<dynamic>? ?? [];
    final tagsList = rawTags.map((t) => t.toString()).toList();
    final profile = json['profiles'] as Map<String, dynamic>?;

    return UserReview(
      id: json['id'] as String? ?? '',
      reviewerId: json['reviewer_id'] as String? ?? json['reviewerId'] as String? ?? '',
      revieweeId: json['reviewee_id'] as String? ?? json['revieweeId'] as String? ?? '',
      reviewerName: json['is_anonymous'] == true
          ? 'Flatmate'
          : (profile != null
              ? profile['full_name'] as String? ?? 'Verified Flatmate'
              : json['reviewer_name'] as String? ?? 'Verified Flatmate'),
      reviewerAvatarUrl: json['is_anonymous'] == true
          ? null
          : (profile != null
              ? profile['avatar_url'] as String?
              : json['reviewer_avatar_url'] as String?),
      flatId: json['flat_id'] as String?,
      rating: (json['rating'] as num?)?.toInt() ?? 5,
      comment: json['comment'] as String?,
      tags: tagsList,
      privateFeedback: json['private_feedback'] as String?,
      stayDurationMonths: json['stay_duration_months'] as int? ?? 1,
      isAnonymous: json['is_anonymous'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reviewer_id': reviewerId,
      'reviewee_id': revieweeId,
      'flat_id': flatId,
      'rating': rating,
      'comment': comment,
      'tags': tags,
      'private_feedback': privateFeedback,
      'stay_duration_months': stayDurationMonths,
      'is_anonymous': isAnonymous,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
