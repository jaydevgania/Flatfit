import 'package:flutter/foundation.dart';

/// Phase of the co-living exit process.
enum ExitPhase {
  noticeGiven,
  findingReplacement,
  damageInspection,
  depositSettlement,
  handoverCompleted,
}

/// Details of a flatmate's formal exit notice.
@immutable
class ExitRequest {
  final String id;
  final String flatId;
  final String userId;
  final String userName;
  final String roomName;
  final DateTime noticeDate;
  final DateTime plannedExitDate;
  final String? reason;
  final ExitPhase currentPhase;
  final double securityDepositHeld;
  final String? refundVpa;
  final DateTime createdAt;

  const ExitRequest({
    required this.id,
    required this.flatId,
    required this.userId,
    required this.userName,
    required this.roomName,
    required this.noticeDate,
    required this.plannedExitDate,
    this.reason,
    this.currentPhase = ExitPhase.noticeGiven,
    required this.securityDepositHeld,
    this.refundVpa,
    required this.createdAt,
  });

  int get daysRemainingInNotice {
    final diff = plannedExitDate.difference(DateTime.now()).inDays;
    return diff > 0 ? diff : 0;
  }

  ExitRequest copyWith({
    String? id,
    String? flatId,
    String? userId,
    String? userName,
    String? roomName,
    DateTime? noticeDate,
    DateTime? plannedExitDate,
    String? reason,
    ExitPhase? currentPhase,
    double? securityDepositHeld,
    String? refundVpa,
    DateTime? createdAt,
  }) {
    return ExitRequest(
      id: id ?? this.id,
      flatId: flatId ?? this.flatId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      roomName: roomName ?? this.roomName,
      noticeDate: noticeDate ?? this.noticeDate,
      plannedExitDate: plannedExitDate ?? this.plannedExitDate,
      reason: reason ?? this.reason,
      currentPhase: currentPhase ?? this.currentPhase,
      securityDepositHeld: securityDepositHeld ?? this.securityDepositHeld,
      refundVpa: refundVpa ?? this.refundVpa,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// Room vacancy post created when finding a replacement flatmate.
@immutable
class RoomVacancyPost {
  final String id;
  final String flatId;
  final String roomTitle;
  final String roomType; // 'Master with Attached Bath', 'Private Room', 'Shared Twin'
  final double monthlyRent;
  final double securityDeposit;
  final DateTime availableFromDate;
  final List<String> roomAmenities;
  final String currentFlatmatesBio;
  final String preferredFlatmateGender; // 'Any', 'Female', 'Male'
  final List<String> photoUrls;
  final bool isVerifiedListing;
  final bool isPublished;

  const RoomVacancyPost({
    required this.id,
    required this.flatId,
    required this.roomTitle,
    required this.roomType,
    required this.monthlyRent,
    required this.securityDeposit,
    required this.availableFromDate,
    this.roomAmenities = const [],
    required this.currentFlatmatesBio,
    this.preferredFlatmateGender = 'Any',
    this.photoUrls = const [],
    this.isVerifiedListing = true,
    this.isPublished = true,
  });
}

/// Item in the move-out damage inspection.
@immutable
class DamageInspectionItem {
  final String id;
  final String area;
  final String itemDescription;
  final bool isNormalWearAndTear; // Under Indian tenancy law, wear & tear cannot be deducted
  final double estimatedRepairCost;
  final String? photoUrl;
  final bool isDeducted;

  const DamageInspectionItem({
    required this.id,
    required this.area,
    required this.itemDescription,
    this.isNormalWearAndTear = false,
    this.estimatedRepairCost = 0.0,
    this.photoUrl,
    this.isDeducted = false,
  });

  DamageInspectionItem copyWith({
    String? id,
    String? area,
    String? itemDescription,
    bool? isNormalWearAndTear,
    double? estimatedRepairCost,
    String? photoUrl,
    bool? isDeducted,
  }) {
    return DamageInspectionItem(
      id: id ?? this.id,
      area: area ?? this.area,
      itemDescription: itemDescription ?? this.itemDescription,
      isNormalWearAndTear: isNormalWearAndTear ?? this.isNormalWearAndTear,
      estimatedRepairCost: estimatedRepairCost ?? this.estimatedRepairCost,
      photoUrl: photoUrl ?? this.photoUrl,
      isDeducted: isDeducted ?? this.isDeducted,
    );
  }
}

/// Itemized deposit settlement calculation.
@immutable
class DepositSettlement {
  final String id;
  final String exitRequestId;
  final double originalDeposit;
  final double unpaidRentDeduction;
  final double unpaidUtilityBillsDeduction;
  final double damageDeductions;
  final double cleaningDeduction;
  final double netRefundAmount;
  final DateTime refundDueBy;
  final String recipientVpa;
  final bool isRefunded;
  final String? transactionRef;

  const DepositSettlement({
    required this.id,
    required this.exitRequestId,
    required this.originalDeposit,
    this.unpaidRentDeduction = 0.0,
    this.unpaidUtilityBillsDeduction = 0.0,
    this.damageDeductions = 0.0,
    this.cleaningDeduction = 0.0,
    required this.netRefundAmount,
    required this.refundDueBy,
    required this.recipientVpa,
    this.isRefunded = false,
    this.transactionRef,
  });

  DepositSettlement copyWith({
    String? id,
    String? exitRequestId,
    double? originalDeposit,
    double? unpaidRentDeduction,
    double? unpaidUtilityBillsDeduction,
    double? damageDeductions,
    double? cleaningDeduction,
    double? netRefundAmount,
    DateTime? refundDueBy,
    String? recipientVpa,
    bool? isRefunded,
    String? transactionRef,
  }) {
    return DepositSettlement(
      id: id ?? this.id,
      exitRequestId: exitRequestId ?? this.exitRequestId,
      originalDeposit: originalDeposit ?? this.originalDeposit,
      unpaidRentDeduction: unpaidRentDeduction ?? this.unpaidRentDeduction,
      unpaidUtilityBillsDeduction: unpaidUtilityBillsDeduction ?? this.unpaidUtilityBillsDeduction,
      damageDeductions: damageDeductions ?? this.damageDeductions,
      cleaningDeduction: cleaningDeduction ?? this.cleaningDeduction,
      netRefundAmount: netRefundAmount ?? this.netRefundAmount,
      refundDueBy: refundDueBy ?? this.refundDueBy,
      recipientVpa: recipientVpa ?? this.recipientVpa,
      isRefunded: isRefunded ?? this.isRefunded,
      transactionRef: transactionRef ?? this.transactionRef,
    );
  }
}

/// Handover item in the exit protocol.
@immutable
class HandoverItem {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime? completedAt;

  const HandoverItem({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.completedAt,
  });

  HandoverItem copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return HandoverItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
