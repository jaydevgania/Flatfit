import 'package:flutter/foundation.dart';

/// Area or room category in the flat for move-in inspection.
enum ChecklistArea {
  bedroom,
  bathroom,
  kitchen,
  livingRoom,
  appliances,
  doorsWindowsKeys,
  utilityMeters,
}

/// Physical condition of an item during move-in.
enum ItemCondition {
  excellent,
  good,
  minorWear,
  needsRepair,
  damaged,
  missing,
}

/// Individual item in the move-in inspection checklist.
@immutable
class MoveInChecklistItem {
  final String id;
  final String agreementId;
  final String userId;
  final String item;
  final ChecklistArea area;
  final ItemCondition condition;
  final String? notes;
  final List<String> photoUrls;
  final bool isCompleted;
  final DateTime? completedAt;
  final DateTime? dueDate;

  const MoveInChecklistItem({
    required this.id,
    required this.agreementId,
    required this.userId,
    required this.item,
    required this.area,
    this.condition = ItemCondition.good,
    this.notes,
    this.photoUrls = const [],
    this.isCompleted = false,
    this.completedAt,
    this.dueDate,
  });

  factory MoveInChecklistItem.fromJson(Map<String, dynamic> json) {
    return MoveInChecklistItem(
      id: json['id'] as String? ?? '',
      agreementId: json['agreement_id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      item: json['item'] as String? ?? '',
      area: ChecklistArea.values.firstWhere(
        (a) => a.name == (json['area'] as String?),
        orElse: () => ChecklistArea.bedroom,
      ),
      condition: ItemCondition.values.firstWhere(
        (c) => c.name == (json['condition'] as String?),
        orElse: () => ItemCondition.good,
      ),
      notes: json['notes'] as String?,
      photoUrls: (json['photo_urls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      isCompleted: json['is_completed'] as bool? ?? false,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      dueDate: json['due_date'] != null
          ? DateTime.parse(json['due_date'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'agreement_id': agreementId,
      'user_id': userId,
      'item': item,
      'area': area.name,
      'condition': condition.name,
      'notes': notes,
      'photo_urls': photoUrls,
      'is_completed': isCompleted,
      'completed_at': completedAt?.toIso8601String(),
      'due_date': dueDate?.toIso8601String().split('T').first,
    };
  }

  MoveInChecklistItem copyWith({
    String? id,
    String? agreementId,
    String? userId,
    String? item,
    ChecklistArea? area,
    ItemCondition? condition,
    String? notes,
    List<String>? photoUrls,
    bool? isCompleted,
    DateTime? completedAt,
    DateTime? dueDate,
  }) {
    return MoveInChecklistItem(
      id: id ?? this.id,
      agreementId: agreementId ?? this.agreementId,
      userId: userId ?? this.userId,
      item: item ?? this.item,
      area: area ?? this.area,
      condition: condition ?? this.condition,
      notes: notes ?? this.notes,
      photoUrls: photoUrls ?? this.photoUrls,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}

/// Initial utility meter readings recorded on move-in day.
@immutable
class MoveInMeterReading {
  final String meterType; // 'Electricity (MSEB/BESCOM/BSES)', 'Piped Gas (MGL/IGL)', 'Water'
  final String meterNumber;
  final double initialReading;
  final String unit; // 'kWh', 'SCM', 'kL'
  final String? meterPhotoUrl;
  final DateTime recordedDate;

  const MoveInMeterReading({
    required this.meterType,
    required this.meterNumber,
    required this.initialReading,
    required this.unit,
    this.meterPhotoUrl,
    required this.recordedDate,
  });

  Map<String, dynamic> toJson() => {
        'meter_type': meterType,
        'meter_number': meterNumber,
        'initial_reading': initialReading,
        'unit': unit,
        'meter_photo_url': meterPhotoUrl,
        'recorded_date': recordedDate.toIso8601String(),
      };
}
