import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flatfit/config/routes/route_names.dart';
import 'package:flatfit/config/theme/app_colors.dart';
import 'package:flatfit/config/theme/app_dimensions.dart';
import 'package:flatfit/config/theme/app_text_styles.dart';
import 'package:flatfit/core/utils/validators.dart';
import 'package:flatfit/core/widgets/flatfit_button.dart';
import 'package:flatfit/core/widgets/flatfit_text_field.dart';
import 'package:flatfit/features/auth/domain/auth_state.dart';
import 'package:flatfit/features/auth/presentation/providers/auth_provider.dart';

class PhoneAuthScreen extends ConsumerStatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  ConsumerState<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends ConsumerState<PhoneAuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final sanitizedPhone = Validators.sanitizeIndianPhone(_phoneController.text);

    setState(() => _isLoading = true);

    final success = await ref.read(authNotifierProvider.notifier).sendOtp(sanitizedPhone);

    setState(() => _isLoading = false);

    if (success && mounted) {
      context.pushNamed(
        RouteNames.otpVerification,
        extra: sanitizedPhone,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (next is AuthError && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: AppColors.error,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.pagePaddingHorizontal,
            vertical: AppDimensions.pagePaddingVertical,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppDimensions.spacingLg),
                Text(
                  'What\'s your number?',
                  style: AppTextStyles.displaySmall,
                ),
                const SizedBox(height: AppDimensions.spacingSm),
                Text(
                  'We\'ll send a 6-digit verification code to keep your account safe.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacing3xl),

                // Phone Input with India (+91) prefix
                FlatFitTextField(
                  controller: _phoneController,
                  hintText: '98765 43210',
                  keyboardType: TextInputType.phone,
                  autofocus: true,
                  maxLength: 10,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  prefixIcon: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    margin: const EdgeInsets.only(right: 8),
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(color: AppColors.dividerLight),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🇮🇳', style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 6),
                        Text(
                          '+91',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.textPrimaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  validator: Validators.validateIndianPhone,
                  onSubmitted: (_) => _handleSubmit(),
                ),

                const Spacer(),

                FlatFitButton(
                  text: 'Get Verification Code',
                  isLoading: _isLoading,
                  onPressed: _handleSubmit,
                ),
                const SizedBox(height: AppDimensions.spacingLg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
