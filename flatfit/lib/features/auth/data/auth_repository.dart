import 'package:flatfit/core/models/result.dart';
import 'package:flatfit/core/storage/secure_storage.dart';
import 'package:flatfit/features/auth/data/auth_remote_data_source.dart';
import 'package:flatfit/features/auth/domain/auth_models.dart';

abstract class AuthRepository {
  Future<Result<PhoneAuthResult>> sendPhoneOtp(String phoneNumber);
  Future<Result<FlatFitUser>> verifyPhoneOtp({
    required String phoneNumber,
    required String token,
  });
  Future<Result<FlatFitUser>> signInWithGoogle();
  Future<Result<FlatFitUser?>> getCurrentUser();
  Future<Result<bool>> checkProfileExists(String userId);
  Future<Result<void>> signOut();
  Future<Result<void>> deleteAccount();
}

class SupabaseAuthRepository implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorageService _secureStorage;

  SupabaseAuthRepository({
    required AuthRemoteDataSource remoteDataSource,
    required SecureStorageService secureStorage,
  })  : _remoteDataSource = remoteDataSource,
        _secureStorage = secureStorage;

  @override
  Future<Result<PhoneAuthResult>> sendPhoneOtp(String phoneNumber) async {
    try {
      final res = await _remoteDataSource.sendPhoneOtp(phoneNumber);
      return Result.success(res);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<FlatFitUser>> verifyPhoneOtp({
    required String phoneNumber,
    required String token,
  }) async {
    try {
      final user = await _remoteDataSource.verifyPhoneOtp(
        phoneNumber: phoneNumber,
        token: token,
      );
      await _secureStorage.saveUserId(user.id);
      return Result.success(user);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<FlatFitUser>> signInWithGoogle() async {
    try {
      final user = await _remoteDataSource.signInWithGoogle();
      await _secureStorage.saveUserId(user.id);
      return Result.success(user);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<FlatFitUser?>> getCurrentUser() async {
    try {
      final user = await _remoteDataSource.getCurrentUser();
      return Result.success(user);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<bool>> checkProfileExists(String userId) async {
    try {
      final hasProfile = await _remoteDataSource.checkProfileExists(userId);
      return Result.success(hasProfile);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      await _secureStorage.clearAll();
      return const Result.success(null);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<void>> deleteAccount() async {
    try {
      await _remoteDataSource.deleteAccount();
      await _secureStorage.clearAll();
      return const Result.success(null);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
