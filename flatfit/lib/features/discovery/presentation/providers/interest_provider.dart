import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flatfit/features/matching/presentation/providers/matching_provider.dart';
import 'package:flatfit/features/discovery/domain/interest_model.dart';
import 'discovery_provider.dart';

class InterestState {
  final List<InterestModel> incoming;
  final List<InterestModel> outgoing;
  final bool isLoading;
  final String? errorMessage;

  const InterestState({
    this.incoming = const [],
    this.outgoing = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  InterestState copyWith({
    List<InterestModel>? incoming,
    List<InterestModel>? outgoing,
    bool? isLoading,
    String? errorMessage,
  }) {
    return InterestState(
      incoming: incoming ?? this.incoming,
      outgoing: outgoing ?? this.outgoing,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class InterestNotifier extends StateNotifier<InterestState> {
  final Ref _ref;

  InterestNotifier(this._ref) : super(const InterestState()) {
    loadInterests();
  }

  Future<void> loadInterests() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = _ref.read(discoveryRepositoryProvider);
      final userId = _ref.read(currentUserIdProvider);

      final inList = await repo.getIncomingInterests(userId);
      final outList = await repo.getOutgoingInterests(userId);

      state = state.copyWith(
        incoming: inList,
        outgoing: outList,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> sendInterest({
    required String targetUserId,
    String? note,
    bool isSuperInterest = false,
  }) async {
    final repo = _ref.read(discoveryRepositoryProvider);
    final userId = _ref.read(currentUserIdProvider);

    await repo.sendInterest(
      fromUserId: userId,
      toUserId: targetUserId,
      note: note,
      isSuperInterest: isSuperInterest,
    );
    await loadInterests();
  }

  Future<void> respondToInterest({
    required String interestId,
    required bool accept,
  }) async {
    final repo = _ref.read(discoveryRepositoryProvider);
    await repo.respondToInterest(
      interestId: interestId,
      status: accept ? 'accepted' : 'declined',
    );
    await loadInterests();
  }
}

final interestProvider =
    StateNotifierProvider<InterestNotifier, InterestState>((ref) {
  return InterestNotifier(ref);
});
