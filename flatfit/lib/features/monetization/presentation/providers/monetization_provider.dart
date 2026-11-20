import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/subscription.dart';
import '../../domain/verified_listing_fee.dart';
import '../../domain/concierge_service.dart';
import '../../data/monetization_repository.dart';

final monetizationRepositoryProvider = Provider<MonetizationRepository>((ref) {
  return MonetizationRepositoryImpl();
});

class MonetizationState {
  final bool isLoading;
  final UserSubscription subscription;
  final BillingPeriod selectedPeriod;
  final List<ConciergeRequest> conciergeRequests;
  final String? errorMessage;

  const MonetizationState({
    this.isLoading = false,
    this.subscription = const UserSubscription(userId: 'current_user_1'),
    this.selectedPeriod = BillingPeriod.quarterly,
    this.conciergeRequests = const [],
    this.errorMessage,
  });

  MonetizationState copyWith({
    bool? isLoading,
    UserSubscription? subscription,
    BillingPeriod? selectedPeriod,
    List<ConciergeRequest>? conciergeRequests,
    String? errorMessage,
  }) {
    return MonetizationState(
      isLoading: isLoading ?? this.isLoading,
      subscription: subscription ?? this.subscription,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      conciergeRequests: conciergeRequests ?? this.conciergeRequests,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class MonetizationNotifier extends StateNotifier<MonetizationState> {
  final MonetizationRepository _repo;

  MonetizationNotifier(this._repo) : super(const MonetizationState()) {
    loadSubscription();
  }

  Future<void> loadSubscription() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final sub = await _repo.getUserSubscription('current_user_1');
      final requests = await _repo.getUserConciergeRequests('current_user_1');
      state = state.copyWith(isLoading: false, subscription: sub, conciergeRequests: requests);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void selectPeriod(BillingPeriod period) {
    state = state.copyWith(selectedPeriod: period);
  }

  Future<bool> upgradeToPlus(BillingPeriod period) async {
    state = state.copyWith(isLoading: true);
    try {
      final updatedSub = await _repo.upgradeToPlus('current_user_1', period, 'pay_mock_${DateTime.now().millisecondsSinceEpoch}');
      state = state.copyWith(isLoading: false, subscription: updatedSub);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> requestConcierge(ConciergeRequest req) async {
    try {
      final saved = await _repo.submitConciergeRequest(req);
      state = state.copyWith(conciergeRequests: [saved, ...state.conciergeRequests]);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> buyVerifiedListingBadge(String listingId) async {
    try {
      await _repo.purchaseVerifiedListingBadge(listingId, 'current_user_1', 'pay_ver_${DateTime.now().millisecondsSinceEpoch}');
      return true;
    } catch (_) {
      return false;
    }
  }
}

final monetizationProvider = StateNotifierProvider<MonetizationNotifier, MonetizationState>((ref) {
  final repo = ref.watch(monetizationRepositoryProvider);
  return MonetizationNotifier(repo);
});
