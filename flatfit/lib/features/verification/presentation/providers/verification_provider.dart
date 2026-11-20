import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/verification_repository.dart';
import '../../domain/verification_model.dart';
import '../../domain/verification_type.dart';

final verificationRepositoryProvider = Provider<VerificationRepository>((ref) {
  return VerificationRepositoryImpl();
});

class VerificationState {
  final List<UserVerification> verifications;
  final bool isLoading;
  final String? errorMessage;
  final bool isSubmitting;

  const VerificationState({
    this.verifications = const [],
    this.isLoading = false,
    this.errorMessage,
    this.isSubmitting = false,
  });

  UserVerification? getVerification(VerificationType type) {
    try {
      return verifications.firstWhere((v) => v.type == type);
    } catch (_) {
      return null;
    }
  }

  VerificationState copyWith({
    List<UserVerification>? verifications,
    bool? isLoading,
    String? errorMessage,
    bool? isSubmitting,
  }) {
    return VerificationState(
      verifications: verifications ?? this.verifications,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

class VerificationNotifier extends StateNotifier<VerificationState> {
  final VerificationRepository _repository;
  final String currentUserId;

  VerificationNotifier(this._repository, {this.currentUserId = 'current_user'})
      : super(const VerificationState()) {
    loadVerifications();
  }

  Future<void> loadVerifications() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final list = await _repository.getVerifications(currentUserId);
      state = state.copyWith(verifications: list, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<bool> submitKyc({
    required String idType,
    required String maskedIdNumber,
    required String idPhotoUrl,
    required String selfiePhotoUrl,
  }) async {
    state = state.copyWith(isSubmitting: true);
    try {
      final verified = await _repository.submitKycVerification(
        userId: currentUserId,
        idType: idType,
        maskedIdNumber: maskedIdNumber,
        idPhotoUrl: idPhotoUrl,
        selfiePhotoUrl: selfiePhotoUrl,
      );

      final updated = state.verifications.where((v) => v.type != VerificationType.kyc).toList();
      updated.add(verified);

      state = state.copyWith(verifications: updated, isSubmitting: false);
      return true;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> verifyEmailOtp(String otp, {required bool isCollege}) async {
    state = state.copyWith(isSubmitting: true);
    try {
      final verified = await _repository.verifyEmailOtp(
        userId: currentUserId,
        otp: otp,
        isCollege: isCollege,
      );

      final updated = state.verifications.where((v) => v.type != verified.type).toList();
      updated.add(verified);

      state = state.copyWith(verifications: updated, isSubmitting: false);
      return true;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> linkLinkedIn(String profileUrl) async {
    state = state.copyWith(isSubmitting: true);
    try {
      final verified = await _repository.submitLinkedInVerification(
        userId: currentUserId,
        linkedInUrl: profileUrl,
      );

      final updated = state.verifications.where((v) => v.type != VerificationType.linkedin).toList();
      updated.add(verified);

      state = state.copyWith(verifications: updated, isSubmitting: false);
      return true;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, errorMessage: e.toString());
      return false;
    }
  }
}

final verificationProvider =
    StateNotifierProvider<VerificationNotifier, VerificationState>((ref) {
  final repo = ref.watch(verificationRepositoryProvider);
  return VerificationNotifier(repo);
});
