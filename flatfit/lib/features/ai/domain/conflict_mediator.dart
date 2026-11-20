enum DisputeCategory { dirtyDishes, unpaidBills, other }
enum MediatorTone { gentleFriendly, diplomaticBalanced }

class ConflictMediatorResult {
  final DisputeCategory category;
  final Map<MediatorTone, String> rewrites;
  final String suggestedCompromiseRule;
  const ConflictMediatorResult({
    required this.category,
    required this.rewrites,
    required this.suggestedCompromiseRule,
  });
}

class ConflictMediatorEngine {
  static ConflictMediatorResult mediateMessage(String input) {
    final text = input.toLowerCase();
    if (text.contains('dishes') || text.contains('dish')) {
      return const ConflictMediatorResult(
        category: DisputeCategory.dirtyDishes,
        rewrites: {
          MediatorTone.gentleFriendly:
              'Hi, could we please keep the kitchen gentle and clean?',
          MediatorTone.diplomaticBalanced:
              'Could we agree to wash dishes after use and keep the sink clear?',
        },
        suggestedCompromiseRule: 'Wash dishes within 30 minutes of use.',
      );
    }
    if (text.contains('bill') || text.contains('electricity') || text.contains('wifi')) {
      return const ConflictMediatorResult(
        category: DisputeCategory.unpaidBills,
        rewrites: {
          MediatorTone.gentleFriendly:
              'A gentle reminder that the bill is due today.',
          MediatorTone.diplomaticBalanced:
              'Please share the bill payment reminder link today.',
        },
        suggestedCompromiseRule: 'Pay shared bills within 24 hours.',
      );
    }
    return const ConflictMediatorResult(
      category: DisputeCategory.other,
      rewrites: {},
      suggestedCompromiseRule: '',
    );
  }
}
