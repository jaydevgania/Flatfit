import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../matching/domain/profile.dart';
import '../../matching/presentation/providers/matching_provider.dart';
import '../data/discovery_data_source.dart';
import '../data/discovery_repository.dart';
import 'filters_provider.dart';

final discoveryDataSourceProvider = Provider<DiscoveryDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return DiscoveryDataSource(client);
});

final discoveryRepositoryProvider = Provider<DiscoveryRepository>((ref) {
  final ds = ref.watch(discoveryDataSourceProvider);
  return DiscoveryRepository(ds);
});

enum DiscoveryViewMode { swipe, list }

class DiscoveryState {
  final List<Profile> profiles;
  final bool isLoading;
  final DiscoveryViewMode viewMode;
  final String? errorMessage;
  final Profile? selectedProfile;

  const DiscoveryState({
    this.profiles = const [],
    this.isLoading = false,
    this.viewMode = DiscoveryViewMode.swipe,
    this.errorMessage,
    this.selectedProfile,
  });

  DiscoveryState copyWith({
    List<Profile>? profiles,
    bool? isLoading,
    DiscoveryViewMode? viewMode,
    String? errorMessage,
    Profile? selectedProfile,
  }) {
    return DiscoveryState(
      profiles: profiles ?? this.profiles,
      isLoading: isLoading ?? this.isLoading,
      viewMode: viewMode ?? this.viewMode,
      errorMessage: errorMessage,
      selectedProfile: selectedProfile ?? this.selectedProfile,
    );
  }
}

class DiscoveryNotifier extends StateNotifier<DiscoveryState> {
  final DiscoveryRepository _repository;
  final String _currentUserId;
  final Ref _ref;

  DiscoveryNotifier(this._repository, this._currentUserId, this._ref)
      : super(const DiscoveryState()) {
    loadProfiles();
  }

  Future<void> loadProfiles() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final filters = _ref.read(filtersProvider);
      final list = await _repository.getProfiles(
        currentUserId: _currentUserId,
        filters: filters,
      );
      state = state.copyWith(
        profiles: list,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void toggleViewMode() {
    final nextMode = state.viewMode == DiscoveryViewMode.swipe
        ? DiscoveryViewMode.list
        : DiscoveryViewMode.swipe;
    state = state.copyWith(viewMode: nextMode);
  }

  void setViewMode(DiscoveryViewMode mode) {
    state = state.copyWith(viewMode: mode);
  }

  void selectProfile(Profile? profile) {
    state = state.copyWith(selectedProfile: profile);
  }

  /// Swipes left (pass)
  void swipeLeft(String profileId) {
    _removeTopCard(profileId);
  }

  /// Swipes right (interested)
  Future<void> swipeRight(String profileId, {String? note}) async {
    _removeTopCard(profileId);
    await _repository.sendInterest(
      fromUserId: _currentUserId,
      toUserId: profileId,
      note: note,
      isSuperInterest: false,
    );
  }

  /// Swipes up (super interest)
  Future<void> swipeUp(String profileId, {String? note}) async {
    _removeTopCard(profileId);
    await _repository.sendInterest(
      fromUserId: _currentUserId,
      toUserId: profileId,
      note: note ?? 'Starred you as a Super Interest! 🌟',
      isSuperInterest: true,
    );
  }

  void _removeTopCard(String profileId) {
    final updated = state.profiles.where((p) => p.id != profileId).toList();
    state = state.copyWith(profiles: updated);
  }
}

final discoveryProvider =
    StateNotifierProvider<DiscoveryNotifier, DiscoveryState>((ref) {
  final repo = ref.watch(discoveryRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);
  return DiscoveryNotifier(repo, userId, ref);
});
