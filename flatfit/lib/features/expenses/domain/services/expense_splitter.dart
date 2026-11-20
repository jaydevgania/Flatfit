import 'dart:math';
import '../models/expense_models.dart';

/// Pure Dart domain engine for fair expense splitting and debt simplification algorithms.
class ExpenseSplitter {
  /// Splits a total amount equally among a list of user IDs.
  /// Guarantees that the sum of the returned splits strictly equals [totalAmount]
  /// down to the exact paisa (2 decimal places).
  static Map<String, double> calculateEqualSplit({
    required double totalAmount,
    required List<String> userIds,
  }) {
    if (userIds.isEmpty) return {};
    if (totalAmount <= 0) {
      return {for (var uid in userIds) uid: 0.0};
    }

    final n = userIds.length;
    // Total in paise (integer cents)
    final totalPaise = (totalAmount * 100).round();
    final baseSharePaise = totalPaise ~/ n;
    int remainderPaise = totalPaise % n;

    final result = <String, double>{};
    for (int i = 0; i < n; i++) {
      int personPaise = baseSharePaise;
      if (remainderPaise > 0) {
        personPaise += 1;
        remainderPaise--;
      }
      result[userIds[i]] = personPaise / 100.0;
    }

    return result;
  }

  /// Splits an expense according to custom ratios or percentage weights.
  /// [ratios] map user ID to ratio weight (e.g. {'user_1': 2.0, 'user_2': 1.0} or {'user_1': 60, 'user_2': 40}).
  /// Guarantees that sum of splits equals [totalAmount] exactly.
  static Map<String, double> calculateRatioSplit({
    required double totalAmount,
    required Map<String, double> ratios,
  }) {
    if (ratios.isEmpty) return {};
    if (totalAmount <= 0) {
      return {for (var key in ratios.keys) key: 0.0};
    }

    final totalWeight = ratios.values.fold<double>(0.0, (s, w) => s + w);
    if (totalWeight <= 0) {
      return calculateEqualSplit(totalAmount: totalAmount, userIds: ratios.keys.toList());
    }

    final totalPaise = (totalAmount * 100).round();
    final calculatedPaise = <String, int>{};
    final fractionalParts = <String, double>{};

    int allocatedPaise = 0;
    for (final entry in ratios.entries) {
      final exactPaise = (totalPaise * entry.value) / totalWeight;
      final floorPaise = exactPaise.floor();
      calculatedPaise[entry.key] = floorPaise;
      fractionalParts[entry.key] = exactPaise - floorPaise;
      allocatedPaise += floorPaise;
    }

    int remainingPaise = totalPaise - allocatedPaise;
    // Distribute remaining paise to users with highest fractional remainder
    final sortedByFraction = ratios.keys.toList()
      ..sort((a, b) => fractionalParts[b]!.compareTo(fractionalParts[a]!));

    for (int i = 0; i < remainingPaise; i++) {
      final user = sortedByFraction[i % sortedByFraction.length];
      calculatedPaise[user] = calculatedPaise[user]! + 1;
    }

    return calculatedPaise.map((uid, paise) => MapEntry(uid, paise / 100.0));
  }

  /// Calculates individual shares from an itemized receipt (e.g. grocery delivery or dining out).
  /// [items]: individual items and which flatmates consumed/benefited from them.
  /// [sharedTaxesAndFees]: GST, delivery fee, or shared platform charge.
  /// Shared fees are distributed proportionally to each person's itemized subtotal.
  static Map<String, double> calculateItemizedSplit({
    required List<ItemizedEntry> items,
    double sharedTaxesAndFees = 0.0,
  }) {
    final subtotalMap = <String, double>{};

    for (final item in items) {
      if (item.assignedUserIds.isEmpty) continue;
      final equalItemSplit = calculateEqualSplit(
        totalAmount: item.amount,
        userIds: item.assignedUserIds,
      );
      for (final entry in equalItemSplit.entries) {
        subtotalMap[entry.key] = (subtotalMap[entry.key] ?? 0.0) + entry.value;
      }
    }

    if (sharedTaxesAndFees <= 0.0 || subtotalMap.isEmpty) {
      return subtotalMap.map((uid, amt) => MapEntry(uid, (amt * 100).round() / 100.0));
    }

    final totalSubtotal = subtotalMap.values.fold<double>(0.0, (s, a) => s + a);
    if (totalSubtotal <= 0) {
      final equalTax = calculateEqualSplit(
        totalAmount: sharedTaxesAndFees,
        userIds: subtotalMap.keys.toList(),
      );
      return equalTax;
    }

    // Split taxes proportionally based on subtotal ratio
    final taxSplit = calculateRatioSplit(
      totalAmount: sharedTaxesAndFees,
      ratios: subtotalMap,
    );

    final finalResult = <String, double>{};
    for (final uid in subtotalMap.keys) {
      final base = (subtotalMap[uid] ?? 0.0);
      final tax = (taxSplit[uid] ?? 0.0);
      finalResult[uid] = ((base + tax) * 100).round() / 100.0;
    }

    return finalResult;
  }

  /// Min-cash flow debt simplification algorithm.
  /// Reduces pairwise flatmate debts from O(N^2) to at most N-1 direct transactions.
  /// [pairwiseDebts]: map of debtor -> (creditor -> amount).
  static List<SimplifiedDebt> simplifyDebts(
    Map<String, Map<String, double>> pairwiseDebts, {
    Map<String, String>? userNames,
    Map<String, String>? userVpas,
  }) {
    // 1. Calculate net balance for every user
    // Positive balance = owed money (creditor)
    // Negative balance = owes money (debtor)
    final netBalances = <String, double>{};

    for (final debtor in pairwiseDebts.keys) {
      for (final creditor in pairwiseDebts[debtor]!.keys) {
        final amt = pairwiseDebts[debtor]![creditor] ?? 0.0;
        if (amt <= 0.0) continue;
        netBalances[debtor] = (netBalances[debtor] ?? 0.0) - amt;
        netBalances[creditor] = (netBalances[creditor] ?? 0.0) + amt;
      }
    }

    // Filter out users with 0 balance (within 1 paisa tolerance)
    final creditors = <String, double>{};
    final debtors = <String, double>{};

    for (final entry in netBalances.entries) {
      final roundedAmt = (entry.value * 100).round() / 100.0;
      if (roundedAmt > 0.009) {
        creditors[entry.key] = roundedAmt;
      } else if (roundedAmt < -0.009) {
        debtors[entry.key] = -roundedAmt; // positive value for algorithm
      }
    }

    final results = <SimplifiedDebt>[];

    // Greedy min-cash-flow matching
    while (creditors.isNotEmpty && debtors.isNotEmpty) {
      // Find maximum creditor and maximum debtor
      String maxCreditor = creditors.keys.first;
      for (final c in creditors.keys) {
        if (creditors[c]! > creditors[maxCreditor]!) maxCreditor = c;
      }

      String maxDebtor = debtors.keys.first;
      for (final d in debtors.keys) {
        if (debtors[d]! > debtors[maxDebtor]!) maxDebtor = d;
      }

      final credAmt = creditors[maxCreditor]!;
      final debtAmt = debtors[maxDebtor]!;
      final settlementAmount = min(credAmt, debtAmt);
      final roundedSettlement = (settlementAmount * 100).round() / 100.0;

      if (roundedSettlement > 0.009) {
        results.add(
          SimplifiedDebt(
            fromUserId: maxDebtor,
            fromUserName: userNames?[maxDebtor] ?? maxDebtor,
            toUserId: maxCreditor,
            toUserName: userNames?[maxCreditor] ?? maxCreditor,
            amount: roundedSettlement,
            toUserVpa: userVpas?[maxCreditor],
          ),
        );
      }

      final newCredBalance = (credAmt - settlementAmount);
      final newDebtBalance = (debtAmt - settlementAmount);

      if (newCredBalance < 0.01) {
        creditors.remove(maxCreditor);
      } else {
        creditors[maxCreditor] = (newCredBalance * 100).round() / 100.0;
      }

      if (newDebtBalance < 0.01) {
        debtors.remove(maxDebtor);
      } else {
        debtors[maxDebtor] = (newDebtBalance * 100).round() / 100.0;
      }
    }

    return results;
  }
}
