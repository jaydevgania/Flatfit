import 'chat_enums.dart';

/// Represents a scheduled in-person meetup between flatmates at a neutral public place.
class MeetUp {
  final String id;
  final String conversationId;
  final String hostId;
  final String participantId;
  final DateTime scheduledTime;
  final MeetStatus status;
  final String placeName;
  final String address;
  final double? latitude;
  final double? longitude;
  final bool isPublicPlace;
  final bool isLiveLocationShared;
  final String? trustedContactPhone;
  final String? notes;
  final DateTime createdAt;

  const MeetUp({
    required this.id,
    required this.conversationId,
    required this.hostId,
    required this.participantId,
    required this.scheduledTime,
    this.status = MeetStatus.pending,
    required this.placeName,
    required this.address,
    this.latitude,
    this.longitude,
    this.isPublicPlace = true,
    this.isLiveLocationShared = false,
    this.trustedContactPhone,
    this.notes,
    required this.createdAt,
  });

  factory MeetUp.fromJson(Map<String, dynamic> json) {
    return MeetUp(
      id: json['id'] as String,
      conversationId: json['conversation_id'] as String? ?? json['conversationId'] as String? ?? '',
      hostId: json['host_id'] as String? ?? json['hostId'] as String? ?? '',
      participantId: json['participant_id'] as String? ?? json['participantId'] as String? ?? '',
      scheduledTime: json['scheduled_time'] != null 
          ? DateTime.tryParse(json['scheduled_time'].toString()) ?? DateTime.now()
          : DateTime.now(),
      status: json['status'] != null 
          ? MeetStatus.fromString(json['status'].toString()) 
          : MeetStatus.pending,
      placeName: json['place_name'] as String? ?? json['placeName'] as String? ?? 'Public Meeting Spot',
      address: json['address'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      isPublicPlace: json['is_public_place'] as bool? ?? json['isPublicPlace'] as bool? ?? true,
      isLiveLocationShared: json['is_live_location_shared'] as bool? ?? json['isLiveLocationShared'] as bool? ?? false,
      trustedContactPhone: json['trusted_contact_phone'] as String? ?? json['trustedContactPhone'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'host_id': hostId,
      'participant_id': participantId,
      'scheduled_time': scheduledTime.toIso8601String(),
      'status': status.toJson(),
      'place_name': placeName,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'is_public_place': isPublicPlace,
      'is_live_location_shared': isLiveLocationShared,
      'trusted_contact_phone': trustedContactPhone,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }

  MeetUp copyWith({
    String? id,
    String? conversationId,
    String? hostId,
    String? participantId,
    DateTime? scheduledTime,
    MeetStatus? status,
    String? placeName,
    String? address,
    double? latitude,
    double? longitude,
    bool? isPublicPlace,
    bool? isLiveLocationShared,
    String? trustedContactPhone,
    String? notes,
    DateTime? createdAt,
  }) {
    return MeetUp(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      hostId: hostId ?? this.hostId,
      participantId: participantId ?? this.participantId,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      status: status ?? this.status,
      placeName: placeName ?? this.placeName,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isPublicPlace: isPublicPlace ?? this.isPublicPlace,
      isLiveLocationShared: isLiveLocationShared ?? this.isLiveLocationShared,
      trustedContactPhone: trustedContactPhone ?? this.trustedContactPhone,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// Suggested public place (Cafe, Metro station, Mall, Co-working)
class PublicPlaceSuggestion {
  final String id;
  final String name;
  final String category; // 'Cafe', 'Mall', 'Metro Station', 'Co-Working'
  final String locality;
  final String address;
  final double rating;
  final double distanceKm;
  final double latitude;
  final double longitude;

  const PublicPlaceSuggestion({
    required this.id,
    required this.name,
    required this.category,
    required this.locality,
    required this.address,
    required this.rating,
    required this.distanceKm,
    required this.latitude,
    required this.longitude,
  });

  factory PublicPlaceSuggestion.fromJson(Map<String, dynamic> json) {
    return PublicPlaceSuggestion(
      id: json['id'] as String? ?? UniqueKey().toString(),
      name: json['name'] as String? ?? 'Safe Public Place',
      category: json['category'] as String? ?? 'Cafe',
      locality: json['locality'] as String? ?? '',
      address: json['address'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 4.5,
      distanceKm: (json['distance_km'] as num?)?.toDouble() ?? 1.2,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 19.0760,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 72.8777,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'locality': locality,
      'address': address,
      'rating': rating,
      'distance_km': distanceKm,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
class UniqueKey {
  static int _c = 0;
  @override
  String toString() => 'key_${_c++}';
}
