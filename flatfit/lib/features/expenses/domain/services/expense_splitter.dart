import '../models/expense_models.dart';

class ExpenseSplitter {
  static Map<String, double> calculateEqualSplit({
    required double totalAmount,
    required List<String> userIds,
  }) {
    if (userIds.isEmpty) return {};
    final paise = (totalAmount * 100).round();
    final base = paise ~/ userIds.length;
    final remainder = paise - base * userIds.length;
    final result = <String, double>{};
    for (var i = 0; i < userIds.length; i++) {
      result[userIds[i]] = (base + (i < remainder ? 1 : 0)) / 100;
    }
    return result;
  }

  static Map<String, double> calculateRatioSplit({
    required double totalAmount,
    required Map<String, double> ratios,
  }) {
    final total = ratios.values.fold<double>(0, (sum, value) => sum + value);
    if (total == 0) return {for (final id in ratios.keys) id: 0};
    return {
      for (final entry in ratios.entries)
        entry.key: totalAmount * entry.value / total,
    };
  }

  static Map<String, double> calculateItemizedSplit({
    required List<ItemizedEntry> items,
    required double sharedTaxesAndFees,
  }) {
    final subtotal = <String, double>{};
    var itemTotal = 0.0;
    for (final item in items) {
      itemTotal += item.amount;
      if (item.assignedUserIds.isNotEmpty) {
        final share = item.amount / item.assignedUserIds.length;
        for (final id in item.assignedUserIds) {
          subtotal[id] = (subtotal[id] ?? 0) + share;
        }
      }
    }
    if (itemTotal == 0) return subtotal;
    return {
      for (final entry in subtotal.entries)
        entry.key: entry.value +
            (entry.value / itemTotal) * sharedTaxesAndFees,
    };
  }

  static List<DebtTransfer> simplifyDebts(
    Map<String, Map<String, double>> pairwise,
  ) {
    final balances = <String, double>{};
    for (final from in pairwise.keys) {
      for (final entry in pairwise[from]!.entries) {
        balances[from] = (balances[from] ?? 0) - entry.value;
        balances[entry.key] = (balances[entry.key] ?? 0) + entry.value;
      }
    }
    final debtors = balances.entries
        .where((e) => e.value < -0.0001)
        .map((e) => MapEntry(e.key, -e.value))
        .toList();
    final creditors = balances.entries
        .where((e) => e.value > 0.0001)
        .map((e) => MapEntry(e.key, e.value))
        .toList();
    final transfers = <DebtTransfer>[];
    var i = 0, j = 0;
    while (i < debtors.length && j < creditors.length) {
      final amount = debtors[i].value < creditors[j].value
          ? debtors[i].value
          : creditors[j].value;
      transfers.add(DebtTransfer(
        fromUserId: debtors[i].key,
        toUserId: creditors[j].key,
        amount: amount,
      ));
      debtors[i] = MapEntry(debtors[i].key, debtors[i].value - amount);
      creditors[j] = MapEntry(creditors[j].key, creditors[j].value - amount);
      if (debtors[i].value < 0.0001) i++;
      if (creditors[j].value < 0.0001) j++;
    }
    return transfers;
  }
}
