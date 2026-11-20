import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/listing_repository.dart';
import '../../domain/listing_model.dart';
import '../../domain/listing_type.dart';
import 'listings_provider.dart';

class MyListingsState {
  final List<Listing> listings;
  final bool isLoading;
  final String? errorMessage;

  const MyListingsState({
    this.listings = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  MyListingsState copyWith({
    List<Listing>? listings,
    bool? isLoading,
    String? errorMessage,
  }) {
    return MyListingsState(
      listings: listings ?? this.listings,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class MyListingsNotifier extends StateNotifier<MyListingsState> {
  final ListingRepository _repository;
  final String currentUserId;

  MyListingsNotifier(this._repository, {this.currentUserId = 'user_ananya'})
      : super(const MyListingsState()) {
    loadMyListings();
  }

  Future<void> loadMyListings() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final list = await _repository.getMyListings(currentUserId);
      state = state.copyWith(listings: list, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> toggleStatus(String listingId, ListingStatus newStatus) async {
    await _repository.toggleListingStatus(listingId, newStatus);
    final updated = state.listings.map((l) {
      if (l.id == listingId) {
        return l.copyWith(status: newStatus);
      }
      return l;
    }).toList();
    state = state.copyWith(listings: updated);
  }

  Future<void> deleteListing(String listingId) async {
    await _repository.deleteListing(listingId);
    state = state.copyWith(
      listings: state.listings.where((l) => l.id != listingId).toList(),
    );
  }
}

final myListingsProvider =
    StateNotifierProvider<MyListingsNotifier, MyListingsState>((ref) {
  final repo = ref.watch(listingRepositoryProvider);
  return MyListingsNotifier(repo);
});
