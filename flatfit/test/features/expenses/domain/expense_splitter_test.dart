import 'package:flutter_test/flutter_test.dart';
import '../../../../lib/features/expenses/domain/models/expense_models.dart';
import '../../../../lib/features/expenses/domain/services/expense_splitter.dart';
import '../../../../lib/features/expenses/domain/services/upi_service.dart';

void main() {
  group('ExpenseSplitter - Equal Split', () {
    test('splits 100 rupees equally among 3 users with exact paise balance', () {
      final userIds = ['user_1', 'user_2', 'user_3'];
      final splits = ExpenseSplitter.calculateEqualSplit(
        totalAmount: 100.0,
        userIds: userIds,
      );

      expect(splits.length, 3);
      // Sum must equal 100.00 exactly
      final total = splits.values.fold<double>(0.0, (s, a) => s + a);
      expect(total, closeTo(100.0, 0.001));

      // With integer paise: 10000 ~/ 3 = 3333 paise (33.33) with 1 paise remainder
      // One user gets 33.34 and two users get 33.33
      expect(splits['user_1'], 33.34);
      expect(splits['user_2'], 33.33);
      expect(splits['user_3'], 33.33);
    });

    test('splits 50 rupees among 4 users exactly', () {
      final userIds = ['u1', 'u2', 'u3', 'u4'];
      final splits = ExpenseSplitter.calculateEqualSplit(
        totalAmount: 50.0,
        userIds: userIds,
      );

      final total = splits.values.fold<double>(0.0, (s, a) => s + a);
      expect(total, closeTo(50.0, 0.001));
      for (final amt in splits.values) {
        expect(amt, 12.50);
      }
    });

    test('handles 0 amount and empty users safely', () {
      expect(ExpenseSplitter.calculateEqualSplit(totalAmount: 0.0, userIds: ['u1']), {'u1': 0.0});
      expect(ExpenseSplitter.calculateEqualSplit(totalAmount: 100.0, userIds: []), {});
    });
  });

  group('ExpenseSplitter - Custom Ratio Split', () {
    test('splits 1000 rupees with 60:40 ratio', () {
      final ratios = {'u1': 60.0, 'u2': 40.0};
      final splits = ExpenseSplitter.calculateRatioSplit(
        totalAmount: 1000.0,
        ratios: ratios,
      );

      expect(splits['u1'], 600.0);
      expect(splits['u2'], 400.0);
      final total = splits.values.fold<double>(0.0, (s, a) => s + a);
      expect(total, closeTo(1000.0, 0.001));
    });

    test('splits odd amount with 1:2:3 fractional weights', () {
      final ratios = {'u1': 1.0, 'u2': 2.0, 'u3': 3.0};
      const totalAmount = 145.75;
      final splits = ExpenseSplitter.calculateRatioSplit(
        totalAmount: totalAmount,
        ratios: ratios,
      );

      final total = splits.values.fold<double>(0.0, (s, a) => s + a);
      expect(total, closeTo(totalAmount, 0.001));
    });
  });

  group('ExpenseSplitter - Itemized Split', () {
    test('splits individual items and pro-rates tax proportionally', () {
      final items = [
        const ItemizedEntry(
          itemName: 'Paneer Makhani',
          amount: 300.0,
          assignedUserIds: ['u1', 'u2'], // 150 each
        ),
        const ItemizedEntry(
          itemName: 'Chicken Biryani',
          amount: 400.0,
          assignedUserIds: ['u3'], // 400
        ),
      ];
      // Total item subtotal = 700. u1 = 150, u2 = 150, u3 = 400.
      // Shared GST + Delivery = 70.
      // Tax share: u1: (150/700)*70 = 15; u2: 15; u3: (400/700)*70 = 40.
      // Final: u1: 165; u2: 165; u3: 440.
      // Total bill = 770.
      final splits = ExpenseSplitter.calculateItemizedSplit(
        items: items,
        sharedTaxesAndFees: 70.0,
      );

      expect(splits['u1'], 165.0);
      expect(splits['u2'], 165.0);
      expect(splits['u3'], 440.0);

      final total = splits.values.fold<double>(0.0, (s, a) => s + a);
      expect(total, closeTo(770.0, 0.001));
    });
  });

  group('ExpenseSplitter - Debt Simplification Algorithm', () {
    test('simplifies transitive debt: A owes B, B owes C -> A owes C', () {
      // User A owes User B 500
      // User B owes User C 500
      final pairwise = {
        'A': {'B': 500.0},
        'B': {'C': 500.0},
      };

      final simplified = ExpenseSplitter.simplifyDebts(pairwise);
      expect(simplified.length, 1);
      expect(simplified.first.fromUserId, 'A');
      expect(simplified.first.toUserId, 'C');
      expect(simplified.first.amount, 500.0);
    });

    test('cancels out circular debts completely', () {
      // A owes B 100, B owes C 100, C owes A 100
      final pairwise = {
        'A': {'B': 100.0},
        'B': {'C': 100.0},
        'C': {'A': 100.0},
      };

      final simplified = ExpenseSplitter.simplifyDebts(pairwise);
      expect(simplified.isEmpty, true);
    });
  });

  group('UpiService - Deep Link Generation & VPA Validation', () {
    test('validates VPA format properly', () {
      expect(UpiService.isValidVpa('rohan@okhdfcbank'), true);
      expect(UpiService.isValidVpa('9820144321@paytm'), true);
      expect(UpiService.isValidVpa('user.name-1@axis'), true);
      expect(UpiService.isValidVpa('invalid_vpa_without_bank'), false);
      expect(UpiService.isValidVpa('@bank'), false);
    });

    test('generates NPCI-compliant upi://pay URI with all parameters', () {
      final uri = UpiService.generateUpiDeepLink(
        vpa: 'rohan.verma@okhdfcbank',
        payeeName: 'Rohan Verma',
        amount: 1450.50,
        note: 'Electricity Bill Split',
      );

      expect(uri.startsWith('upi://pay?'), true);
      expect(uri.contains('pa=rohan.verma%40okhdfcbank'), true);
      expect(uri.contains('pn=Rohan%20Verma'), true);
      expect(uri.contains('am=1450.50'), true);
      expect(uri.contains('cu=INR'), true);
      expect(uri.contains('tn=Electricity%20Bill%20Split'), true);
    });
  });
}
