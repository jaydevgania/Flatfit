import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flatfit/config/routes/route_names.dart';
import 'package:flatfit/config/theme/app_colors.dart';
import 'package:flatfit/config/theme/app_dimensions.dart';
import 'package:flatfit/config/theme/app_text_styles.dart';
import 'package:flatfit/core/widgets/flatfit_button.dart';
import 'package:flatfit/features/auth/presentation/providers/auth_provider.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.pagePaddingHorizontal,
            vertical: AppDimensions.pagePaddingVertical,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 1),
              // Hero Illustration / Badge container
              Center(
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.secondary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.25),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.diversity_3_rounded,
                      size: 72,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spacing3xl),

              // Headlines
              Text(
                'Find Flatmates Who\nActually Match Your Vibe',
                textAlign: TextAlign.center,
                style: AppTextStyles.displaySmall.copyWith(
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingMd),
              Text(
                'India\'s first compatibility-scored flatmate finder. No awkward broker calls, no mismatched living habits.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondaryLight,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: AppDimensions.spacing3xl),

              // Value propositions bullet points
              _buildFeatureRow(
                icon: Icons.psychology_outlined,
                title: 'Compatibility Matching',
                subtitle: 'Deep questions on sleep, guests, cleanliness & food.',
              ),
              const SizedBox(height: AppDimensions.spacingMd),
              _buildFeatureRow(
                icon: Icons.verified_user_outlined,
                title: '100% Verified Profiles',
                subtitle: 'Government ID & corporate/college checks.',
              ),
              const SizedBox(height: AppDimensions.spacingMd),
              _buildFeatureRow(
                icon: Icons.receipt_long_outlined,
                title: 'Flat Living Hub',
                subtitle: 'Shared expenses, UPI splits, chores, and rental agreements.',
              ),

              const Spacer(flex: 2),

              // Primary CTA: Phone number login
              FlatFitButton(
                text: 'Continue with Mobile Number',
                icon: Icons.phone_android_rounded,
                onPressed: () {
                  context.pushNamed(RouteNames.phoneAuth);
                },
              ),
              const SizedBox(height: AppDimensions.spacingMd),

              // Secondary Google Login
              FlatFitButton.outline(
                text: 'Continue with Google',
                icon: Icons.g_mobiledata_rounded,
                onPressed: () async {
                  final user = await ref.read(authNotifierProvider.notifier).signInWithGoogle();
                  if (user != null && context.mounted) {
                    if (user.hasProfile) {
                      context.goNamed(RouteNames.home);
                    } else {
                      context.goNamed(RouteNames.consent);
                    }
                  }
                },
              ),
              const SizedBox(height: AppDimensions.spacingLg),

              // Small terms note
              Text(
                'By continuing, you agree to our Terms of Service & Privacy Policy.',
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiaryLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRow({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primaryLight.withOpacity(0.2),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        const SizedBox(width: AppDimensions.spacingMd),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.titleMedium),
              Text(
                subtitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
