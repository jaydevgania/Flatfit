import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/verification_model.dart';
import '../domain/verification_type.dart';

abstract class VerificationRepository {
  Future<List<UserVerification>> getVerifications(String userId);
  Future<UserVerification> submitKycVerification({
    required String userId,
    required String idType, // 'aadhaar', 'passport', 'driving_license', 'voter_id'
    required String maskedIdNumber,
    required String idPhotoUrl,
    required String selfiePhotoUrl,
  });
  Future<UserVerification> submitEmailVerification({
    required String userId,
    required String email,
    required bool isCollege,
  });
  Future<UserVerification> verifyEmailOtp({
    required String userId,
    required String otp,
    required bool isCollege,
  });
  Future<UserVerification> submitLinkedInVerification({
    required String userId,
    required String linkedInUrl,
  });
}

class VerificationRepositoryImpl implements VerificationRepository {
  final SupabaseClient? _client;
  final Map<String, List<UserVerification>> _inMemoryStore = {};

  VerificationRepositoryImpl({SupabaseClient? client})
      : _client = client ?? (Supabase.instance.isInitialized ? Supabase.instance.client : null);

  @override
  Future<List<UserVerification>> getVerifications(String userId) async {
    if (_client != null) {
      try {
        final response = await _client!
            .from('verifications')
            .select()
            .eq('user_id', userId);
        return (response as List)
            .map((e) => UserVerification.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (_) {
        return _getFallbackVerifications(userId);
      }
    }
    return _getFallbackVerifications(userId);
  }

  @override
  Future<UserVerification> submitKycVerification({
    required String userId,
    required String idType,
    required String maskedIdNumber,
    required String idPhotoUrl,
    required String selfiePhotoUrl,
  }) async {
    // DPDP-compliant Mock KYC verification:
    // Masked Aadhaar / ID, selfie liveness match simulated
    final verification = UserVerification(
      id: 'ver_kyc_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      type: VerificationType.kyc,
      status: VerificationStatus.verified, // Instant auto-verification mock
      providerRef: 'MOCK_KYC_REF_${DateTime.now().millisecondsSinceEpoch}',
      data: {
        'id_type': idType,
        'masked_id': maskedIdNumber,
        'liveness_score': 0.98,
        'verified_name_match': true,
      },
      verifiedAt: DateTime.now(),
      createdAt: DateTime.now(),
    );

    _updateLocalStore(userId, verification);

    if (_client != null) {
      try {
        await _client!.from('verifications').upsert(verification.toJson());
      } catch (_) {}
    }

    return verification;
  }

  @override
  Future<UserVerification> submitEmailVerification({
    required String userId,
    required String email,
    required bool isCollege,
  }) async {
    final type = isCollege ? VerificationType.collegeEmail : VerificationType.employerEmail;
    final verification = UserVerification(
      id: 'ver_email_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      type: type,
      status: VerificationStatus.pending,
      data: {'email': email},
      createdAt: DateTime.now(),
    );

    _updateLocalStore(userId, verification);
    return verification;
  }

  @override
  Future<UserVerification> verifyEmailOtp({
    required String userId,
    required String otp,
    required bool isCollege,
  }) async {
    final type = isCollege ? VerificationType.collegeEmail : VerificationType.employerEmail;
    final verification = UserVerification(
      id: 'ver_email_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      type: type,
      status: VerificationStatus.verified,
      providerRef: 'OTP_VERIFIED_$otp',
      data: {'verified_domain': isCollege ? 'college.edu' : 'company.com'},
      verifiedAt: DateTime.now(),
      createdAt: DateTime.now(),
    );

    _updateLocalStore(userId, verification);

    if (_client != null) {
      try {
        await _client!.from('verifications').upsert(verification.toJson());
      } catch (_) {}
    }

    return verification;
  }

  @override
  Future<UserVerification> submitLinkedInVerification({
    required String userId,
    required String linkedInUrl,
  }) async {
    final verification = UserVerification(
      id: 'ver_li_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      type: VerificationType.linkedin,
      status: VerificationStatus.verified,
      providerRef: 'LINKEDIN_OAUTH',
      data: {'profile_url': linkedInUrl},
      verifiedAt: DateTime.now(),
      createdAt: DateTime.now(),
    );

    _updateLocalStore(userId, verification);

    if (_client != null) {
      try {
        await _client!.from('verifications').upsert(verification.toJson());
      } catch (_) {}
    }

    return verification;
  }

  void _updateLocalStore(String userId, UserVerification verification) {
    final currentList = _inMemoryStore[userId] ?? _getFallbackVerifications(userId);
    final updated = currentList.where((v) => v.type != verification.type).toList();
    updated.add(verification);
    _inMemoryStore[userId] = updated;
  }

  List<UserVerification> _getFallbackVerifications(String userId) {
    if (_inMemoryStore.containsKey(userId)) {
      return _inMemoryStore[userId]!;
    }
    return [
      UserVerification(
        id: 'v_phone',
        userId: userId,
        type: VerificationType.phone,
        status: VerificationStatus.verified,
        verifiedAt: DateTime.now().subtract(const Duration(days: 30)),
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      UserVerification(
        id: 'v_kyc',
        userId: userId,
        type: VerificationType.kyc,
        status: VerificationStatus.notStarted,
        createdAt: DateTime.now(),
      ),
      UserVerification(
        id: 'v_work',
        userId: userId,
        type: VerificationType.employerEmail,
        status: VerificationStatus.verified,
        verifiedAt: DateTime.now().subtract(const Duration(days: 15)),
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
      UserVerification(
        id: 'v_college',
        userId: userId,
        type: VerificationType.collegeEmail,
        status: VerificationStatus.notStarted,
        createdAt: DateTime.now(),
      ),
      UserVerification(
        id: 'v_li',
        userId: userId,
        type: VerificationType.linkedin,
        status: VerificationStatus.notStarted,
        createdAt: DateTime.now(),
      ),
    ];
  }
}
