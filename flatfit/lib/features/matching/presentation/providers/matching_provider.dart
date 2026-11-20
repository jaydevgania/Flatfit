import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/matching_data_source.dart';
import '../../data/matching_repository.dart';
import '../../domain/compatibility_engine.dart';

/// Supabase client provider (falls back safely if uninitialized).
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  try {
    return Supabase.instance.client;
  } catch (_) {
    // Return dummy client if offline / unit test
    return SupabaseClient('https://mock.supabase.co', 'dummy-key');
  }
});

/// Matching data source provider.
final matchingDataSourceProvider = Provider<MatchingDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return MatchingDataSource(client);
});

/// Matching repository provider.
final matchingRepositoryProvider = Provider<MatchingRepository>((ref) {
  final ds = ref.watch(matchingDataSourceProvider);
  return MatchingRepository(ds);
});

/// Current authenticated user ID (or active session ID).
final currentUserIdProvider = StateProvider<String>((ref) => 'user_current');

/// State for the precomputed matches feed.
class MatchesState {
  final List<MatchedProfile> matches;
  final bool isLoading;
  final String? errorMessage;
  final double minScoreFilter;
  final String? sortBy; // 'score', 'budget', 'distance'

  const MatchesState({
    this.matches = const [],
    this.isLoading = false,
    this.errorMessage,
    this.minScoreFilter = 0.0,
    this.sortBy = 'score',
  });

  MatchesState copyWith({
    List<MatchedProfile>? matches,
    bool? isLoading,
    String? errorMessage,
    double? minScoreFilter,
    String? sortBy,
  }) {
    return MatchesState(
      matches: matches ?? this.matches,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      minScoreFilter: minScoreFilter ?? this.minScoreFilter,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  /// Filtered and sorted matches list.
  List<MatchedProfile> get filteredMatches {
    final list = matches.where((m) => m.score >= minScoreFilter).toList();
    if (sortBy == 'score') {
      list.sort((a, b) => b.score.compareTo(a.score));
    } else if (sortBy == 'budget_asc') {
      list.sort((a, b) => a.profile.budgetMin.compareTo(b.profile.budgetMin));
    } else if (sortBy == 'budget_desc') {
      list.sort((a, b) => b.profile.budgetMax.compareTo(a.profile.budgetMax));
    }
    return list;
  }
}

/// Matches list notifier.
class MatchesNotifier extends StateNotifier<MatchesState> {
  final MatchingRepository _repository;
  final String _currentUserId;

  MatchesNotifier(this._repository, this._currentUserId) : super(const MatchesState()) {
    loadMatches();
  }

  Future<void> loadMatches() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final results = await _repository.getMatches(currentUserId: _currentUserId);
      state = state.copyWith(
        matches: results,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  void setMinScoreFilter(double minScore) {
    state = state.copyWith(minScoreFilter: minScore);
  }

  void setSortBy(String sortBy) {
    state = state.copyWith(sortBy: sortBy);
  }

  /// Logs outcome progression (matched -> met -> movedIn -> stayed).
  Future<void> logOutcome(String targetUserId, MatchOutcome outcome) async {
    await _repository.logOutcome(
      userA: _currentUserId,
      userB: targetUserId,
      outcome: outcome,
    );
  }

  /// Removes profile from current stack after swiping.
  void popTopMatch() {
    if (state.matches.isNotEmpty) {
      final updated = List<MatchedProfile>.from(state.matches)..removeAt(0);
      state = state.copyWith(matches: updated);
    }
  }
}

/// Matching provider exposing MatchesState and methods.
final matchesProvider =
    StateNotifierProvider<MatchesNotifier, MatchesState>((ref) {
  final repo = ref.watch(matchingRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);
  return MatchesNotifier(repo, userId);
});

/// Currently selected matched profile for detail inspection.
final selectedMatchProvider = StateProvider<MatchedProfile?>((ref) => null);
