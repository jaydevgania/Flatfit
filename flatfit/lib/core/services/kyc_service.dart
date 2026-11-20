import 'package:flatfit/core/models/result.dart';

enum KycDocumentType { aadhaar, pan, drivingLicense, passport, collegeId, corporateEmail }

enum KycStatus { notStarted, pending, verified, rejected }

class KycVerificationResult {
  final KycStatus status;
  final String documentType;
  final String? maskedDocumentNumber;
  final String? verifiedName;
  final String? rejectionReason;
  final DateTime verifiedAt;

  const KycVerificationResult({
    required this.status,
    required this.documentType,
    this.maskedDocumentNumber,
    this.verifiedName,
    this.rejectionReason,
    required this.verifiedAt,
  });
}

/// Interface for Government / ID verification in India.
abstract class KycService {
  Future<Result<bool>> initiateAadhaarOtp(String aadhaarNumber);
  Future<Result<KycVerificationResult>> verifyAadhaarOtp({
    required String aadhaarNumber,
    required String otp,
  });
  Future<Result<KycVerificationResult>> verifyPanCard({
    required String panNumber,
    required String fullName,
    required String dob,
  });
  Future<Result<bool>> verifyWorkEmail({
    required String workEmail,
    required String otp,
  });
}

class MockKycService implements KycService {
  @override
  Future<Result<bool>> initiateAadhaarOtp(String aadhaarNumber) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const Result.success(true);
  }

  @override
  Future<Result<KycVerificationResult>> verifyAadhaarOtp({
    required String aadhaarNumber,
    required String otp,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final masked = 'XXXX-XXXX-${aadhaarNumber.length >= 4 ? aadhaarNumber.substring(aadhaarNumber.length - 4) : '1234'}';
    return Result.success(KycVerificationResult(
      status: KycStatus.verified,
      documentType: 'aadhaar',
      maskedDocumentNumber: masked,
      verifiedName: 'Verified FlatFit User',
      verifiedAt: DateTime.now(),
    ));
  }

  @override
  Future<Result<KycVerificationResult>> verifyPanCard({
    required String panNumber,
    required String fullName,
    required String dob,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return Result.success(KycVerificationResult(
      status: KycStatus.verified,
      documentType: 'pan',
      maskedDocumentNumber: '${panNumber.substring(0, 5)}XXXX${panNumber.substring(panNumber.length - 1)}',
      verifiedName: fullName,
      verifiedAt: DateTime.now(),
    ));
  }

  @override
  Future<Result<bool>> verifyWorkEmail({
    required String workEmail,
    required String otp,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return const Result.success(true);
  }
}
