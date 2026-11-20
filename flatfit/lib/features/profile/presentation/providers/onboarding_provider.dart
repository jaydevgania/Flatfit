import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/housing_goal.dart';
import '../../domain/occupation_type.dart';
import '../../domain/profile_model.dart';
import 'profile_provider.dart';

/// Steps in the onboarding wizard
enum OnboardingStep {
  basicInfo,
  housingGoal,
  budgetLocation,
  photos,
  bio,
  completion,
}

/// Onboarding state model holding draft profile information
class OnboardingDraftState {
  final int currentStepIndex;
  final String fullName;
  final int? age;
  final String? gender;
  final OccupationType? occupation;
  final String? city;
  final HousingGoal? housingGoal;
  final int budgetMin;
  final int budgetMax;
  final List<String> preferredLocalities;
  final DateTime? moveInDate;
  final String? stayDuration;
  final String bio;
  final List<String> localPhotoPaths;
  final bool isSubmitting;
  final String? errorMessage;

  const OnboardingDraftState({
    this.currentStepIndex = 0,
    this.fullName = '',
    this.age,
    this.gender,
    this.occupation,
    this.city,
    this.housingGoal,
    this.budgetMin = 10000,
    this.budgetMax = 25000,
    this.preferredLocalities = const [],
    this.moveInDate,
    this.stayDuration = '12+ months',
    this.bio = '',
    this.localPhotoPaths = const [],
    this.isSubmitting = false,
    this.errorMessage,
  });

  OnboardingStep get currentStep => OnboardingStep.values[currentStepIndex];

  bool get isBasicInfoValid =>
      fullName.trim().isNotEmpty &&
      age != null &&
      age! >= 18 &&
      gender != null &&
      occupation != null &&
      city != null &&
      city!.trim().isNotEmpty;

  bool get isHousingGoalValid => housingGoal != null;

  bool get isBudgetLocationValid =>
      budgetMin > 0 &&
      budgetMax >= budgetMin &&
      preferredLocalities.isNotEmpty;

  bool get isPhotosValid => localPhotoPaths.isNotEmpty;

  bool get isBioValid => bio.trim().length >= 20;

  bool get canProceed {
    switch (currentStep) {
      case OnboardingStep.basicInfo:
        return isBasicInfoValid;
      case OnboardingStep.housingGoal:
        return isHousingGoalValid;
      case OnboardingStep.budgetLocation:
        return isBudgetLocationValid;
      case OnboardingStep.photos:
        return isPhotosValid;
      case OnboardingStep.bio:
        return isBioValid;
      case OnboardingStep.completion:
        return true;
    }
  }

  double get progress => (currentStepIndex + 1) / OnboardingStep.values.length;

  OnboardingDraftState copyWith({
    int? currentStepIndex,
    String? fullName,
    int? age,
    String? gender,
    OccupationType? occupation,
    String? city,
    HousingGoal? housingGoal,
    int? budgetMin,
    int? budgetMax,
    List<String>? preferredLocalities,
    DateTime? moveInDate,
    String? stayDuration,
    String bio,
    List<String>? localPhotoPaths,
    bool? isSubmitting,
    String? errorMessage,
  }) {
    return OnboardingDraftState(
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      fullName: fullName ?? this.fullName,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      occupation: occupation ?? this.occupation,
      city: city ?? this.city,
      housingGoal: housingGoal ?? this.housingGoal,
      budgetMin: budgetMin ?? this.budgetMin,
      budgetMax: budgetMax ?? this.budgetMax,
      preferredLocalities: preferredLocalities ?? this.preferredLocalities,
      moveInDate: moveInDate ?? this.moveInDate,
      stayDuration: stayDuration ?? this.stayDuration,
      bio: bio ?? this.bio,
      localPhotoPaths: localPhotoPaths ?? this.localPhotoPaths,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
    );
  }
}

/// State notifier for managing onboarding flow
class OnboardingNotifier extends StateNotifier<OnboardingDraftState> {
  final Ref _ref;

  OnboardingNotifier(this._ref) : super(const OnboardingDraftState());

  void setBasicInfo({
    required String fullName,
    required int age,
    required String gender,
    required OccupationType occupation,
    required String city,
  }) {
    state = state.copyWith(
      fullName: fullName,
      age: age,
      gender: gender,
      occupation: occupation,
      city: city,
    );
  }

  void setHousingGoal(HousingGoal goal) {
    state = state.copyWith(housingGoal: goal);
  }

  void setBudgetAndLocation({
    required int budgetMin,
    required int budgetMax,
    required List<String> localities,
    DateTime? moveInDate,
    String? stayDuration,
  }) {
    state = state.copyWith(
      budgetMin: budgetMin,
      budgetMax: budgetMax,
      preferredLocalities: localities,
      moveInDate: moveInDate,
      stayDuration: stayDuration,
    );
  }

  void addLocalPhoto(String path) {
    if (state.localPhotoPaths.length < 5) {
      state = state.copyWith(
        localPhotoPaths: [...state.localPhotoPaths, path],
      );
    }
  }

  void removeLocalPhoto(int index) {
    if (index >= 0 && index < state.localPhotoPaths.length) {
      final updated = List<String>.from(state.localPhotoPaths)..removeAt(index);
      state = state.copyWith(localPhotoPaths: updated);
    }
  }

  void setBio(String bio) {
    state = state.copyWith(bio: bio);
  }

  void nextStep() {
    if (state.currentStepIndex < OnboardingStep.values.length - 1) {
      state = state.copyWith(
        currentStepIndex: state.currentStepIndex + 1,
      );
    }
  }

  void previousStep() {
    if (state.currentStepIndex > 0) {
      state = state.copyWith(
        currentStepIndex: state.currentStepIndex - 1,
      );
    }
  }

  void jumpToStep(int index) {
    if (index >= 0 && index < OnboardingStep.values.length) {
      state = state.copyWith(currentStepIndex: index);
    }
  }

  /// Finalize and save the profile
  Future<bool> completeOnboarding() async {
    state = state.copyWith(isSubmitting: true, errorMessage: null);

    try {
      final repository = _ref.read(profileRepositoryProvider);
      final userId = repository.currentUserId;
      if (userId == null) {
        throw Exception('User is not authenticated');
      }

      final profile = Profile(
        id: userId,
        fullName: state.fullName,
        age: state.age,
        gender: state.gender,
        occupation: state.occupation,
        city: state.city,
        bio: state.bio,
        housingGoal: state.housingGoal,
        budgetMin: state.budgetMin,
        budgetMax: state.budgetMax,
        preferredLocalities: state.preferredLocalities,
        moveInDate: state.moveInDate,
        stayDuration: state.stayDuration,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await repository.saveProfile(profile);

      // Refresh global profile provider
      await _ref.read(profileProvider.notifier).loadProfile(userId: userId);

      state = state.copyWith(isSubmitting: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }
}

/// Provider for onboarding wizard
final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingDraftState>((ref) {
  return OnboardingNotifier(ref);
});
