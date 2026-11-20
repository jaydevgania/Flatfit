import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flatfit/core/network/api_exception.dart';
import 'package:flatfit/core/network/supabase_client.dart';
import 'package:flatfit/features/auth/domain/auth_models.dart';

abstract class AuthRemoteDataSource {
  Future<PhoneAuthResult> sendPhoneOtp(String phoneNumber);
  Future<FlatFitUser> verifyPhoneOtp({
    required String phoneNumber,
    required String token,
  });
  Future<FlatFitUser> signInWithGoogle();
  Future<FlatFitUser?> getCurrentUser();
  Future<bool> checkProfileExists(String userId);
  Future<void> signOut();
  Future<void> deleteAccount();
}

class SupabaseAuthRemoteDataSource implements AuthRemoteDataSource {
  SupabaseClient? get _client =>
      SupabaseService.instance.isInitialized ? SupabaseService.instance.client : null;

  @override
  Future<PhoneAuthResult> sendPhoneOtp(String phoneNumber) async {
    final client = _client;
    if (client == null) {
      // Mock mode for local preview / headless tests
      return PhoneAuthResult(phoneNumber: phoneNumber, isSent: true);
    }

    try {
      await client.auth.signInWithOtp(
        phone: phoneNumber,
      );
      return PhoneAuthResult(phoneNumber: phoneNumber, isSent: true);
    } on AuthException catch (e) {
      throw ServerException(e.message, statusCode: int.tryParse(e.statusCode ?? '400'));
    } catch (e) {
      throw ServerException('Failed to send OTP: $e');
    }
  }

  @override
  Future<FlatFitUser> verifyPhoneOtp({
    required String phoneNumber,
    required String token,
  }) async {
    final client = _client;
    if (client == null) {
      // Mock user for offline / test environments
      final mockId = 'user_${phoneNumber.replaceAll(RegExp(r'\D'), '')}';
      return FlatFitUser(
        id: mockId,
        phone: phoneNumber,
        hasProfile: false,
        createdAt: DateTime.now(),
      );
    }

    try {
      final response = await client.auth.verifyOTP(
        phone: phoneNumber,
        token: token,
        type: OtpType.sms,
      );

      final user = response.user;
      if (user == null) {
        throw const UnauthorizedException('Failed to authenticate with OTP');
      }

      final hasProfile = await checkProfileExists(user.id);

      return FlatFitUser(
        id: user.id,
        phone: user.phone ?? phoneNumber,
        email: user.email,
        hasProfile: hasProfile,
        createdAt: DateTime.tryParse(user.createdAt) ?? DateTime.now(),
      );
    } on AuthException catch (e) {
      throw ServerException(e.message, statusCode: int.tryParse(e.statusCode ?? '400'));
    } catch (e) {
      throw ServerException('OTP verification failed: $e');
    }
  }

  @override
  Future<FlatFitUser> signInWithGoogle() async {
    final client = _client;
    if (client == null) {
      return FlatFitUser(
        id: 'google_mock_user_1',
        email: 'demo@flatfit.in',
        fullName: 'Demo Google User',
        hasProfile: false,
        createdAt: DateTime.now(),
      );
    }

    try {
      await client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'flatfit://login-callback',
      );

      final user = client.auth.currentUser;
      if (user == null) {
        throw const UnauthorizedException('Google sign-in cancelled or failed');
      }

      final hasProfile = await checkProfileExists(user.id);

      return FlatFitUser(
        id: user.id,
        email: user.email,
        fullName: user.userMetadata?['full_name'] as String?,
        avatarUrl: user.userMetadata?['avatar_url'] as String?,
        hasProfile: hasProfile,
        createdAt: DateTime.tryParse(user.createdAt) ?? DateTime.now(),
      );
    } on AuthException catch (e) {
      throw ServerException(e.message, statusCode: int.tryParse(e.statusCode ?? '400'));
    } catch (e) {
      throw ServerException('Google sign-in failed: $e');
    }
  }

  @override
  Future<FlatFitUser?> getCurrentUser() async {
    final client = _client;
    if (client == null) return null;

    final user = client.auth.currentUser;
    if (user == null) return null;

    final hasProfile = await checkProfileExists(user.id);

    return FlatFitUser(
      id: user.id,
      phone: user.phone,
      email: user.email,
      fullName: user.userMetadata?['full_name'] as String?,
      avatarUrl: user.userMetadata?['avatar_url'] as String?,
      hasProfile: hasProfile,
      createdAt: DateTime.tryParse(user.createdAt) ?? DateTime.now(),
    );
  }

  @override
  Future<bool> checkProfileExists(String userId) async {
    final client = _client;
    if (client == null) return false;

    try {
      final res = await client
          .from('profiles')
          .select('id')
          .eq('id', userId)
          .maybeSingle();

      return res != null;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> signOut() async {
    final client = _client;
    if (client != null) {
      await client.auth.signOut();
    }
  }

  @override
  Future<void> deleteAccount() async {
    final client = _client;
    if (client != null && client.auth.currentUser != null) {
      // In Supabase, account deletion is handled via RPC or Edge function
      await client.rpc('delete_user_account');
      await client.auth.signOut();
    }
  }
}
