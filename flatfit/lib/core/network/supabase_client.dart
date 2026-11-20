import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flatfit/config/app_config.dart';

/// Central Supabase client manager.
class SupabaseService {
  SupabaseService._();
  static final SupabaseService instance = SupabaseService._();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  /// Initializes Supabase with configuration credentials.
  /// Falls back gracefully in development / test environments if keys are missing.
  static Future<void> initialize() async {
    if (instance._isInitialized) return;

    final url = AppConfig.supabaseUrl;
    final anonKey = AppConfig.supabaseAnonKey;

    if (url.isEmpty || anonKey.isEmpty) {
      // In dev mode without keys yet, don't crash
      return;
    }

    try {
      await Supabase.initialize(
        url: url,
        anonKey: anonKey,
        authOptions: const FlutterAuthClientOptions(
          authFlowType: AuthFlowType.pkce,
        ),
      );
      instance._isInitialized = true;
    } catch (e) {
      // Allow app to boot in mock/offline mode
      instance._isInitialized = false;
    }
  }

  SupabaseClient get client {
    return Supabase.instance.client;
  }
}
