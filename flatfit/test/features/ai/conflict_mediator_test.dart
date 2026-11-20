import 'package:flutter_test/flutter_test.dart';
import 'package:flatfit/features/ai/domain/conflict_mediator.dart';

void main() {
  group('ConflictMediatorEngine Tests', () {
    test('Detects dirty dishes complaint and rewrites into kind communication', () {
      const input = 'You never clean your dishes in the sink and the kitchen smells disgusting!';
      final result = ConflictMediatorEngine.mediateMessage(input);

      expect(result.category, equals(DisputeCategory.dirtyDishes));
      expect(result.rewrites[MediatorTone.gentleFriendly], contains('gentle'));
      expect(result.rewrites[MediatorTone.diplomaticBalanced], contains('sink'));
      expect(result.suggestedCompromiseRule.isNotEmpty, isTrue);
    });

    test('Detects overdue bills complaint and suggests polite reminder with link', () {
      const input = 'Pay your electricity and wifi bill right now it is due today';
      final result = ConflictMediatorEngine.mediateMessage(input);

      expect(result.category, equals(DisputeCategory.unpaidBills));
      expect(result.rewrites[MediatorTone.gentleFriendly], contains('reminder'));
    });
  });
}
