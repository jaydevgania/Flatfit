import 'package:flutter/foundation.dart';

/// Comprehensive filter model for the Discovery screen.
///
/// Filters cover budget, localities, move-in timeframe, room type, furnishing,
/// gender, age bracket, occupation type, housing goal, and minimum compatibility score.
@immutable
class DiscoveryFilters {
  final double budgetMin;
  final double budgetMax;
  final List<String> localities;
  final DateTime? moveInBefore;
  final String roomType; // 'single', 'shared', 'any'
  final String furnishing; // 'furnished', 'semi_furnished', 'unfurnished', 'any'
  final String gender; // 'male', 'female', 'non_binary', 'any'
  final int ageMin;
  final int ageMax;
  final List<String> occupations; // ['working', 'student', 'freelancer']
  final String housingGoal; // 'need_room', 'have_room', 'looking_together', 'any'
  final double minCompatibilityScore;
  final bool onlyVerified;

  const DiscoveryFilters({
    this.budgetMin = 10000.0,
    this.budgetMax = 40000.0,
    this.localities = const [],
    this.moveInBefore,
    this.roomType = 'any',
    this.furnishing = 'any',
    this.gender = 'any',
    this.ageMin = 18,
    this.ageMax = 50,
    this.occupations = const [],
    this.housingGoal = 'any',
    this.minCompatibilityScore = 0.0,
    this.onlyVerified = false,
  });

  /// Default filters with sensible Mumbai presets.
  static const defaults = DiscoveryFilters();

  /// Whether any non-default filters have been customized.
  bool get hasActiveFilters {
    return budgetMin != 10000.0 ||
        budgetMax != 40000.0 ||
        localities.isNotEmpty ||
        moveInBefore != null ||
        roomType != 'any' ||
        furnishing != 'any' ||
        gender != 'any' ||
        ageMin != 18 ||
        ageMax != 50 ||
        occupations.isNotEmpty ||
        housingGoal != 'any' ||
        minCompatibilityScore > 0 ||
        onlyVerified;
  }

  /// Number of active non-default filter criteria.
  int get activeFilterCount {
    int count = 0;
    if (budgetMin != 10000.0 || budgetMax != 40000.0) count++;
    if (localities.isNotEmpty) count++;
    if (moveInBefore != null) count++;
    if (roomType != 'any') count++;
    if (furnishing != 'any') count++;
    if (gender != 'any') count++;
    if (ageMin != 18 || ageMax != 50) count++;
    if (occupations.isNotEmpty) count++;
    if (housingGoal != 'any') count++;
    if (minCompatibilityScore > 0) count++;
    if (onlyVerified) count++;
    return count;
  }

  DiscoveryFilters copyWith({
    double? budgetMin,
    double? budgetMax,
    List<String>? localities,
    DateTime? moveInBefore,
    String? roomType,
    String? furnishing,
    String? gender,
    int? ageMin,
    int? ageMax,
    List<String>? occupations,
    String? housingGoal,
    double? minCompatibilityScore,
    bool? onlyVerified,
  }) {
    return DiscoveryFilters(
      budgetMin: budgetMin ?? this.budgetMin,
      budgetMax: budgetMax ?? this.budgetMax,
      localities: localities ?? this.localities,
      moveInBefore: moveInBefore ?? this.moveInBefore,
      roomType: roomType ?? this.roomType,
      furnishing: furnishing ?? this.furnishing,
      gender: gender ?? this.gender,
      ageMin: ageMin ?? this.ageMin,
      ageMax: ageMax ?? this.ageMax,
      occupations: occupations ?? this.occupations,
      housingGoal: housingGoal ?? this.housingGoal,
      minCompatibilityScore:
          minCompatibilityScore ?? this.minCompatibilityScore,
      onlyVerified: onlyVerified ?? this.onlyVerified,
    );
  }

  Map<String, dynamic> toJson() => {
    'budget_min': budgetMin,
    'budget_max': budgetMax,
    'localities': localities,
    'move_in_before': moveInBefore?.toIso8601String(),
    'room_type': roomType,
    'furnishing': furnishing,
    'gender': gender,
    'age_min': ageMin,
    'age_max': ageMax,
    'occupations': occupations,
    'housing_goal': housingGoal,
    'min_compatibility_score': minCompatibilityScore,
    'only_verified': onlyVerified,
  };

  factory DiscoveryFilters.fromJson(Map<String, dynamic> json) {
    return DiscoveryFilters(
      budgetMin: (json['budget_min'] as num?)?.toDouble() ?? 10000.0,
      budgetMax: (json['budget_max'] as num?)?.toDouble() ?? 40000.0,
      localities: (json['localities'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      moveInBefore: json['move_in_before'] != null
          ? DateTime.tryParse(json['move_in_before'].toString())
          : null,
      roomType: json['room_type'] as String? ?? 'any',
      furnishing: json['furnishing'] as String? ?? 'any',
      gender: json['gender'] as String? ?? 'any',
      ageMin: json['age_min'] as int? ?? 18,
      ageMax: json['age_max'] as int? ?? 50,
      occupations: (json['occupations'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      housingGoal: json['housing_goal'] as String? ?? 'any',
      minCompatibilityScore:
          (json['min_compatibility_score'] as num?)?.toDouble() ?? 0.0,
      onlyVerified: json['only_verified'] as bool? ?? false,
    );
  }
}
