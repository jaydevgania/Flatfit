import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/service_partner.dart';
import '../../domain/service_bundle.dart';
import '../../domain/service_booking.dart';
import '../../data/marketplace_repository.dart';

final marketplaceRepositoryProvider = Provider<MarketplaceRepository>((ref) {
  return MarketplaceRepositoryImpl();
});

class MarketplaceState {
  final bool isLoading;
  final ServiceCategory? selectedCategory;
  final String searchQuery;
  final List<ServicePartner> partners;
  final List<ServiceBundle> bundles;
  final List<ServiceBooking> myBookings;
  final String? errorMessage;

  const MarketplaceState({
    this.isLoading = false,
    this.selectedCategory,
    this.searchQuery = '',
    this.partners = const [],
    this.bundles = const [],
    this.myBookings = const [],
    this.errorMessage,
  });

  MarketplaceState copyWith({
    bool? isLoading,
    ServiceCategory? selectedCategory,
    bool clearCategory = false,
    String? searchQuery,
    List<ServicePartner>? partners,
    List<ServiceBundle>? bundles,
    List<ServiceBooking>? myBookings,
    String? errorMessage,
  }) {
    return MarketplaceState(
      isLoading: isLoading ?? this.isLoading,
      selectedCategory: clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      searchQuery: searchQuery ?? this.searchQuery,
      partners: partners ?? this.partners,
      bundles: bundles ?? this.bundles,
      myBookings: myBookings ?? this.myBookings,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class MarketplaceNotifier extends StateNotifier<MarketplaceState> {
  final MarketplaceRepository _repo;

  MarketplaceNotifier(this._repo) : super(const MarketplaceState()) {
    loadData();
  }

  Future<void> loadData() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final partners = await _repo.getPartners(
        category: state.selectedCategory,
        query: state.searchQuery,
      );
      final bundles = await _repo.getBundles();
      final bookings = await _repo.getUserBookings('current_user_1');
      state = state.copyWith(
        isLoading: false,
        partners: partners,
        bundles: bundles,
        myBookings: bookings,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void filterCategory(ServiceCategory? category) {
    if (state.selectedCategory == category) {
      state = state.copyWith(clearCategory: true);
    } else {
      state = state.copyWith(selectedCategory: category);
    }
    loadData();
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    loadData();
  }

  Future<bool> bookPartner({
    required ServicePartner partner,
    required ServiceTier tier,
    required DateTime date,
    required BookingTimeSlot slot,
    required String address,
    required String phone,
    String? notes,
  }) async {
    try {
      final base = tier.price;
      final gst = base * 0.18;
      final total = base + gst;
      final commission = base * (partner.commissionPct / 100);

      final booking = ServiceBooking(
        id: 'bk_${DateTime.now().millisecondsSinceEpoch}',
        partnerId: partner.id,
        partnerName: partner.name,
        category: partner.category,
        userId: 'current_user_1',
        scheduledDate: date,
        slot: slot,
        serviceAddress: address,
        contactPhone: phone,
        baseAmount: base,
        gstAmount: gst,
        totalAmount: total,
        flatfitCommissionAmount: commission,
        notes: notes,
        status: BookingStatus.confirmed,
        bookedAt: DateTime.now(),
      );

      await _repo.createBooking(booking);
      await loadData();
      return true;
    } catch (_) {
      return false;
    }
  }
}

final marketplaceProvider =
    StateNotifierProvider<MarketplaceNotifier, MarketplaceState>((ref) {
  final repo = ref.watch(marketplaceRepositoryProvider);
  return MarketplaceNotifier(repo);
});
