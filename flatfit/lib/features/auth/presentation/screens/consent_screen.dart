import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flatfit/config/routes/route_names.dart';
import 'package:flatfit/config/theme/app_colors.dart';
import 'package:flatfit/config/theme/app_dimensions.dart';
import 'package:flatfit/config/theme/app_text_styles.dart';
import 'package:flatfit/core/widgets/flatfit_button.dart';
import 'package:flatfit/core/widgets/flatfit_card.dart';
import 'package:flatfit/features/auth/domain/auth_state.dart';
import 'package:flatfit/features/auth/presentation/providers/auth_provider.dart';

class ConsentScreen extends ConsumerStatefulWidget {
  const ConsentScreen({super.key});

  @override
  ConsumerState<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends ConsumerState<ConsentScreen> {
  bool _termsAgreed = false;
  bool _privacyAgreed = false;
  bool _communityAgreed = false;

  bool get _canProceed => _termsAgreed && _privacyAgreed && _communityAgreed;

  Future<void> _handleContinue() async {
    if (!_canProceed) return;

    await ref.read(authNotifierProvider.notifier).markConsentAccepted();

    final authState = ref.read(authNotifierProvider);
    if (authState is Authenticated && authState.user.hasProfile) {
      if (mounted) context.goNamed(RouteNames.home);
    } else {
      if (mounted) context.goNamed(RouteNames.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Consent'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.pagePaddingHorizontal,
            vertical: AppDimensions.pagePaddingVertical,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppDimensions.spacingMd),
              Text(
                'Welcome to FlatFit Community',
                style: AppTextStyles.displaySmall,
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              Text(
                'To ensure a safe, respectful, and reliable flatmate matching experience across India, please review and accept our community standards.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingXl),

              // Consent Cards
              Expanded(
                child: ListView(
                  children: [
                    _buildConsentTile(
                      title: 'Terms of Service',
                      subtitle: 'Guidelines on listing accuracy, rental fairness, and account usage.',
                      value: _termsAgreed,
                      onChanged: (val) => setState(() => _termsAgreed = val ?? false),
                    ),
                    const SizedBox(height: AppDimensions.spacingMd),
                    _buildConsentTile(
                      title: 'Privacy Policy',
                      subtitle: 'How we protect your phone, government ID, and lifestyle responses.',
                      value: _privacyAgreed,
                      onChanged: (val) => setState(() => _privacyAgreed = val ?? false),
                    ),
                    const SizedBox(height: AppDimensions.spacingMd),
                    _buildConsentTile(
                      title: 'Community Guidelines',
                      subtitle: 'Zero tolerance for discrimination based on religion, food habits, caste, or gender.',
                      value: _communityAgreed,
                      onChanged: (val) => setState(() => _communityAgreed = val ?? false),
                    ),
                  ],
                ),
              ),

              // Quick Agree All button if not all selected
              if (!_canProceed) ...[
                TextButton(
                  onPressed: () {
                    setState(() {
                      _termsAgreed = true;
                      _privacyAgreed = true;
                      _communityAgreed = true;
                    });
                  },
                  child: const Text('Agree to All'),
                ),
                const SizedBox(height: AppDimensions.spacingSm),
              ],

              FlatFitButton(
                text: 'Agree & Continue',
                onPressed: _canProceed ? _handleContinue : null,
              ),
              const SizedBox(height: AppDimensions.spacingLg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConsentTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return FlatFitCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingMd,
        vertical: AppDimensions.spacingSm,
      ),
      child: CheckboxListTile(
        value: value,
        onChanged: onChanged,
        title: Text(title, style: AppTextStyles.titleMedium),
        subtitle: Text(
          subtitle,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondaryLight,
          ),
        ),
        activeColor: AppColors.primary,
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }
}
