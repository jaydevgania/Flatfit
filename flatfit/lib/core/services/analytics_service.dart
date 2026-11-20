import 'package:flutter/foundation.dart';

/// Service for logging user actions and funnel conversions across FlatFit.
abstract class AnalyticsService {
  Future<void> logEvent(String name, [Map<String, dynamic>? parameters]);
  Future<void> setUserId(String? userId);
  Future<void> setUserProperty(String name, String value);
  Future<void> logScreenView(String screenName);
}

class FlatFitAnalyticsService implements AnalyticsService {
  String? _currentUserId;

  @override
  Future<void> logEvent(String name, [Map<String, dynamic>? parameters]) async {
    if (kDebugMode) {
      debugPrint('[Analytics] Event: $name | params: $parameters | userId: $_currentUserId');
    }
    // In production, post to Supabase analytics_events table or PostHog/Mixpanel
  }

  @override
  Future<void> setUserId(String? userId) async {
    _currentUserId = userId;
    if (kDebugMode) {
      debugPrint('[Analytics] Set userId: $userId');
    }
  }

  @override
  Future<void> setUserProperty(String name, String value) async {
    if (kDebugMode) {
      debugPrint('[Analytics] User Property: $name = $value');
    }
  }

  @override
  Future<void> logScreenView(String screenName) async {
    await logEvent('screen_view', {'screen_name': screenName});
  }
}
