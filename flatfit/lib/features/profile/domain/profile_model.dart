import 'housing_goal.dart';
import 'occupation_type.dart';

/// Core profile model for a FlatFit user.
class Profile {
  final String id;
  final String fullName;
  final int? age;
  final String? gender;
  final OccupationType? occupation;
  final String? city;
  final String? bio;
  final HousingGoal? housingGoal;
  final int? budgetMin;
  final int? budgetMax;
  final List<String> preferredLocalities;
  final double? latitude;
  final double? longitude;
  final DateTime? moveInDate;
  final String? stayDuration;
  final int profileCompletion;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ProfilePhoto> photos;
  final VoiceIntro? voiceIntro;

  const Profile({
    required this.id,
    required this.fullName,
    this.age,
    this.gender,
    this.occupation,
    this.city,
    this.bio,
    this.housingGoal,
    this.budgetMin,
    this.budgetMax,
    this.preferredLocalities = const [],
    this.latitude,
    this.longitude,
    this.moveInDate,
    this.stayDuration,
    this.profileCompletion = 0,
    required this.createdAt,
    required this.updatedAt,
    this.photos = const [],
    this.voiceIntro,
  });

  /// Deserialize from Supabase JSON response.
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      fullName: json['full_name'] as String? ?? '',
      age: json['age'] as int?,
      gender: json['gender'] as String?,
      occupation: json['occupation'] != null
          ? OccupationType.fromValue(json['occupation'] as String)
          : null,
      city: json['city'] as String?,
      bio: json['bio'] as String?,
      housingGoal: json['housing_goal'] != null
          ? HousingGoal.fromValue(json['housing_goal'] as String)
          : null,
      budgetMin: json['budget_min'] as int?,
      budgetMax: json['budget_max'] as int?,
      preferredLocalities: (json['preferred_localities'] as List<dynamic>?)
              ?.cast<String>() ??
          [],
      latitude: (json['location'] as Map<String, dynamic>?)?['coordinates']
              ?[1] as double?,
      longitude: (json['location'] as Map<String, dynamic>?)?['coordinates']
              ?[0] as double?,
      moveInDate: json['move_in_date'] != null
          ? DateTime.tryParse(json['move_in_date'] as String)
          : null,
      stayDuration: json['stay_duration'] as String?,
      profileCompletion: json['profile_completion'] as int? ?? 0,
      createdAt: DateTime.parse(
          json['created_at'] as String? ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(
          json['updated_at'] as String? ?? DateTime.now().toIso8601String()),
      photos: (json['profile_photos'] as List<dynamic>?)
              ?.map((p) => ProfilePhoto.fromJson(p as Map<String, dynamic>))
              .toList() ??
          [],
      voiceIntro: json['voice_intros'] != null &&
              (json['voice_intros'] as List<dynamic>).isNotEmpty
          ? VoiceIntro.fromJson(
              (json['voice_intros'] as List<dynamic>).first
                  as Map<String, dynamic>)
          : null,
    );
  }

  /// Serialize to JSON for Supabase upsert.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      if (age != null) 'age': age,
      if (gender != null) 'gender': gender,
      if (occupation != null) 'occupation': occupation!.value,
      if (city != null) 'city': city,
      if (bio != null) 'bio': bio,
      if (housingGoal != null) 'housing_goal': housingGoal!.value,
      if (budgetMin != null) 'budget_min': budgetMin,
      if (budgetMax != null) 'budget_max': budgetMax,
      if (preferredLocalities.isNotEmpty)
        'preferred_localities': preferredLocalities,
      if (latitude != null && longitude != null)
        'location': 'POINT($longitude $latitude)',
      if (moveInDate != null) 'move_in_date': moveInDate!.toIso8601String(),
      if (stayDuration != null) 'stay_duration': stayDuration,
      'profile_completion': profileCompletion,
    };
  }

  /// Calculate profile completion percentage.
  int calculateCompletion() {
    int score = 0;
    const total = 10;
    if (fullName.isNotEmpty) score++;
    if (age != null) score++;
    if (gender != null) score++;
    if (occupation != null) score++;
    if (city != null) score++;
    if (housingGoal != null) score++;
    if (budgetMin != null && budgetMax != null) score++;
    if (bio != null && bio!.isNotEmpty) score++;
    if (photos.isNotEmpty) score++;
    if (preferredLocalities.isNotEmpty) score++;
    return ((score / total) * 100).round();
  }

  Profile copyWith({
    String? id,
    String? fullName,
    int? age,
    String? gender,
    OccupationType? occupation,
    String? city,
    String? bio,
    HousingGoal? housingGoal,
    int? budgetMin,
    int? budgetMax,
    List<String>? preferredLocalities,
    double? latitude,
    double? longitude,
    DateTime? moveInDate,
    String? stayDuration,
    int? profileCompletion,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<ProfilePhoto>? photos,
    VoiceIntro? voiceIntro,
  }) {
    return Profile(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      occupation: occupation ?? this.occupation,
      city: city ?? this.city,
      bio: bio ?? this.bio,
      housingGoal: housingGoal ?? this.housingGoal,
      budgetMin: budgetMin ?? this.budgetMin,
      budgetMax: budgetMax ?? this.budgetMax,
      preferredLocalities: preferredLocalities ?? this.preferredLocalities,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      moveInDate: moveInDate ?? this.moveInDate,
      stayDuration: stayDuration ?? this.stayDuration,
      profileCompletion: profileCompletion ?? this.profileCompletion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      photos: photos ?? this.photos,
      voiceIntro: voiceIntro ?? this.voiceIntro,
    );
  }
}

/// A photo in a user's profile (up to 5).
class ProfilePhoto {
  final String id;
  final String profileId;
  final String url;
  final int position;
  final bool isPrimary;
  final DateTime createdAt;

  const ProfilePhoto({
    required this.id,
    required this.profileId,
    required this.url,
    required this.position,
    this.isPrimary = false,
    required this.createdAt,
  });

  factory ProfilePhoto.fromJson(Map<String, dynamic> json) {
    return ProfilePhoto(
      id: json['id'] as String,
      profileId: json['profile_id'] as String,
      url: json['url'] as String,
      position: json['position'] as int? ?? 0,
      isPrimary: json['is_primary'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile_id': profileId,
      'url': url,
      'position': position,
      'is_primary': isPrimary,
    };
  }
}

/// Optional voice/video intro (15-30 seconds).
class VoiceIntro {
  final String id;
  final String profileId;
  final String url;
  final int durationSeconds;
  final DateTime createdAt;

  const VoiceIntro({
    required this.id,
    required this.profileId,
    required this.url,
    required this.durationSeconds,
    required this.createdAt,
  });

  factory VoiceIntro.fromJson(Map<String, dynamic> json) {
    return VoiceIntro(
      id: json['id'] as String,
      profileId: json['profile_id'] as String,
      url: json['url'] as String,
      durationSeconds: json['duration_seconds'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile_id': profileId,
      'url': url,
      'duration_seconds': durationSeconds,
    };
  }
}
