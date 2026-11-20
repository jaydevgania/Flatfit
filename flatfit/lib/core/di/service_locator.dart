import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flatfit/core/network/supabase_client.dart';
import 'package:flatfit/core/storage/secure_storage.dart';
import 'package:flatfit/core/services/notification_service.dart';
import 'package:flatfit/core/services/payment_service.dart';
import 'package:flatfit/core/services/kyc_service.dart';
import 'package:flatfit/core/services/ai_service.dart';
import 'package:flatfit/core/services/analytics_service.dart';
import 'package:flatfit/core/services/crash_reporting_service.dart';
import 'package:flatfit/core/services/feature_flag_service.dart';

// ── Low-level Core Providers ────────────────────────────────────────────────

final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

final supabaseClientProvider = Provider<SupabaseClient?>((ref) {
  if (SupabaseService.instance.isInitialized) {
    return SupabaseService.instance.client;
  }
  return null;
});

// ── Application Services ────────────────────────────────────────────────────

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return FlatFitNotificationService();
});

final paymentServiceProvider = Provider<PaymentService>((ref) {
  return RazorpayPaymentService();
});

final kycServiceProvider = Provider<KycService>((ref) {
  return MockKycService();
});

final aiServiceProvider = Provider<AiService>((ref) {
  return MockAiService();
});

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return FlatFitAnalyticsService();
});

final crashReportingServiceProvider = Provider<CrashReportingService>((ref) {
  return FlatFitCrashReportingService();
});

final featureFlagServiceProvider = Provider<FeatureFlagService>((ref) {
  return FlatFitFeatureFlagService();
});
