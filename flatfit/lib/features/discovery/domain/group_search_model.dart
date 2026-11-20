import 'package:flutter/foundation.dart';
import 'package:flatfit/features/matching/domain/profile.dart';

@immutable
class GroupMemberModel {
  final String id;
  final String groupId;
  final String userId;
  final DateTime joinedAt;
  final Profile? profile;

  const GroupMemberModel({
    required this.id,
    required this.groupId,
    required this.userId,
    required this.joinedAt,
    this.profile,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'group_id': groupId,
    'user_id': userId,
    'joined_at': joinedAt.toIso8601String(),
  };

  factory GroupMemberModel.fromJson(Map<String, dynamic> json) {
    return GroupMemberModel(
      id: json['id'] as String? ?? '',
      groupId: json['group_id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      joinedAt: json['joined_at'] != null
          ? DateTime.tryParse(json['joined_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      profile: json['profile'] != null && json['profile'] is Map
          ? Profile.fromJson(Map<String, dynamic>.from(json['profile'] as Map))
          : null,
    );
  }
}

/// Represents a search group where 2 to 4 friends search for a flat together.
@immutable
class GroupSearchModel {
  final String id;
  final String name;
  final String? description;
  final String createdBy;
  final int maxMembers;
  final List<GroupMemberModel> members;
  final double combinedBudgetMin;
  final double combinedBudgetMax;
  final List<String> preferredLocalities;
  final DateTime createdAt;

  const GroupSearchModel({
    required this.id,
    required this.name,
    this.description,
    required this.createdBy,
    this.maxMembers = 4,
    this.members = const [],
    this.combinedBudgetMin = 30000,
    this.combinedBudgetMax = 70000,
    this.preferredLocalities = const ['Bandra West', 'Andheri West'],
    required this.createdAt,
  });

  int get memberCount => members.length;
  bool get isFull => members.length >= maxMembers;

  GroupSearchModel copyWith({
    String? id,
    String? name,
    String? description,
    String? createdBy,
    int? maxMembers,
    List<GroupMemberModel>? members,
    double? combinedBudgetMin,
    double? combinedBudgetMax,
    List<String>? preferredLocalities,
    DateTime? createdAt,
  }) {
    return GroupSearchModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdBy: createdBy ?? this.createdBy,
      maxMembers: maxMembers ?? this.maxMembers,
      members: members ?? this.members,
      combinedBudgetMin: combinedBudgetMin ?? this.combinedBudgetMin,
      combinedBudgetMax: combinedBudgetMax ?? this.combinedBudgetMax,
      preferredLocalities: preferredLocalities ?? this.preferredLocalities,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'created_by': createdBy,
    'max_members': maxMembers,
    'combined_budget_min': combinedBudgetMin,
    'combined_budget_max': combinedBudgetMax,
    'preferred_localities': preferredLocalities,
    'created_at': createdAt.toIso8601String(),
  };

  factory GroupSearchModel.fromJson(Map<String, dynamic> json) {
    final rawMembers = json['group_members'] as List<dynamic>?;
    final parsedMembers = rawMembers != null
        ? rawMembers
            .map((m) => GroupMemberModel.fromJson(Map<String, dynamic>.from(m as Map)))
            .toList()
        : <GroupMemberModel>[];

    return GroupSearchModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Flat Hunt Squad',
      description: json['description'] as String?,
      createdBy: json['created_by'] as String? ?? '',
      maxMembers: json['max_members'] as int? ?? 4,
      members: parsedMembers,
      combinedBudgetMin: (json['combined_budget_min'] as num?)?.toDouble() ?? 30000.0,
      combinedBudgetMax: (json['combined_budget_max'] as num?)?.toDouble() ?? 70000.0,
      preferredLocalities: (json['preferred_localities'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const ['Bandra West', 'Andheri West'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
