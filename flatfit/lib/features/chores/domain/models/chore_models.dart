import 'package:flutter/foundation.dart';

/// Chore frequencies matching the Supabase `chore_frequency` enum.
enum ChoreFrequency {
  daily,
  weekly,
  monthly,
}

/// Effort points associated with chores for balanced fairness scoring.
enum ChoreEffort {
  light, // 1 point: e.g. Take out trash, water indoor plants
  medium, // 2 points: e.g. Wipe kitchen counters, clean dining table & sink
  heavy, // 3 points: e.g. Deep clean bathroom, mop entire flat, clean fridge
}

extension ChoreEffortExt on ChoreEffort {
  int get points {
    switch (this) {
      case ChoreEffort.light:
        return 1;
      case ChoreEffort.medium:
        return 2;
      case ChoreEffort.heavy:
        return 3;
    }
  }

  String get label {
    switch (this) {
      case ChoreEffort.light:
        return 'Light (1 pt)';
      case ChoreEffort.medium:
        return 'Medium (2 pts)';
      case ChoreEffort.heavy:
        return 'Heavy (3 pts)';
    }
  }
}

/// Master Chore template matching the Supabase `chores` table.
@immutable
class Chore {
  final String id;
  final String flatId;
  final String title;
  final String? description;
  final ChoreFrequency frequency;
  final ChoreEffort effort;
  final String? icon;
  final List<String> rotationUserIds;
  final DateTime createdAt;

  const Chore({
    required this.id,
    required this.flatId,
    required this.title,
    this.description,
    this.frequency = ChoreFrequency.weekly,
    this.effort = ChoreEffort.medium,
    this.icon,
    this.rotationUserIds = const [],
    required this.createdAt,
  });

  factory Chore.fromJson(Map<String, dynamic> json) {
    return Chore(
      id: json['id'] as String? ?? '',
      flatId: json['flat_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      frequency: ChoreFrequency.values.firstWhere(
        (f) => f.name == (json['frequency'] as String?),
        orElse: () => ChoreFrequency.weekly,
      ),
      effort: ChoreEffort.values.firstWhere(
        (e) => e.name == (json['effort'] as String?),
        orElse: () => ChoreEffort.medium,
      ),
      icon: json['icon'] as String?,
      rotationUserIds: (json['rotation_user_ids'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'flat_id': flatId,
      'title': title,
      'description': description,
      'frequency': frequency.name,
      'effort': effort.name,
      'icon': icon,
      'rotation_user_ids': rotationUserIds,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

/// An assigned occurrence of a chore matching `chore_assignments`.
@immutable
class ChoreAssignment {
  final String id;
  final String choreId;
  final String choreTitle;
  final String userId;
  final String userName;
  final DateTime dueDate;
  final DateTime? completedAt;
  final int effortPoints;
  final ChoreEffort effort;
  final DateTime createdAt;

  const ChoreAssignment({
    required this.id,
    required this.choreId,
    required this.choreTitle,
    required this.userId,
    required this.userName,
    required this.dueDate,
    this.completedAt,
    this.effortPoints = 1,
    this.effort = ChoreEffort.medium,
    required this.createdAt,
  });

  bool get isCompleted => completedAt != null;

  bool get isOverdue {
    if (isCompleted) return false;
    final today = DateTime.now();
    return dueDate.isBefore(DateTime(today.year, today.month, today.day));
  }

  factory ChoreAssignment.fromJson(Map<String, dynamic> json) {
    return ChoreAssignment(
      id: json['id'] as String? ?? '',
      choreId: json['chore_id'] as String? ?? '',
      choreTitle: json['chore_title'] as String? ?? 'Chore',
      userId: json['user_id'] as String? ?? '',
      userName: json['user_name'] as String? ?? 'Flatmate',
      dueDate: json['due_date'] != null
          ? DateTime.parse(json['due_date'] as String)
          : DateTime.now(),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      effortPoints: json['effort_points'] as int? ?? 1,
      effort: ChoreEffort.values.firstWhere(
        (e) => e.name == (json['effort'] as String?),
        orElse: () => ChoreEffort.medium,
      ),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chore_id': choreId,
      'chore_title': choreTitle,
      'user_id': userId,
      'user_name': userName,
      'due_date': dueDate.toIso8601String().split('T').first,
      'completed_at': completedAt?.toIso8601String(),
      'effort_points': effortPoints,
      'effort': effort.name,
      'created_at': createdAt.toIso8601String(),
    };
  }

  ChoreAssignment copyWith({
    String? id,
    String? choreId,
    String? choreTitle,
    String? userId,
    String? userName,
    DateTime? dueDate,
    DateTime? completedAt,
    int? effortPoints,
    ChoreEffort? effort,
    DateTime? createdAt,
  }) {
    return ChoreAssignment(
      id: id ?? this.id,
      choreId: choreId ?? this.choreId,
      choreTitle: choreTitle ?? this.choreTitle,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      dueDate: dueDate ?? this.dueDate,
      completedAt: completedAt ?? this.completedAt,
      effortPoints: effortPoints ?? this.effortPoints,
      effort: effort ?? this.effort,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// Fairness stats for an individual flatmate.
@immutable
class FlatmateChoreStat {
  final String userId;
  final String userName;
  final int completedPoints;
  final int completedCount;
  final int pendingCount;
  final int overdueCount;

  const FlatmateChoreStat({
    required this.userId,
    required this.userName,
    required this.completedPoints,
    required this.completedCount,
    required this.pendingCount,
    required this.overdueCount,
  });
}

/// Overall house fairness report.
@immutable
class ChoreFairnessReport {
  final double harmonyScore; // 0.0 to 100.0%
  final List<FlatmateChoreStat> flatmateStats;
  final int totalHousePointsCompleted;

  const ChoreFairnessReport({
    required this.harmonyScore,
    required this.flatmateStats,
    required this.totalHousePointsCompleted,
  });
}
