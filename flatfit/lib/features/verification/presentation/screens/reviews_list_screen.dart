import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/review_model.dart';
import '../providers/review_provider.dart';
import '../widgets/review_tag_chip.dart';
import 'review_screen.dart';

class ReviewsListScreen extends ConsumerWidget {
  final String userId;
  final String userName;

  const ReviewsListScreen({
    Key? key,
    required this.userId,
    required this.userName,
  }) : super(key: key);

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewState = ref.watch(reviewProvider(userId));
    final notifier = ref.read(reviewProvider(userId).notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text('Reviews for $userName'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.rate_review_outlined, color: Color(0xFF6366F1)),
            tooltip: 'Write Review',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ReviewScreen(
                    revieweeId: userId,
                    revieweeName: userName,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: reviewState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary Rating Card
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              reviewState.averageRating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            Row(
                              children: List.generate(
                                5,
                                (i) => Icon(
                                  i < reviewState.averageRating.round()
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: const Color(0xFFF59E0B),
                                  size: 16,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${reviewState.reviews.length} Verified Reviews',
                              style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                        Container(height: 50, width: 1, color: const Color(0xFFCBD5E1)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Row(
                              children: [
                                Icon(Icons.verified, color: Color(0xFF0D9488), size: 16),
                                SizedBox(width: 6),
                                Text(
                                  '30+ Day Co-Living Verified',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Text(
                              'All reviews are from verified past flatmates',
                              style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Reviews List
                  const Text(
                    'Flatmate Feedback & Endorsements',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...reviewState.filteredReviews.map((review) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: const Color(0xFF6366F1).withOpacity(0.1),
                                backgroundImage: review.reviewerAvatarUrl != null
                                    ? NetworkImage(review.reviewerAvatarUrl!)
                                    : null,
                                child: review.reviewerAvatarUrl == null
                                    ? Text(review.reviewerName[0])
                                    : null,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      review.reviewerName,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Lived together for ${review.stayDurationMonths} months • ${_formatDate(review.createdAt)}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: List.generate(
                                  5,
                                  (i) => Icon(
                                    i < review.rating ? Icons.star : Icons.star_border,
                                    color: const Color(0xFFF59E0B),
                                    size: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (review.comment != null && review.comment!.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Text(
                              review.comment!,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF334155),
                                height: 1.4,
                              ),
                            ),
                          ],
                          if (review.tags.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: review.tags.map((tag) {
                                return ReviewTagChip(tag: tag);
                              }).toList(),
                            ),
                          ],
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
    );
  }
}
