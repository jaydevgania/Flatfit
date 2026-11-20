import 'package:flutter/foundation.dart';

/// Categories of house notices posted by flatmates.
enum NoticeCategory {
  general,
  urgent,
  maintenance,
  partyOrGuests,
  applianceIssue,
  lostAndFound,
}

/// Notice model matching the Supabase `notices` table schema.
@immutable
class FlatNotice {
  final String id;
  final String flatId;
  final String userId;
  final String authorName;
  final String content;
  final bool isPinned;
  final NoticeCategory category;
  final DateTime createdAt;

  const FlatNotice({
    required this.id,
    required this.flatId,
    required this.userId,
    required this.authorName,
    required this.content,
    this.isPinned = false,
    this.category = NoticeCategory.general,
    required this.createdAt,
  });

  factory FlatNotice.fromJson(Map<String, dynamic> json) {
    return FlatNotice(
      id: json['id'] as String? ?? '',
      flatId: json['flat_id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      authorName: json['author_name'] as String? ?? 'Flatmate',
      content: json['content'] as String? ?? '',
      isPinned: json['is_pinned'] as bool? ?? false,
      category: NoticeCategory.values.firstWhere(
        (c) => c.name == (json['category'] as String?),
        orElse: () => NoticeCategory.general,
      ),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'flat_id': flatId,
      'user_id': userId,
      'author_name': authorName,
      'content': content,
      'is_pinned': isPinned,
      'category': category.name,
      'created_at': createdAt.toIso8601String(),
    };
  }

  FlatNotice copyWith({
    String? id,
    String? flatId,
    String? userId,
    String? authorName,
    String? content,
    bool? isPinned,
    NoticeCategory? category,
    DateTime? createdAt,
  }) {
    return FlatNotice(
      id: id ?? this.id,
      flatId: flatId ?? this.flatId,
      userId: userId ?? this.userId,
      authorName: authorName ?? this.authorName,
      content: content ?? this.content,
      isPinned: isPinned ?? this.isPinned,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// Calendar event types matching the Supabase `calendar_events` table.
enum CalendarEventType {
  guest,
  party,
  maintenance,
  powerCut,
  maidOff,
  cleaning,
  other,
}

/// Calendar event for shared house awareness.
@immutable
class HubCalendarEvent {
  final String id;
  final String flatId;
  final String userId;
  final String creatorName;
  final String title;
  final String? description;
  final CalendarEventType type;
  final DateTime startTime;
  final DateTime? endTime;
  final bool isAllDay;
  final DateTime createdAt;

  const HubCalendarEvent({
    required this.id,
    required this.flatId,
    required this.userId,
    required this.creatorName,
    required this.title,
    this.description,
    this.type = CalendarEventType.other,
    required this.startTime,
    this.endTime,
    this.isAllDay = false,
    required this.createdAt,
  });

  factory HubCalendarEvent.fromJson(Map<String, dynamic> json) {
    return HubCalendarEvent(
      id: json['id'] as String? ?? '',
      flatId: json['flat_id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      creatorName: json['creator_name'] as String? ?? 'Flatmate',
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      type: CalendarEventType.values.firstWhere(
        (t) => t.name == (json['type'] as String?),
        orElse: () => CalendarEventType.other,
      ),
      startTime: json['start_time'] != null
          ? DateTime.parse(json['start_time'] as String)
          : DateTime.now(),
      endTime: json['end_time'] != null
          ? DateTime.parse(json['end_time'] as String)
          : null,
      isAllDay: json['is_all_day'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'flat_id': flatId,
      'user_id': userId,
      'creator_name': creatorName,
      'title': title,
      'description': description,
      'type': type.name,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'is_all_day': isAllDay,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

/// Category of grocery items for smart grouping.
enum GroceryCategory {
  dairyAndEggs,
  vegetablesAndFruits,
  pantryAndSpices,
  cleaningAndToiletries,
  snacksAndBeverages,
  waterAndGas,
}

/// Shared house grocery item matching the Supabase `grocery_items` table.
@immutable
class GroceryItem {
  final String id;
  final String flatId;
  final String name;
  final String? quantity;
  final GroceryCategory category;
  final String addedByUserId;
  final String addedByName;
  final bool isBought;
  final String? boughtByUserId;
  final String? boughtByName;
  final double? estimatedCost;
  final DateTime createdAt;

  const GroceryItem({
    required this.id,
    required this.flatId,
    required this.name,
    this.quantity,
    this.category = GroceryCategory.pantryAndSpices,
    required this.addedByUserId,
    required this.addedByName,
    this.isBought = false,
    this.boughtByUserId,
    this.boughtByName,
    this.estimatedCost,
    required this.createdAt,
  });

  factory GroceryItem.fromJson(Map<String, dynamic> json) {
    return GroceryItem(
      id: json['id'] as String? ?? '',
      flatId: json['flat_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      quantity: json['quantity'] as String?,
      category: GroceryCategory.values.firstWhere(
        (c) => c.name == (json['category'] as String?),
        orElse: () => GroceryCategory.pantryAndSpices,
      ),
      addedByUserId: json['added_by'] as String? ?? '',
      addedByName: json['added_by_name'] as String? ?? 'Flatmate',
      isBought: json['is_bought'] as bool? ?? false,
      boughtByUserId: json['bought_by'] as String?,
      boughtByName: json['bought_by_name'] as String?,
      estimatedCost: (json['estimated_cost'] as num?)?.toDouble(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'flat_id': flatId,
      'name': name,
      'quantity': quantity,
      'category': category.name,
      'added_by': addedByUserId,
      'added_by_name': addedByName,
      'is_bought': isBought,
      'bought_by': boughtByUserId,
      'bought_by_name': boughtByName,
      'estimated_cost': estimatedCost,
      'created_at': createdAt.toIso8601String(),
    };
  }

  GroceryItem copyWith({
    String? id,
    String? flatId,
    String? name,
    String? quantity,
    GroceryCategory? category,
    String? addedByUserId,
    String? addedByName,
    bool? isBought,
    String? boughtByUserId,
    String? boughtByName,
    double? estimatedCost,
    DateTime? createdAt,
  }) {
    return GroceryItem(
      id: id ?? this.id,
      flatId: flatId ?? this.flatId,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
      addedByUserId: addedByUserId ?? this.addedByUserId,
      addedByName: addedByName ?? this.addedByName,
      isBought: isBought ?? this.isBought,
      boughtByUserId: boughtByUserId ?? this.boughtByUserId,
      boughtByName: boughtByName ?? this.boughtByName,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// House inventory / appliance purchase log matching `house_inventory`.
@immutable
class ApplianceMemoryItem {
  final String id;
  final String flatId;
  final String itemName;
  final String? brandAndModel;
  final String? description;
  final String? boughtByUserId;
  final String? boughtByName;
  final double? cost;
  final DateTime? purchaseDate;
  final DateTime? warrantyExpiry;
  final String? billReceiptUrl;
  final String? technicianContact;
  final String condition; // 'excellent', 'good', 'needs_servicing'
  final DateTime createdAt;

  const ApplianceMemoryItem({
    required this.id,
    required this.flatId,
    required this.itemName,
    this.brandAndModel,
    this.description,
    this.boughtByUserId,
    this.boughtByName,
    this.cost,
    this.purchaseDate,
    this.warrantyExpiry,
    this.billReceiptUrl,
    this.technicianContact,
    this.condition = 'good',
    required this.createdAt,
  });

  bool get isUnderWarranty {
    if (warrantyExpiry == null) return false;
    return warrantyExpiry!.isAfter(DateTime.now());
  }

  int? get warrantyDaysRemaining {
    if (warrantyExpiry == null) return null;
    final diff = warrantyExpiry!.difference(DateTime.now()).inDays;
    return diff > 0 ? diff : 0;
  }

  factory ApplianceMemoryItem.fromJson(Map<String, dynamic> json) {
    return ApplianceMemoryItem(
      id: json['id'] as String? ?? '',
      flatId: json['flat_id'] as String? ?? '',
      itemName: json['item_name'] as String? ?? '',
      brandAndModel: json['brand_and_model'] as String?,
      description: json['description'] as String?,
      boughtByUserId: json['bought_by'] as String?,
      boughtByName: json['bought_by_name'] as String?,
      cost: (json['cost'] as num?)?.toDouble(),
      purchaseDate: json['purchase_date'] != null
          ? DateTime.parse(json['purchase_date'] as String)
          : null,
      warrantyExpiry: json['warranty_expiry'] != null
          ? DateTime.parse(json['warranty_expiry'] as String)
          : null,
      billReceiptUrl: json['bill_receipt_url'] as String?,
      technicianContact: json['technician_contact'] as String?,
      condition: json['condition'] as String? ?? 'good',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'flat_id': flatId,
      'item_name': itemName,
      'brand_and_model': brandAndModel,
      'description': description,
      'bought_by': boughtByUserId,
      'bought_by_name': boughtByName,
      'cost': cost,
      'purchase_date': purchaseDate?.toIso8601String().split('T').first,
      'warranty_expiry': warrantyExpiry?.toIso8601String().split('T').first,
      'bill_receipt_url': billReceiptUrl,
      'technician_contact': technicianContact,
      'condition': condition,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
