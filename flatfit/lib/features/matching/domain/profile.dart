import 'package:flutter/foundation.dart';

/// Geographic coordinates for distance calculation.
@immutable
class GeoLocation {
  final double latitude;
  final double longitude;

  const GeoLocation({required this.latitude, required this.longitude});

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
  };

  factory GeoLocation.fromJson(Map<String, dynamic> json) {
    return GeoLocation(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
}

/// Profile model used across matching and discovery features.
@immutable
class Profile {
  final String id;
  final String fullName;
  final int age;
  final String gender;
  final String occupation;
  final String? companyOrCollege;
  final String city;
  final String? locality;
  final String? bio;
  final String housingGoal; // 'need_room', 'have_room', 'looking_together'
  final double budgetMin;
  final double budgetMax;
  final List<String> preferredLocalities;
  final GeoLocation? location;
  final DateTime? moveInDate;
  final String? stayDuration;
  final String? genderPreference;
  final int? agePreferenceMin;
  final int? agePreferenceMax;
  final int profileCompletion;
  final List<String> photos;
  final String? primaryPhotoUrl;
  final List<String> keyTraits;
  final bool isVerified;
  final bool isActive;
  final DateTime? lastActiveAt;
  final DateTime? createdAt;

  const Profile({
    required this.id,
    required this.fullName,
    this.age = 24,
    this.gender = 'male',
    this.occupation = 'working',
    this.companyOrCollege,
    this.city = 'Mumbai',
    this.locality,
    this.bio,
    this.housingGoal = 'need_room',
    this.budgetMin = 15000,
    this.budgetMax = 25000,
    this.preferredLocalities = const [],
    this.location,
    this.moveInDate,
    this.stayDuration = '1 year',
    this.genderPreference,
    this.agePreferenceMin,
    this.agePreferenceMax,
    this.profileCompletion = 85,
    this.photos = const [],
    this.primaryPhotoUrl,
    this.keyTraits = const [],
    this.isVerified = true,
    this.isActive = true,
    this.lastActiveAt,
    this.createdAt,
  });

  /// Effective primary photo URL with a safe default placeholder.
  String get displayPhoto {
    if (primaryPhotoUrl != null && primaryPhotoUrl!.isNotEmpty) {
      return primaryPhotoUrl!;
    }
    if (photos.isNotEmpty) {
      return photos.first;
    }
    return 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=600&q=80';
  }

  /// Formatted budget display (e.g. "₹15,000 - ₹25,000").
  String get budgetDisplay {
    final minFormatted = budgetMin.toInt().toString().replaceAllMapped(
      RegExp(r'(\d+?)(?=(\d\d)+(\d)(?!\d))(\.\d+)?'),
      (m) => '${m[1]},',
    );
    final maxFormatted = budgetMax.toInt().toString().replaceAllMapped(
      RegExp(r'(\d+?)(?=(\d\d)+(\d)(?!\d))(\.\d+)?'),
      (m) => '${m[1]},',
    );
    return '₹$minFormatted - ₹$maxFormatted';
  }

  Profile copyWith({
    String? id,
    String? fullName,
    int? age,
    String? gender,
    String? occupation,
    String? companyOrCollege,
    String? city,
    String? locality,
    String? bio,
    String? housingGoal,
    double? budgetMin,
    double? budgetMax,
    List<String>? preferredLocalities,
    GeoLocation? location,
    DateTime? moveInDate,
    String? stayDuration,
    String? genderPreference,
    int? agePreferenceMin,
    int? agePreferenceMax,
    int? profileCompletion,
    List<String>? photos,
    String? primaryPhotoUrl,
    List<String>? keyTraits,
    bool? isVerified,
    bool? isActive,
    DateTime? lastActiveAt,
    DateTime? createdAt,
  }) {
    return Profile(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      occupation: occupation ?? this.occupation,
      companyOrCollege: companyOrCollege ?? this.companyOrCollege,
      city: city ?? this.city,
      locality: locality ?? this.locality,
      bio: bio ?? this.bio,
      housingGoal: housingGoal ?? this.housingGoal,
      budgetMin: budgetMin ?? this.budgetMin,
      budgetMax: budgetMax ?? this.budgetMax,
      preferredLocalities: preferredLocalities ?? this.preferredLocalities,
      location: location ?? this.location,
      moveInDate: moveInDate ?? this.moveInDate,
      stayDuration: stayDuration ?? this.stayDuration,
      genderPreference: genderPreference ?? this.genderPreference,
      agePreferenceMin: agePreferenceMin ?? this.agePreferenceMin,
      agePreferenceMax: agePreferenceMax ?? this.agePreferenceMax,
      profileCompletion: profileCompletion ?? this.profileCompletion,
      photos: photos ?? this.photos,
      primaryPhotoUrl: primaryPhotoUrl ?? this.primaryPhotoUrl,
      keyTraits: keyTraits ?? this.keyTraits,
      isVerified: isVerified ?? this.isVerified,
      isActive: isActive ?? this.isActive,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'full_name': fullName,
    'age': age,
    'gender': gender,
    'occupation': occupation,
    'company_or_college': companyOrCollege,
    'city': city,
    'locality': locality,
    'bio': bio,
    'housing_goal': housingGoal,
    'budget_min': budgetMin,
    'budget_max': budgetMax,
    'preferred_localities': preferredLocalities,
    'location': location?.toJson(),
    'move_in_date': moveInDate?.toIso8601String(),
    'stay_duration': stayDuration,
    'gender_preference': genderPreference,
    'age_preference_min': agePreferenceMin,
    'age_preference_max': agePreferenceMax,
    'profile_completion': profileCompletion,
    'photos': photos,
    'primary_photo_url': primaryPhotoUrl,
    'key_traits': keyTraits,
    'is_verified': isVerified,
    'is_active': isActive,
    'last_active_at': lastActiveAt?.toIso8601String(),
    'created_at': createdAt?.toIso8601String(),
  };

  factory Profile.fromJson(Map<String, dynamic> json) {
    GeoLocation? loc;
    if (json['location'] != null && json['location'] is Map) {
      loc = GeoLocation.fromJson(json['location'] as Map<String, dynamic>);
    } else if (json['latitude'] != null && json['longitude'] != null) {
      loc = GeoLocation(
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
      );
    }

    final rawPhotos = (json['photos'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        const [];

    return Profile(
      id: json['id'] as String? ?? '',
      fullName: json['full_name'] as String? ?? 'FlatFit User',
      age: json['age'] as int? ?? 25,
      gender: json['gender'] as String? ?? 'male',
      occupation: json['occupation'] as String? ?? 'working',
      companyOrCollege: json['company_or_college'] as String?,
      city: json['city'] as String? ?? 'Mumbai',
      locality: json['locality'] as String?,
      bio: json['bio'] as String?,
      housingGoal: json['housing_goal'] as String? ?? 'need_room',
      budgetMin: (json['budget_min'] as num?)?.toDouble() ?? 10000.0,
      budgetMax: (json['budget_max'] as num?)?.toDouble() ?? 25000.0,
      preferredLocalities: (json['preferred_localities'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      location: loc,
      moveInDate: json['move_in_date'] != null
          ? DateTime.tryParse(json['move_in_date'].toString())
          : null,
      stayDuration: json['stay_duration'] as String?,
      genderPreference: json['gender_preference'] as String?,
      agePreferenceMin: json['age_preference_min'] as int?,
      agePreferenceMax: json['age_preference_max'] as int?,
      profileCompletion: json['profile_completion'] as int? ?? 75,
      photos: rawPhotos,
      primaryPhotoUrl: json['primary_photo_url'] as String? ??
          (rawPhotos.isNotEmpty ? rawPhotos.first : null),
      keyTraits: (json['key_traits'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      isVerified: json['is_verified'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      lastActiveAt: json['last_active_at'] != null
          ? DateTime.tryParse(json['last_active_at'].toString())
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }
}
