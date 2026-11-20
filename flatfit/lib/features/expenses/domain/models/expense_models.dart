import 'package:flutter/foundation.dart';

/// Categories of expenses matching the Supabase `expense_category` enum.
enum ExpenseCategory {
  rent,
  electricity,
  wifi,
  groceries,
  cook,
  maid,
  other,
}

/// Algorithm used to split an expense among flatmates.
enum SplitType {
  equal,
  customRatio,
  itemized,
}

/// Represents an item in an itemized bill (e.g. Swiggy Instamart or restaurant bill).
@immutable
class ItemizedEntry {
  final String itemName;
  final double amount;
  final List<String> assignedUserIds;

  const ItemizedEntry({
    required this.itemName,
    required this.amount,
    required this.assignedUserIds,
  });

  Map<String, dynamic> toJson() => {
        'item_name': itemName,
        'amount': amount,
        'assigned_user_ids': assignedUserIds,
      };

  factory ItemizedEntry.fromJson(Map<String, dynamic> json) {
    return ItemizedEntry(
      itemName: json['item_name'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      assignedUserIds: (json['assigned_user_ids'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}

/// Split record for an individual flatmate matching `expense_splits`.
@immutable
class ExpenseSplit {
  final String id;
  final String expenseId;
  final String userId;
  final String userName;
  final double amount;
  final bool isSettled;
  final DateTime? settledAt;

  const ExpenseSplit({
    required this.id,
    required this.expenseId,
    required this.userId,
    required this.userName,
    required this.amount,
    this.isSettled = false,
    this.settledAt,
  });

  factory ExpenseSplit.fromJson(Map<String, dynamic> json) {
    return ExpenseSplit(
      id: json['id'] as String? ?? '',
      expenseId: json['expense_id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      userName: json['user_name'] as String? ?? 'Flatmate',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      isSettled: json['is_settled'] as bool? ?? false,
      settledAt: json['settled_at'] != null
          ? DateTime.parse(json['settled_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'expense_id': expenseId,
      'user_id': userId,
      'user_name': userName,
      'amount': amount,
      'is_settled': isSettled,
      'settled_at': settledAt?.toIso8601String(),
    };
  }

  ExpenseSplit copyWith({
    String? id,
    String? expenseId,
    String? userId,
    String? userName,
    double? amount,
    bool? isSettled,
    DateTime? settledAt,
  }) {
    return ExpenseSplit(
      id: id ?? this.id,
      expenseId: expenseId ?? this.expenseId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      amount: amount ?? this.amount,
      isSettled: isSettled ?? this.isSettled,
      settledAt: settledAt ?? this.settledAt,
    );
  }
}

/// Master Expense model matching the Supabase `expenses` table.
@immutable
class Expense {
  final String id;
  final String flatId;
  final String paidByUserId;
  final String paidByName;
  final String title;
  final double amount;
  final ExpenseCategory category;
  final String? description;
  final String? receiptUrl;
  final DateTime date;
  final SplitType splitType;
  final List<ExpenseSplit> splits;
  final DateTime createdAt;

  const Expense({
    required this.id,
    required this.flatId,
    required this.paidByUserId,
    required this.paidByName,
    required this.title,
    required this.amount,
    required this.category,
    this.description,
    this.receiptUrl,
    required this.date,
    this.splitType = SplitType.equal,
    this.splits = const [],
    required this.createdAt,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    final rawSplits = json['splits'];
    List<ExpenseSplit> parsedSplits = [];
    if (rawSplits is List) {
      parsedSplits = rawSplits
          .whereType<Map<String, dynamic>>()
          .map((s) => ExpenseSplit.fromJson(s))
          .toList();
    }

    return Expense(
      id: json['id'] as String? ?? '',
      flatId: json['flat_id'] as String? ?? '',
      paidByUserId: json['paid_by'] as String? ?? '',
      paidByName: json['paid_by_name'] as String? ?? 'Flatmate',
      title: json['title'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      category: ExpenseCategory.values.firstWhere(
        (c) => c.name == (json['category'] as String?),
        orElse: () => ExpenseCategory.other,
      ),
      description: json['description'] as String?,
      receiptUrl: json['receipt_url'] as String?,
      date: json['date'] != null
          ? DateTime.parse(json['date'] as String)
          : DateTime.now(),
      splitType: SplitType.values.firstWhere(
        (s) => s.name == (json['split_type'] as String?),
        orElse: () => SplitType.equal,
      ),
      splits: parsedSplits,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'flat_id': flatId,
      'paid_by': paidByUserId,
      'paid_by_name': paidByName,
      'title': title,
      'amount': amount,
      'category': category.name,
      'description': description,
      'receipt_url': receiptUrl,
      'date': date.toIso8601String().split('T').first,
      'split_type': splitType.name,
      'splits': splits.map((s) => s.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}

/// Simplified peer-to-peer debt relationship.
@immutable
class SimplifiedDebt {
  final String fromUserId;
  final String fromUserName;
  final String toUserId;
  final String toUserName;
  final double amount;
  final String? toUserVpa;

  const SimplifiedDebt({
    required this.fromUserId,
    required this.fromUserName,
    required this.toUserId,
    required this.toUserName,
    required this.amount,
    this.toUserVpa,
  });
}

/// Rent collection status for flatmates.
@immutable
class FlatmateRentStatus {
  final String userId;
  final String userName;
  final double shareAmount;
  final bool isPaid;
  final DateTime? paidAt;
  final String? upiTransactionRef;

  const FlatmateRentStatus({
    required this.userId,
    required this.userName,
    required this.shareAmount,
    this.isPaid = false,
    this.paidAt,
    this.upiTransactionRef,
  });

  FlatmateRentStatus copyWith({
    String? userId,
    String? userName,
    double? shareAmount,
    bool? isPaid,
    DateTime? paidAt,
    String? upiTransactionRef,
  }) {
    return FlatmateRentStatus(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      shareAmount: shareAmount ?? this.shareAmount,
      isPaid: isPaid ?? this.isPaid,
      paidAt: paidAt ?? this.paidAt,
      upiTransactionRef: upiTransactionRef ?? this.upiTransactionRef,
    );
  }
}
