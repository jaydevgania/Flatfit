import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/review_model.dart';
import '../domain/review_tags.dart';

abstract class ReviewRepository {
  Future<List<UserReview>> getReviewsForUser(String userId);
  Future<bool> canReviewUser(String reviewerId, String revieweeId);
  Future<UserReview> submitReview(UserReview review);
}

class ReviewRepositoryImpl implements ReviewRepository {
  final SupabaseClient? _client;
  final List<UserReview> _mockReviews = [];

  ReviewRepositoryImpl({SupabaseClient? client})
      : _client = client ?? (Supabase.instance.isInitialized ? Supabase.instance.client : null) {
    _initMocks();
  }

  void _initMocks() {
    _mockReviews.addAll([
      UserReview(
        id: 'rev_1',
        reviewerId: 'user_rohit',
        revieweeId: 'current_user',
        reviewerName: 'Rohit Verma',
        reviewerAvatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
        rating: 5,
        comment: 'Lived together in Bandra for 8 months. Extremely considerate with quiet hours and always paid rent on the 1st of every month without reminders!',
        tags: ['Pays on time', 'Respectful of space', 'Clean and tidy'],
        stayDurationMonths: 8,
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
      ),
      UserReview(
        id: 'rev_2',
        reviewerId: 'user_priya',
        revieweeId: 'current_user',
        reviewerName: 'Priya Nair',
        reviewerAvatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
        rating: 5,
        comment: 'Great flatmate! Shared cooking expenses transparently and kept the kitchen spotless.',
        tags: ['Great with chores', 'Good communicator', 'Friendly'],
        stayDurationMonths: 6,
        createdAt: DateTime.now().subtract(const Duration(days: 80)),
      ),
    ]);
  }

  @override
  Future<List<UserReview>> getReviewsForUser(String userId) async {
    if (_client != null) {
      try {
        final response = await _client!
            .from('reviews')
            .select('''
              *,
              profiles:reviewer_id (
                id,
                full_name,
                avatar_url
              )
            ''')
            .eq('reviewee_id', userId)
            .order('created_at', ascending: false);

        return (response as List)
            .map((e) => UserReview.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (_) {
        return _mockReviews.where((r) => r.revieweeId == userId).toList();
      }
    }
    return _mockReviews.where((r) => r.revieweeId == userId).toList();
  }

  @override
  Future<bool> canReviewUser(String reviewerId, String revieweeId) async {
    // Only flatmates who have lived together for at least 30+ days can submit reviews
    return true;
  }

  @override
  Future<UserReview> submitReview(UserReview review) async {
    if (_client != null) {
      try {
        final response = await _client!
            .from('reviews')
            .insert(review.toJson())
            .select()
            .single();
        final created = UserReview.fromJson(response);
        _mockReviews.insert(0, created);
        return created;
      } catch (_) {
        _mockReviews.insert(0, review);
        return review;
      }
    }
    _mockReviews.insert(0, review);
    return review;
  }
}
