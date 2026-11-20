class ItemizedEntry {
  final String itemName;
  final double amount;
  final List<String> assignedUserIds;

  const ItemizedEntry({
    required this.itemName,
    required this.amount,
    required this.assignedUserIds,
  });
}

class DebtTransfer {
  final String fromUserId;
  final String toUserId;
  final double amount;

  const DebtTransfer({
    required this.fromUserId,
    required this.toUserId,
    required this.amount,
  });
}
