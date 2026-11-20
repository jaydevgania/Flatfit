/// Representation of an authenticated FlatFit user.
class FlatFitUser {
  final String id;
  final String? phone;
  final String? email;
  final String? fullName;
  final String? avatarUrl;
  final bool hasProfile;
  final bool isVerified;
  final DateTime createdAt;

  const FlatFitUser({
    required this.id,
    this.phone,
    this.email,
    this.fullName,
    this.avatarUrl,
    this.hasProfile = false,
    this.isVerified = false,
    required this.createdAt,
  });

  FlatFitUser copyWith({
    String? id,
    String? phone,
    String? email,
    String? fullName,
    String? avatarUrl,
    bool? hasProfile,
    bool? isVerified,
    DateTime? createdAt,
  }) {
    return FlatFitUser(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      hasProfile: hasProfile ?? this.hasProfile,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory FlatFitUser.fromMap(Map<String, dynamic> map) {
    return FlatFitUser(
      id: map['id'] as String,
      phone: map['phone'] as String?,
      email: map['email'] as String?,
      fullName: map['full_name'] as String?,
      avatarUrl: map['avatar_url'] as String?,
      hasProfile: map['has_profile'] as bool? ?? false,
      isVerified: map['is_verified'] as bool? ?? false,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'phone': phone,
      'email': email,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'has_profile': hasProfile,
      'is_verified': isVerified,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

/// Result returned after requesting an OTP via phone auth.
class PhoneAuthResult {
  final String phoneNumber;
  final String? messageId;
  final bool isSent;

  const PhoneAuthResult({
    required this.phoneNumber,
    this.messageId,
    this.isSent = true,
  });
}
