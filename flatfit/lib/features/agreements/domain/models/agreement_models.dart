import 'package:flutter/foundation.dart';

/// Status of an agreement between flatmates.
enum AgreementStatus {
  draft,
  active,
  terminated,
}

/// Type of co-living agreement.
enum AgreementType {
  fullStay,
  trialWeek,
  dayTrial,
}

/// Category of an agreement clause.
enum ClauseCategory {
  rentAndDeposit,
  quietHours,
  guestsAndVisitors,
  choresAndCleanliness,
  utilityBills,
  noticePeriod,
  exitAndDepositReturn,
  petsAndSmoking,
  foodAndKitchen,
  disputeResolution,
}

/// Represents an individual clause in a flatmate agreement.
@immutable
class AgreementClause {
  final String id;
  final String title;
  final String description;
  final ClauseCategory category;
  final double? amount;
  final bool isMandatory;
  final bool isCustom;

  const AgreementClause({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.amount,
    this.isMandatory = false,
    this.isCustom = false,
  });

  factory AgreementClause.fromJson(Map<String, dynamic> json) {
    return AgreementClause(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: ClauseCategory.values.firstWhere(
        (c) => c.name == (json['category'] as String?),
        orElse: () => ClauseCategory.rentAndDeposit,
      ),
      amount: (json['amount'] as num?)?.toDouble(),
      isMandatory: json['is_mandatory'] as bool? ?? false,
      isCustom: json['is_custom'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category.name,
      'amount': amount,
      'is_mandatory': isMandatory,
      'is_custom': isCustom,
    };
  }

  AgreementClause copyWith({
    String? id,
    String? title,
    String? description,
    ClauseCategory? category,
    double? amount,
    bool? isMandatory,
    bool? isCustom,
  }) {
    return AgreementClause(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      isMandatory: isMandatory ?? this.isMandatory,
      isCustom: isCustom ?? this.isCustom,
    );
  }
}

/// Represents a digital signature on an agreement.
@immutable
class AgreementSignature {
  final String id;
  final String agreementId;
  final String userId;
  final String userName;
  final DateTime signedAt;
  final String? ipAddress;
  final String? signatureHash;
  final String? signatureSvgOrBase64;

  const AgreementSignature({
    required this.id,
    required this.agreementId,
    required this.userId,
    required this.userName,
    required this.signedAt,
    this.ipAddress,
    this.signatureHash,
    this.signatureSvgOrBase64,
  });

  factory AgreementSignature.fromJson(Map<String, dynamic> json) {
    return AgreementSignature(
      id: json['id'] as String? ?? '',
      agreementId: json['agreement_id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      userName: json['user_name'] as String? ?? 'Flatmate',
      signedAt: json['signed_at'] != null
          ? DateTime.parse(json['signed_at'] as String)
          : DateTime.now(),
      ipAddress: json['ip_address'] as String?,
      signatureHash: json['signature_hash'] as String?,
      signatureSvgOrBase64: json['signature_svg_or_base64'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'agreement_id': agreementId,
      'user_id': userId,
      'user_name': userName,
      'signed_at': signedAt.toIso8601String(),
      'ip_address': ipAddress,
      'signature_hash': signatureHash,
      'signature_svg_or_base64': signatureSvgOrBase64,
    };
  }
}

/// Represents a co-living Flatmate Agreement.
@immutable
class FlatmateAgreement {
  final String id;
  final String? flatId;
  final String title;
  final String? description;
  final AgreementType agreementType;
  final List<AgreementClause> clauses;
  final double? rentAmount;
  final double? depositAmount;
  final int noticePeriodDays;
  final DateTime? startDate;
  final DateTime? endDate;
  final AgreementStatus status;
  final String? createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<AgreementSignature> signatures;
  final List<String> memberUserIds;

  const FlatmateAgreement({
    required this.id,
    this.flatId,
    required this.title,
    this.description,
    this.agreementType = AgreementType.fullStay,
    this.clauses = const [],
    this.rentAmount,
    this.depositAmount,
    this.noticePeriodDays = 30,
    this.startDate,
    this.endDate,
    this.status = AgreementStatus.draft,
    this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.signatures = const [],
    this.memberUserIds = const [],
  });

  bool isFullySigned() {
    if (memberUserIds.isEmpty) return signatures.isNotEmpty;
    return memberUserIds.every((uid) => signatures.any((s) => s.userId == uid));
  }

  bool isSignedByUser(String userId) {
    return signatures.any((s) => s.userId == userId);
  }

  factory FlatmateAgreement.fromJson(Map<String, dynamic> json) {
    final rawClauses = json['clauses'];
    List<AgreementClause> parsedClauses = [];
    if (rawClauses is List) {
      parsedClauses = rawClauses
          .whereType<Map<String, dynamic>>()
          .map((c) => AgreementClause.fromJson(c))
          .toList();
    }

    final rawSigs = json['signatures'];
    List<AgreementSignature> parsedSigs = [];
    if (rawSigs is List) {
      parsedSigs = rawSigs
          .whereType<Map<String, dynamic>>()
          .map((s) => AgreementSignature.fromJson(s))
          .toList();
    }

    return FlatmateAgreement(
      id: json['id'] as String? ?? '',
      flatId: json['flat_id'] as String?,
      title: json['title'] as String? ?? 'Flatmate Living Agreement',
      description: json['description'] as String?,
      agreementType: AgreementType.values.firstWhere(
        (t) => t.name == (json['agreement_type'] as String?),
        orElse: () => AgreementType.fullStay,
      ),
      clauses: parsedClauses,
      rentAmount: (json['rent_amount'] as num?)?.toDouble(),
      depositAmount: (json['deposit_amount'] as num?)?.toDouble(),
      noticePeriodDays: json['notice_period_days'] as int? ?? 30,
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'] as String)
          : null,
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'] as String)
          : null,
      status: AgreementStatus.values.firstWhere(
        (s) => s.name == (json['status'] as String?),
        orElse: () => AgreementStatus.draft,
      ),
      createdBy: json['created_by'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
      signatures: parsedSigs,
      memberUserIds: (json['member_user_ids'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'flat_id': flatId,
      'title': title,
      'description': description,
      'agreement_type': agreementType.name,
      'clauses': clauses.map((c) => c.toJson()).toList(),
      'rent_amount': rentAmount,
      'deposit_amount': depositAmount,
      'notice_period_days': noticePeriodDays,
      'start_date': startDate?.toIso8601String().split('T').first,
      'end_date': endDate?.toIso8601String().split('T').first,
      'status': status.name,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'signatures': signatures.map((s) => s.toJson()).toList(),
      'member_user_ids': memberUserIds,
    };
  }
}
