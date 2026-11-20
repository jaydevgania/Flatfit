import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/listing_repository.dart';
import '../../domain/listing_filters.dart';
import '../../domain/listing_model.dart';
import '../../domain/listing_type.dart';

final listingRepositoryProvider = Provider<ListingRepository>((ref) {
  return ListingRepositoryImpl();
});

enum ListingViewMode {
  list,
  map,
}

class ListingsState {
  final List<Listing> listings;
  final bool isLoading;
  final String? errorMessage;
  final ListingFilters filters;
  final ListingViewMode viewMode;
  final Listing? selectedListingForMap;
  final int page;
  final bool hasMore;

  const ListingsState({
    this.listings = const [],
    this.isLoading = false,
    this.errorMessage,
    this.filters = const ListingFilters(),
    this.viewMode = ListingViewMode.list,
    this.selectedListingForMap,
    this.page = 1,
    this.hasMore = true,
  });

  ListingsState copyWith({
    List<Listing>? listings,
    bool? isLoading,
    String? errorMessage,
    ListingFilters? filters,
    ListingViewMode? viewMode,
    Listing? selectedListingForMap,
    int? page,
    bool? hasMore,
  }) {
    return ListingsState(
      listings: listings ?? this.listings,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      filters: filters ?? this.filters,
      viewMode: viewMode ?? this.viewMode,
      selectedListingForMap:
          selectedListingForMap ?? this.selectedListingForMap,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class ListingsNotifier extends StateNotifier<ListingsState> {
  final ListingRepository _repository;

  ListingsNotifier(this._repository) : super(const ListingsState()) {
    fetchListings();
  }

  Future<void> fetchListings({bool refresh = false}) async {
    if (refresh) {
      state = state.copyWith(isLoading: true, page: 1, hasMore: true);
    } else {
      state = state.copyWith(isLoading: true);
    }

    try {
      final results = await _repository.getListings(
        filters: state.filters,
        page: state.page,
      );

      state = state.copyWith(
        listings: refresh ? results : [...state.listings, ...results],
        isLoading: false,
        hasMore: results.length >= 20,
        page: state.page + 1,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void updateFilters(ListingFilters newFilters) {
    state = state.copyWith(filters: newFilters);
    fetchListings(refresh: true);
  }

  void toggleViewMode() {
    state = state.copyWith(
      viewMode: state.viewMode == ListingViewMode.list
          ? ListingViewMode.map
          : ListingViewMode.list,
    );
  }

  void selectListingForMap(Listing? listing) {
    state = state.copyWith(selectedListingForMap: listing);
  }

  void toggleSubletOnly() {
    updateFilters(state.filters.copyWith(
      isSubletOnly: !state.filters.isSubletOnly,
    ));
  }

  void toggleVerifiedOnly() {
    updateFilters(state.filters.copyWith(
      isVerifiedOnly: !state.filters.isVerifiedOnly,
    ));
  }
}

final listingsProvider =
    StateNotifierProvider<ListingsNotifier, ListingsState>((ref) {
  final repository = ref.watch(listingRepositoryProvider);
  return ListingsNotifier(repository);
});
