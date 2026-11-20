import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/city_guide.dart';
import '../../domain/event.dart';
import '../../domain/referral.dart';
import '../../domain/ambassador.dart';
import '../../data/community_repository.dart';

final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  return CommunityRepositoryImpl();
});

class CommunityState {
  final bool isLoading;
  final List<LocalityGuide> guides;
  final List<CommunityEvent> events;
  final UserReferralSummary? referralSummary;
  final List<AmbassadorProfile> ambassadors;
  final String? errorMessage;

  const CommunityState({
    this.isLoading = false,
    this.guides = const [],
    this.events = const [],
    this.referralSummary,
    this.ambassadors = const [],
    this.errorMessage,
  });

  CommunityState copyWith({
    bool? isLoading,
    List<LocalityGuide>? guides,
    List<CommunityEvent>? events,
    UserReferralSummary? referralSummary,
    List<AmbassadorProfile>? ambassadors,
    String? errorMessage,
  }) {
    return CommunityState(
      isLoading: isLoading ?? this.isLoading,
      guides: guides ?? this.guides,
      events: events ?? this.events,
      referralSummary: referralSummary ?? this.referralSummary,
      ambassadors: ambassadors ?? this.ambassadors,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class CommunityNotifier extends StateNotifier<CommunityState> {
  final CommunityRepository _repo;

  CommunityNotifier(this._repo) : super(const CommunityState()) {
    loadAll();
  }

  Future<void> loadAll() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final guides = await _repo.getCityGuides();
      final events = await _repo.getEvents();
      final referral = await _repo.getReferralSummary('user_1', 'Jay Sharma');
      final ambassadors = await _repo.getAmbassadors();

      state = state.copyWith(
        isLoading: false,
        guides: guides,
        events: events,
        referralSummary: referral,
        ambassadors: ambassadors,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> rsvpEvent(String eventId, RsvpStatus status) async {
    await _repo.toggleRsvp(eventId, status);
    final updatedEvents = await _repo.getEvents();
    state = state.copyWith(events: updatedEvents);
  }
}

final communityProvider = StateNotifierProvider<CommunityNotifier, CommunityState>((ref) {
  final repo = ref.watch(communityRepositoryProvider);
  return CommunityNotifier(repo);
});
