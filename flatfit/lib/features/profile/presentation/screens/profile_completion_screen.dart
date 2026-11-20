import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/profile_completion_meter.dart';

/// Screen 6 in Onboarding: Completion summary, completion meter & CTA to start quiz
class ProfileCompletionScreen extends ConsumerWidget {
  const ProfileCompletionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final draft = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    // Compute completion percentage based on current filled fields
    int completion = 20; // base account
    if (draft.fullName.isNotEmpty) completion += 15;
    if (draft.occupation != null) completion += 15;
    if (draft.housingGoal != null) completion += 15;
    if (draft.preferredLocalities.isNotEmpty) completion += 15;
    if (draft.localPhotoPaths.isNotEmpty) completion += 10;
    if (draft.bio.length >= 20) completion += 10;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline,
                size: 52,
                color: Colors.green,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Profile Created! 🎉',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(
              'Your profile is ready to connect with potential flatmates.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Completion meter
          ProfileCompletionMeter(
            percentage: completion,
            isCircular: false,
          ),
          const SizedBox(height: 24),

          // Review card
          Text(
            'Quick Profile Summary',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                _buildSummaryRow(
                  icon: Icons.person,
                  label: 'Name & Age',
                  value: '${draft.fullName}, ${draft.age ?? '-'} yrs',
                ),
                const Divider(height: 20),
                _buildSummaryRow(
                  icon: Icons.work,
                  label: 'Occupation',
                  value: draft.occupation?.label ?? '-',
                ),
                const Divider(height: 20),
                _buildSummaryRow(
                  icon: Icons.home,
                  label: 'Housing Goal',
                  value: draft.housingGoal?.label ?? '-',
                ),
                const Divider(height: 20),
                _buildSummaryRow(
                  icon: Icons.currency_rupee,
                  label: 'Budget',
                  value: '₹${(draft.budgetMin / 1000).toStringAsFixed(0)}k - ₹${(draft.budgetMax / 1000).toStringAsFixed(0)}k',
                ),
                const Divider(height: 20),
                _buildSummaryRow(
                  icon: Icons.location_on,
                  label: 'Localities',
                  value: draft.preferredLocalities.join(', '),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Next: Lifestyle Questionnaire banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary.withValues(alpha: 0.1),
                  Colors.purple.shade50,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Text('✨', style: TextStyle(fontSize: 20)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Unlock Compatibility Matching',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Take the 20-question lifestyle quiz to get compatibility scores with every flatmate.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Primary CTA: Complete & Go to Questionnaire
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: draft.isSubmitting
                  ? null
                  : () async {
                      final success = await notifier.completeOnboarding();
                      if (context.mounted) {
                        if (success) {
                          context.go('/questionnaire');
                        } else {
                          // Allow proceed anyway for preview or retry
                          context.go('/questionnaire');
                        }
                      }
                    },
              icon: draft.isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.quiz_outlined),
              label: Text(
                draft.isSubmitting
                    ? 'Saving Profile...'
                    : 'Take Lifestyle Quiz (3 min)',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Skip to Home
          Center(
            child: TextButton(
              onPressed: () {
                context.go('/home');
              },
              child: const Text(
                'Skip for now, go to Home',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade700),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
        const Spacer(),
        Expanded(
          flex: 2,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
