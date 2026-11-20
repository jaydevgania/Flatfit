import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/llm_client.dart';
import '../../data/llm_client_impl.dart';
import '../../domain/profile_coach.dart';
import '../../domain/ai_interviewer.dart';
import '../../domain/conversation_safety.dart';
import '../../domain/listing_authenticity.dart';
import '../../domain/conflict_mediator.dart';

/// Base provider for privacy-filtered LLM client.
final llmClientProvider = Provider<LlmClient>((ref) {
  // Defaults to privacy-filtered mock client for safe, robust execution
  return PrivacyFilteringLlmClient(MockLlmClient());
});

/// State of the AI Profile Coach.
class ProfileCoachState {
  final bool isLoading;
  final ProfileCoachResult? result;
  final String? errorMessage;
  final BioTone selectedTone;

  const ProfileCoachState({
    this.isLoading = false,
    this.result,
    this.errorMessage,
    this.selectedTone = BioTone.warmFriendly,
  });

  ProfileCoachState copyWith({
    bool? isLoading,
    ProfileCoachResult? result,
    String? errorMessage,
    BioTone? selectedTone,
  }) {
    return ProfileCoachState(
      isLoading: isLoading ?? this.isLoading,
      result: result ?? this.result,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedTone: selectedTone ?? this.selectedTone,
    );
  }
}

class ProfileCoachNotifier extends StateNotifier<ProfileCoachState> {
  ProfileCoachNotifier() : super(const ProfileCoachState());

  void analyze({
    required String bio,
    required int photoCount,
    required bool hasVoiceIntro,
    required bool hasKycVerified,
    required bool hasWorkEmailVerified,
    String? occupation,
    String? city,
  }) {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final res = ProfileCoachEngine.analyzeProfile(
        bio: bio,
        photoCount: photoCount,
        hasVoiceIntro: hasVoiceIntro,
        hasKycVerified: hasKycVerified,
        hasWorkEmailVerified: hasWorkEmailVerified,
        occupation: occupation,
        city: city,
      );
      state = state.copyWith(isLoading: false, result: res);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void selectTone(BioTone tone) {
    state = state.copyWith(selectedTone: tone);
  }
}

final profileCoachProvider = StateNotifierProvider<ProfileCoachNotifier, ProfileCoachState>((ref) {
  return ProfileCoachNotifier();
});

/// State of the Conflict Mediator.
class ConflictMediatorState {
  final bool isProcessing;
  final MediatedMessageResult? result;
  final MediatorTone selectedTone;

  const ConflictMediatorState({
    this.isProcessing = false,
    this.result,
    this.selectedTone = MediatorTone.gentleFriendly,
  });

  ConflictMediatorState copyWith({
    bool? isProcessing,
    MediatedMessageResult? result,
    MediatorTone? selectedTone,
  }) {
    return ConflictMediatorState(
      isProcessing: isProcessing ?? this.isProcessing,
      result: result ?? this.result,
      selectedTone: selectedTone ?? this.selectedTone,
    );
  }
}

class ConflictMediatorNotifier extends StateNotifier<ConflictMediatorState> {
  ConflictMediatorNotifier() : super(const ConflictMediatorState());

  void mediate(String rawText) {
    if (rawText.trim().isEmpty) return;
    state = state.copyWith(isProcessing: true);
    final res = ConflictMediatorEngine.mediateMessage(rawText);
    state = state.copyWith(isProcessing: false, result: res);
  }

  void setTone(MediatorTone tone) {
    state = state.copyWith(selectedTone: tone);
  }
}

final conflictMediatorProvider =
    StateNotifierProvider<ConflictMediatorNotifier, ConflictMediatorState>((ref) {
  return ConflictMediatorNotifier();
});

/// Conversation safety scanner provider.
final conversationSafetyScannerProvider = Provider<ConversationSafetyEngine>((ref) {
  return ConversationSafetyEngine();
});
