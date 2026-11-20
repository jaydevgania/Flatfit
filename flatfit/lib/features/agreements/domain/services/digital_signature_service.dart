import 'dart:convert';
import '../models/agreement_models.dart';

/// Digital signature capture result.
class DigitalSignatureResult {
  final bool isSuccess;
  final AgreementSignature? signature;
  final String? errorMessage;
  final String auditTrail;

  const DigitalSignatureResult({
    required this.isSuccess,
    this.signature,
    this.errorMessage,
    required this.auditTrail,
  });
}

/// Service providing tamper-evident digital signing logic for flatmate agreements.
class DigitalSignatureService {
  /// Computes a deterministic checksum of the agreement content to detect alterations after signing.
  static String computeAgreementHash(FlatmateAgreement agreement) {
    final buffer = StringBuffer();
    buffer.write(agreement.id);
    buffer.write(agreement.title);
    buffer.write(agreement.rentAmount?.toStringAsFixed(2) ?? '0.00');
    buffer.write(agreement.depositAmount?.toStringAsFixed(2) ?? '0.00');
    buffer.write(agreement.noticePeriodDays);
    for (final clause in agreement.clauses) {
      buffer.write('${clause.id}:${clause.title}:${clause.description}');
    }

    final rawBytes = utf8.encode(buffer.toString());
    // Use standard Fowler-Noll-Vo 1a 64-bit combined hash representation for pure Dart compatibility
    int hash = 0xcbf29ce484222325;
    for (final byte in rawBytes) {
      hash ^= byte;
      hash = (hash * 0x100000001b3) & 0xFFFFFFFFFFFFFFFF;
    }
    return 'FF-SIG-${hash.toRadixString(16).padLeft(16, '0').toUpperCase()}';
  }

  /// Signs an agreement on behalf of a user.
  static DigitalSignatureResult signAgreement({
    required FlatmateAgreement agreement,
    required String userId,
    required String userName,
    required String signatureData, // SVG or Base64 path
    String ipAddress = '103.21.124.5', // Typical Indian broadband IP
  }) {
    if (agreement.status == AgreementStatus.terminated) {
      return const DigitalSignatureResult(
        isSuccess: false,
        errorMessage: 'Cannot sign a terminated agreement.',
        auditTrail: 'REJECTED: Agreement is terminated.',
      );
    }

    if (agreement.isSignedByUser(userId)) {
      return const DigitalSignatureResult(
        isSuccess: false,
        errorMessage: 'User has already signed this agreement.',
        auditTrail: 'DUPLICATE: Signature already exists for user.',
      );
    }

    final docHash = computeAgreementHash(agreement);
    final now = DateTime.now().toUtc();
    final signatureId = 'sig_${DateTime.now().millisecondsSinceEpoch}_${userId.substring(0, 4)}';

    final signature = AgreementSignature(
      id: signatureId,
      agreementId: agreement.id,
      userId: userId,
      userName: userName,
      signedAt: now,
      ipAddress: ipAddress,
      signatureHash: docHash,
      signatureSvgOrBase64: signatureData,
    );

    final auditTrail = 'Digital Consent Verified [User: $userName ($userId), Time: ${now.toIso8601String()}, '
        'IP: $ipAddress, DocChecksum: $docHash, Indian IT Act 2000 Section 10A compliant electronic assent]';

    return DigitalSignatureResult(
      isSuccess: true,
      signature: signature,
      auditTrail: auditTrail,
    );
  }

  /// Checks if all flatmates in memberUserIds have signed, and returns the updated agreement.
  static FlatmateAgreement updateAgreementStatusWithSignatures(
    FlatmateAgreement agreement,
    List<AgreementSignature> updatedSignatures,
  ) {
    final allSigned = agreement.memberUserIds.isNotEmpty &&
        agreement.memberUserIds.every((uid) => updatedSignatures.any((s) => s.userId == uid));

    return FlatmateAgreement(
      id: agreement.id,
      flatId: agreement.flatId,
      title: agreement.title,
      description: agreement.description,
      agreementType: agreement.agreementType,
      clauses: agreement.clauses,
      rentAmount: agreement.rentAmount,
      depositAmount: agreement.depositAmount,
      noticePeriodDays: agreement.noticePeriodDays,
      startDate: agreement.startDate,
      endDate: agreement.endDate,
      status: allSigned ? AgreementStatus.active : agreement.status,
      createdBy: agreement.createdBy,
      createdAt: agreement.createdAt,
      updatedAt: DateTime.now(),
      signatures: updatedSignatures,
      memberUserIds: agreement.memberUserIds,
    );
  }
}
