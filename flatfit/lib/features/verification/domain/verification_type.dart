import 'package:flutter/material.dart';

/// Available verification types on FlatFit.
enum VerificationType {
  phone,
  kyc,
  employerEmail,
  collegeEmail,
  linkedin;

  static VerificationType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'kyc':
        return VerificationType.kyc;
      case 'employer_email':
      case 'employeremail':
        return VerificationType.employerEmail;
      case 'college_email':
      case 'collegeemail':
        return VerificationType.collegeEmail;
      case 'linkedin':
        return VerificationType.linkedin;
      case 'phone':
      default:
        return VerificationType.phone;
    }
  }

  String toDbValue() {
    switch (this) {
      case VerificationType.phone:
        return 'phone';
      case VerificationType.kyc:
        return 'kyc';
      case VerificationType.employerEmail:
        return 'employer_email';
      case VerificationType.collegeEmail:
        return 'college_email';
      case VerificationType.linkedin:
        return 'linkedin';
    }
  }

  String get displayName {
    switch (this) {
      case VerificationType.phone:
        return 'Mobile Phone Verified';
      case VerificationType.kyc:
        return 'Government ID & Selfie KYC';
      case VerificationType.employerEmail:
        return 'Work Email Verification';
      case VerificationType.collegeEmail:
        return 'College / University Email';
      case VerificationType.linkedin:
        return 'LinkedIn Professional Profile';
    }
  }

  String get description {
    switch (this) {
      case VerificationType.phone:
        return 'Verified via OTP on mobile number';
      case VerificationType.kyc:
        return 'Aadhaar / Passport / DL with face liveness matching';
      case VerificationType.employerEmail:
        return 'Verify official work email (e.g. name@google.com)';
      case VerificationType.collegeEmail:
        return 'Verify academic email (e.g. student@iitb.ac.in)';
      case VerificationType.linkedin:
        return 'Confirm professional background and employment';
    }
  }

  int get trustPoints {
    switch (this) {
      case VerificationType.phone:
        return 10;
      case VerificationType.kyc:
        return 30;
      case VerificationType.employerEmail:
        return 10;
      case VerificationType.collegeEmail:
        return 10;
      case VerificationType.linkedin:
        return 10;
    }
  }

  IconData get icon {
    switch (this) {
      case VerificationType.phone:
        return Icons.phone_android;
      case VerificationType.kyc:
        return Icons.badge_outlined;
      case VerificationType.employerEmail:
        return Icons.work_outline;
      case VerificationType.collegeEmail:
        return Icons.school_outlined;
      case VerificationType.linkedin:
        return Icons.link;
    }
  }
}

/// Verification status for a user.
enum VerificationStatus {
  notStarted,
  pending,
  verified,
  failed;

  static VerificationStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'pending':
        return VerificationStatus.pending;
      case 'verified':
        return VerificationStatus.verified;
      case 'failed':
        return VerificationStatus.failed;
      case 'not_started':
      case 'notstarted':
      default:
        return VerificationStatus.notStarted;
    }
  }

  String toDbValue() => name;

  String get displayName {
    switch (this) {
      case VerificationStatus.notStarted:
        return 'Not Verified';
      case VerificationStatus.pending:
        return 'In Review';
      case VerificationStatus.verified:
        return 'Verified';
      case VerificationStatus.failed:
        return 'Verification Failed';
    }
  }

  Color get color {
    switch (this) {
      case VerificationStatus.verified:
        return const Color(0xFF0D9488);
      case VerificationStatus.pending:
        return const Color(0xFFD97706);
      case VerificationStatus.failed:
        return const Color(0xFFDC2626);
      case VerificationStatus.notStarted:
        return const Color(0xFF64748B);
    }
  }
}
