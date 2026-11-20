import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../matching/domain/profile.dart';
import '../../matching/presentation/providers/matching_provider.dart';
import 'discovery_provider.dart';

class ShortlistState {
  final List<Profile> shortlisted;
  final Set<String> shortlistedIds;
  final List<Profile> selectedForCompare;
  final bool isLoading;
  final String? errorMessage;

  const ShortlistState({
    this.shortlisted = const [],
    this.shortlistedIds = const {},
    this.selectedForCompare = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  ShortlistState copyWith({
    List<Profile>? shortlisted,
    Set<String>? shortlistedIds,
    List<Profile>? selectedForCompare,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ShortlistState(
      shortlisted: shortlisted ?? this.shortlisted,
      shortlistedIds: shortlistedIds ?? this.shortlistedIds,
      selectedForCompare: selectedForCompare ?? this.selectedForCompare,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class ShortlistNotifier extends StateNotifier<ShortlistState> {
  final Ref _ref;

  ShortlistNotifier(this._ref) : super(const ShortlistState()) {
    loadShortlist();
  }

  Future<void> loadShortlist() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = _ref.read(discoveryRepositoryProvider);
      final userId = _ref.read(currentUserIdProvider);

      final list = await repo.getShortlistedProfiles(userId);
      final ids = list.map((p) => p.id).toSet();

      state = state.copyWith(
        shortlisted: list,
        shortlistedIds: ids,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> toggleShortlist(Profile profile) async {
    final repo = _ref.read(discoveryRepositoryProvider);
    final userId = _ref.read(currentUserIdProvider);

    final isAlready = state.shortlistedIds.contains(profile.id);
    final newIds = Set<String>.from(state.shortlistedIds);
    final newList = List<Profile>.from(state.shortlisted);

    if (isAlready) {
      newIds.remove(profile.id);
      newList.removeWhere((p) => p.id == profile.id);
      // also remove from compare if present
      final compareList = List<Profile>.from(state.selectedForCompare)
        ..removeWhere((p) => p.id == profile.id);
      state = state.copyWith(
        shortlisted: newList,
        shortlistedIds: newIds,
        selectedForCompare: compareList,
      );
    } else {
      newIds.add(profile.id);
      newList.add(profile);
      state = state.copyWith(
        shortlisted: newList,
        shortlistedIds: newIds,
      );
    }

    await repo.toggleShortlist(userId: userId, targetUserId: profile.id);
  }

  bool isShortlisted(String profileId) {
    return state.shortlistedIds.contains(profileId);
  }

  /// Toggles selection of a profile for comparison (maximum 3 allowed).
  void toggleSelectForCompare(Profile profile) {
    final list = List<Profile>.from(state.selectedForCompare);
    final index = list.indexWhere((p) => p.id == profile.id);
    if (index >= 0) {
      list.removeAt(index);
    } else {
      if (list.length < 3) {
        list.add(profile);
      }
    }
    state = state.copyWith(selectedForCompare: list);
  }

  void clearCompareSelection() {
    state = state.copyWith(selectedForCompare: const []);
  }
}

final shortlistProvider =
    StateNotifierProvider<ShortlistNotifier, ShortlistState>((ref) {
  return ShortlistNotifier(ref);
});
