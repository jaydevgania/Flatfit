import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/trust_repository.dart';
import '../../domain/trust_score_model.dart';

final trustRepositoryProvider = Provider<TrustRepository>((ref) {
  return TrustRepositoryImpl();
});

class TrustState {
  final TrustScore? trustScore;
  final bool isLoading;
  final String? errorMessage;

  const TrustState({
    this.trustScore,
    this.isLoading = false,
    this.errorMessage,
  });

  TrustState copyWith({
    TrustScore? trustScore,
    bool? isLoading,
    String? errorMessage,
  }) {
    return TrustState(
      trustScore: trustScore ?? this.trustScore,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class TrustNotifier extends StateNotifier<TrustState> {
  final TrustRepository _repository;
  final String currentUserId;

  TrustNotifier(this._repository, {this.currentUserId = 'current_user'})
      : super(const TrustState()) {
    loadTrustScore();
  }

  Future<void> loadTrustScore() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final score = await _repository.getTrustScore(currentUserId);
      state = state.copyWith(trustScore: score, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> recalculate() async {
    state = state.copyWith(isLoading: true);
    try {
      final updated = await _repository.recalculateTrustScore(currentUserId);
      state = state.copyWith(trustScore: updated, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}

final trustProvider =
    StateNotifierProvider<TrustNotifier, TrustState>((ref) {
  final repo = ref.watch(trustRepositoryProvider);
  return TrustNotifier(repo);
});
