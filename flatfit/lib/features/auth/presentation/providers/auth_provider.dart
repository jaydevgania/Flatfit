import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flatfit/core/di/service_locator.dart';
import 'package:flatfit/core/storage/secure_storage.dart';
import 'package:flatfit/features/auth/data/auth_remote_data_source.dart';
import 'package:flatfit/features/auth/data/auth_repository.dart';
import 'package:flatfit/features/auth/domain/auth_models.dart';
import 'package:flatfit/features/auth/domain/auth_state.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return SupabaseAuthRemoteDataSource();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  return SupabaseAuthRepository(
    remoteDataSource: remoteDataSource,
    secureStorage: secureStorage,
  );
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  final SecureStorageService _storage;

  AuthNotifier({
    required AuthRepository repository,
    required SecureStorageService storage,
  })  : _repository = repository,
        _storage = storage,
        super(const AuthInitial()) {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    state = const AuthLoading('Checking active session...');
    try {
      final result = await _repository.getCurrentUser();
      result.when(
        success: (user) {
          if (user != null) {
            state = Authenticated(user);
          } else {
            state = const Unauthenticated();
          }
        },
        failure: (message, _) {
          state = const Unauthenticated();
        },
      );
    } catch (_) {
      state = const Unauthenticated();
    }
  }

  Future<bool> sendOtp(String phoneNumber) async {
    state = const AuthLoading('Sending OTP...');
    final result = await _repository.sendPhoneOtp(phoneNumber);
    return result.when(
      success: (_) {
        state = const Unauthenticated();
        return true;
      },
      failure: (message, err) {
        state = AuthError(message, err);
        return false;
      },
    );
  }

  Future<FlatFitUser?> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    state = const AuthLoading('Verifying OTP...');
    final result = await _repository.verifyPhoneOtp(
      phoneNumber: phoneNumber,
      token: otp,
    );
    return result.when(
      success: (user) {
        state = Authenticated(user);
        return user;
      },
      failure: (message, err) {
        state = AuthError(message, err);
        return null;
      },
    );
  }

  Future<FlatFitUser?> signInWithGoogle() async {
    state = const AuthLoading('Connecting with Google...');
    final result = await _repository.signInWithGoogle();
    return result.when(
      success: (user) {
        state = Authenticated(user);
        return user;
      },
      failure: (message, err) {
        state = AuthError(message, err);
        return null;
      },
    );
  }

  Future<void> signOut() async {
    state = const AuthLoading('Signing out...');
    await _repository.signOut();
    state = const Unauthenticated();
  }

  Future<void> deleteAccount() async {
    state = const AuthLoading('Deleting account...');
    await _repository.deleteAccount();
    state = const Unauthenticated();
  }

  Future<void> markConsentAccepted() async {
    await _storage.setConsentGiven(true);
  }

  Future<bool> hasGivenConsent() async {
    return _storage.hasGivenConsent();
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  final storage = ref.watch(secureStorageProvider);
  return AuthNotifier(
    repository: repository,
    storage: storage,
  );
});
