import 'verification_type.dart';

/// Single verification record for a user.
class UserVerification {
  final String id;
  final String userId;
  final VerificationType type;
  final VerificationStatus status;
  final String? providerRef;
  final Map<String, dynamic> data;
  final DateTime? verifiedAt;
  final DateTime? expiresAt;
  final DateTime createdAt;

  const UserVerification({
    required this.id,
    required this.userId,
    required this.type,
    this.status = VerificationStatus.pending,
    this.providerRef,
    this.data = const {},
    this.verifiedAt,
    this.expiresAt,
    required this.createdAt,
  });

  bool get isVerified => status == VerificationStatus.verified;

  factory UserVerification.fromJson(Map<String, dynamic> json) {
    return UserVerification(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? json['userId'] as String? ?? '',
      type: VerificationType.fromString(json['type']?.toString() ?? 'phone'),
      status: VerificationStatus.fromString(json['status']?.toString() ?? 'pending'),
      providerRef: json['provider_ref'] as String? ?? json['providerRef'] as String?,
      data: json['data'] != null && json['data'] is Map
          ? Map<String, dynamic>.from(json['data'] as Map)
          : {},
      verifiedAt: json['verified_at'] != null
          ? DateTime.tryParse(json['verified_at'].toString())
          : null,
      expiresAt: json['expires_at'] != null
          ? DateTime.tryParse(json['expires_at'].toString())
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type.toDbValue(),
      'status': status.toDbValue(),
      'provider_ref': providerRef,
      'data': data,
      'verified_at': verifiedAt?.toIso8601String(),
      'expires_at': expiresAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  UserVerification copyWith({
    String? id,
    String? userId,
    VerificationType? type,
    VerificationStatus? status,
    String? providerRef,
    Map<String, dynamic>? data,
    DateTime? verifiedAt,
    DateTime? expiresAt,
    DateTime? createdAt,
  }) {
    return UserVerification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      status: status ?? this.status,
      providerRef: providerRef ?? this.providerRef,
      data: data ?? this.data,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
