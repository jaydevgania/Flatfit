import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flatfit/config/routes/route_names.dart';
import 'package:flatfit/config/theme/app_colors.dart';
import 'package:flatfit/config/theme/app_dimensions.dart';
import 'package:flatfit/config/theme/app_text_styles.dart';
import 'package:flatfit/core/utils/constants.dart';
import 'package:flatfit/core/widgets/flatfit_button.dart';
import 'package:flatfit/features/auth/domain/auth_state.dart';
import 'package:flatfit/features/auth/presentation/providers/auth_provider.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final _otpController = TextEditingController();
  late Timer _timer;
  int _secondsRemaining = AppConstants.otpResendCooldownSeconds;
  bool _canResend = false;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    setState(() {
      _secondsRemaining = AppConstants.otpResendCooldownSeconds;
      _canResend = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _timer.cancel();
        setState(() => _canResend = true);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _handleVerify([String? code]) async {
    final otpToVerify = code ?? _otpController.text.trim();
    if (otpToVerify.length != 6) return;

    setState(() => _isVerifying = true);

    final user = await ref.read(authNotifierProvider.notifier).verifyOtp(
          phoneNumber: widget.phoneNumber,
          otp: otpToVerify,
        );

    setState(() => _isVerifying = false);

    if (user != null && mounted) {
      if (user.hasProfile) {
        context.goNamed(RouteNames.home);
      } else {
        final hasConsent = await ref.read(authNotifierProvider.notifier).hasGivenConsent();
        if (hasConsent) {
          context.goNamed(RouteNames.onboarding);
        } else {
          context.goNamed(RouteNames.consent);
        }
      }
    }
  }

  Future<void> _handleResend() async {
    if (!_canResend) return;

    final success = await ref.read(authNotifierProvider.notifier).sendOtp(widget.phoneNumber);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification code sent successfully')),
      );
      _startCountdown();
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppDimensions.spacingLg),
              Text(
                'Enter Verification Code',
                style: AppTextStyles.displaySmall,
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              Text(
                'Sent to ${widget.phoneNumber}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: AppDimensions.spacing3xl),

              // 6-digit PIN input with pin_code_fields
              PinCodeTextField(
                appContext: context,
                length: 6,
                controller: _otpController,
                keyboardType: TextInputType.number,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
                  fieldHeight: 54,
                  fieldWidth: 44,
                  activeFillColor: AppColors.surfaceLight,
                  inactiveFillColor: AppColors.backgroundLight,
                  selectedFillColor: AppColors.surfaceLight,
                  activeColor: AppColors.primary,
                  selectedColor: AppColors.primary,
                  inactiveColor: AppColors.dividerLight,
                  borderWidth: 1.5,
                ),
                enableActiveFill: true,
                cursorColor: AppColors.primary,
                autoFocus: true,
                onCompleted: (pin) => _handleVerify(pin),
                onChanged: (_) {},
              ),

              const SizedBox(height: AppDimensions.spacingXl),

              // Resend Timer Row
              Center(
                child: _canResend
                    ? TextButton(
                        onPressed: _handleResend,
                        child: Text(
                          'Resend Code',
                          style: AppTextStyles.buttonMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : Text(
                        'Resend code in ${_secondsRemaining}s',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textTertiaryLight,
                        ),
                      ),
              ),

              const Spacer(),

              FlatFitButton(
                text: 'Verify & Continue',
                isLoading: _isVerifying,
                onPressed: _handleVerify,
              ),
              const SizedBox(height: AppDimensions.spacingLg),
            ],
          ),
        ),
      ),
    );
  }
}
