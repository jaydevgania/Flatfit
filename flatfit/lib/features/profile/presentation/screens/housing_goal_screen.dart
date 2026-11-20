import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/housing_goal.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/housing_goal_card.dart';

/// Screen 2 in Onboarding: Housing Goal
class HousingGoalScreen extends ConsumerWidget {
  const HousingGoalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentGoal = ref.watch(onboardingProvider.select((s) => s.housingGoal));

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What is your housing goal? 🎯',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Choose how you want FlatFit to assist your roommate search.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),

          // Cards for the 3 housing goals
          ...HousingGoal.values.map((goal) {
            final isSelected = currentGoal == goal;
            return HousingGoalCard(
              goal: goal,
              isSelected: isSelected,
              onTap: () {
                ref.read(onboardingProvider.notifier).setHousingGoal(goal);
              },
            );
          }),

          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Colors.amber.shade800),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'You can switch your housing goal at any time in your profile settings.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.amber.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
