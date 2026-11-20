import 'package:flutter/foundation.dart';
import '../../matching/domain/profile.dart';

enum InterestStatus {
  pending,
  accepted,
  declined;

  static InterestStatus fromString(String val) {
    switch (val.toLowerCase()) {
      case 'accepted':
        return InterestStatus.accepted;
      case 'declined':
        return InterestStatus.declined;
      case 'pending':
      default:
        return InterestStatus.pending;
    }
  }
}

/// Represents an interest expression or connection request sent between two users.
@immutable
class InterestModel {
  final String id;
  final String fromUserId;
  final String toUserId;
  final String? note;
  final InterestStatus status;
  final bool isSuperInterest;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final Profile? toProfile;
  final Profile? fromProfile;

  const InterestModel({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    this.note,
    this.status = InterestStatus.pending,
    this.isSuperInterest = false,
    required this.createdAt,
    this.updatedAt,
    this.toProfile,
    this.fromProfile,
  });

  InterestModel copyWith({
    String? id,
    String? fromUserId,
    String? toUserId,
    String? note,
    InterestStatus? status,
    bool? isSuperInterest,
    DateTime? createdAt,
    DateTime? updatedAt,
    Profile? toProfile,
    Profile? fromProfile,
  }) {
    return InterestModel(
      id: id ?? this.id,
      fromUserId: fromUserId ?? this.fromUserId,
      toUserId: toUserId ?? this.toUserId,
      note: note ?? this.note,
      status: status ?? this.status,
      isSuperInterest: isSuperInterest ?? this.isSuperInterest,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      toProfile: toProfile ?? this.toProfile,
      fromProfile: fromProfile ?? this.fromProfile,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'from_user': fromUserId,
    'to_user': toUserId,
    'note': note,
    'status': status.name,
    'is_super_interest': isSuperInterest,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

  factory InterestModel.fromJson(Map<String, dynamic> json) {
    return InterestModel(
      id: json['id'] as String? ?? '',
      fromUserId: json['from_user'] as String? ?? json['from_user_id'] as String? ?? '',
      toUserId: json['to_user'] as String? ?? json['to_user_id'] as String? ?? '',
      note: json['note'] as String?,
      status: InterestStatus.fromString(json['status'] as String? ?? 'pending'),
      isSuperInterest: json['is_super_interest'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
      toProfile: json['to_profile'] != null && json['to_profile'] is Map
          ? Profile.fromJson(Map<String, dynamic>.from(json['to_profile'] as Map))
          : null,
      fromProfile: json['from_profile'] != null && json['from_profile'] is Map
          ? Profile.fromJson(Map<String, dynamic>.from(json['from_profile'] as Map))
          : null,
    );
  }
}
