import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/review_repository.dart';
import '../../domain/review_model.dart';

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return ReviewRepositoryImpl();
});

class ReviewState {
  final List<UserReview> reviews;
  final bool isLoading;
  final bool isSubmitting;
  final String? errorMessage;
  final String? filterTag;

  const ReviewState({
    this.reviews = const [],
    this.isLoading = false,
    this.isSubmitting = false,
    this.errorMessage,
    this.filterTag,
  });

  List<UserReview> get filteredReviews {
    if (filterTag == null || filterTag!.isEmpty) return reviews;
    return reviews.where((r) => r.tags.contains(filterTag)).toList();
  }

  double get averageRating {
    if (reviews.isEmpty) return 5.0;
    final sum = reviews.fold<int>(0, (acc, r) => acc + r.rating);
    return sum / reviews.length;
  }

  ReviewState copyWith({
    List<UserReview>? reviews,
    bool? isLoading,
    bool? isSubmitting,
    String? errorMessage,
    String? filterTag,
  }) {
    return ReviewState(
      reviews: reviews ?? this.reviews,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
      filterTag: filterTag ?? this.filterTag,
    );
  }
}

class ReviewNotifier extends StateNotifier<ReviewState> {
  final ReviewRepository _repository;
  final String targetUserId;

  ReviewNotifier(this._repository, {required this.targetUserId})
      : super(const ReviewState()) {
    loadReviews();
  }

  Future<void> loadReviews() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final list = await _repository.getReviewsForUser(targetUserId);
      state = state.copyWith(reviews: list, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void setFilterTag(String? tag) {
    if (state.filterTag == tag) {
      state = state.copyWith(filterTag: null);
    } else {
      state = state.copyWith(filterTag: tag);
    }
  }

  Future<bool> submitReview(UserReview review) async {
    state = state.copyWith(isSubmitting: true);
    try {
      final created = await _repository.submitReview(review);
      state = state.copyWith(
        reviews: [created, ...state.reviews],
        isSubmitting: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, errorMessage: e.toString());
      return false;
    }
  }
}

final reviewProvider =
    StateNotifierProvider.family<ReviewNotifier, ReviewState, String>(
        (ref, userId) {
  final repo = ref.watch(reviewRepositoryProvider);
  return ReviewNotifier(repo, targetUserId: userId);
});
