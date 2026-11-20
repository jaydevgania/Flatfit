import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/meet_repository.dart';
import '../../domain/chat_enums.dart';
import '../../domain/meet_model.dart';

final meetRepositoryProvider = Provider<MeetRepository>((ref) {
  return MeetRepositoryImpl();
});

class MeetState {
  final MeetUp? currentMeet;
  final List<PublicPlaceSuggestion> suggestedPlaces;
  final PublicPlaceSuggestion? selectedPlace;
  final DateTime? selectedDate;
  final bool isLiveLocationEnabled;
  final String trustedContactPhone;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  const MeetState({
    this.currentMeet,
    this.suggestedPlaces = const [],
    this.selectedPlace,
    this.selectedDate,
    this.isLiveLocationEnabled = false,
    this.trustedContactPhone = '',
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  MeetState copyWith({
    MeetUp? currentMeet,
    List<PublicPlaceSuggestion>? suggestedPlaces,
    PublicPlaceSuggestion? selectedPlace,
    DateTime? selectedDate,
    bool? isLiveLocationEnabled,
    String? trustedContactPhone,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return MeetState(
      currentMeet: currentMeet ?? this.currentMeet,
      suggestedPlaces: suggestedPlaces ?? this.suggestedPlaces,
      selectedPlace: selectedPlace ?? this.selectedPlace,
      selectedDate: selectedDate ?? this.selectedDate,
      isLiveLocationEnabled:
          isLiveLocationEnabled ?? this.isLiveLocationEnabled,
      trustedContactPhone:
          trustedContactPhone ?? this.trustedContactPhone,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
    );
  }
}

class MeetNotifier extends StateNotifier<MeetState> {
  final MeetRepository _repository;
  final String conversationId;

  MeetNotifier(this._repository, {required this.conversationId})
      : super(const MeetState()) {
    init();
  }

  Future<void> init() async {
    state = state.copyWith(isLoading: true);
    try {
      final meet = await _repository.getMeetForConversation(conversationId);
      final places = await _repository.getSuggestedPublicPlaces(
        userALocality: 'Bandra West',
        userBLocality: 'Andheri West',
      );
      state = state.copyWith(
        currentMeet: meet,
        suggestedPlaces: places,
        selectedPlace: places.isNotEmpty ? places.first : null,
        selectedDate: DateTime.now().add(const Duration(days: 2, hours: 2)),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void selectPlace(PublicPlaceSuggestion place) {
    state = state.copyWith(selectedPlace: place);
  }

  void selectDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  void toggleLiveLocation(bool enabled, {String? contactPhone}) {
    state = state.copyWith(
      isLiveLocationEnabled: enabled,
      trustedContactPhone: contactPhone ?? state.trustedContactPhone,
    );
  }

  Future<bool> confirmMeet({
    required String hostId,
    required String participantId,
    String? notes,
  }) async {
    if (state.selectedPlace == null || state.selectedDate == null) return false;

    state = state.copyWith(isLoading: true, isSuccess: false);
    try {
      final meet = MeetUp(
        id: 'meet_${DateTime.now().millisecondsSinceEpoch}',
        conversationId: conversationId,
        hostId: hostId,
        participantId: participantId,
        scheduledTime: state.selectedDate!,
        placeName: state.selectedPlace!.name,
        address: state.selectedPlace!.address,
        latitude: state.selectedPlace!.latitude,
        longitude: state.selectedPlace!.longitude,
        isPublicPlace: true,
        isLiveLocationShared: state.isLiveLocationEnabled,
        trustedContactPhone: state.trustedContactPhone,
        notes: notes,
        createdAt: DateTime.now(),
      );

      final scheduled = await _repository.scheduleMeet(meet);
      state = state.copyWith(
        currentMeet: scheduled,
        isLoading: false,
        isSuccess: true,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }
}

final meetProvider =
    StateNotifierProvider.family<MeetNotifier, MeetState, String>(
        (ref, conversationId) {
  final repository = ref.watch(meetRepositoryProvider);
  return MeetNotifier(repository, conversationId: conversationId);
});
