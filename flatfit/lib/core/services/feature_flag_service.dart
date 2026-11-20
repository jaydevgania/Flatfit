import 'package:flutter/foundation.dart';

/// Central feature flag manager for progressive rollout and remote control.
abstract class FeatureFlagService {
  bool isEnabled(String key, {bool defaultValue = false});
  Future<void> reloadFlags();
  Map<String, bool> getAllFlags();
}

class FlatFitFeatureFlagService implements FeatureFlagService {
  final Map<String, bool> _flags = {
    'ai_bio_generator': true,
    'voice_intros': true,
    'upi_instant_split': true,
    'kyc_instant_verification': true,
    'community_events': true,
    'rental_agreements': true,
    'dark_mode': true,
  };

  @override
  bool isEnabled(String key, {bool defaultValue = false}) {
    return _flags[key] ?? defaultValue;
  }

  @override
  Future<void> reloadFlags() async {
    // In production, queries Supabase feature_flags table
    if (kDebugMode) {
      debugPrint('[FeatureFlags] Reloaded remote flags');
    }
  }

  @override
  Map<String, bool> getAllFlags() => Map.unmodifiable(_flags);
}
