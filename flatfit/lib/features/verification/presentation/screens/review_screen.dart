import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/review_model.dart';
import '../../domain/review_tags.dart';
import '../providers/review_provider.dart';
import '../widgets/review_tag_chip.dart';

class ReviewScreen extends ConsumerStatefulWidget {
  final String revieweeId;
  final String revieweeName;

  const ReviewScreen({
    Key? key,
    required this.revieweeId,
    required this.revieweeName,
  }) : super(key: key);

  @override
  ConsumerState<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends ConsumerState<ReviewScreen> {
  int _rating = 5;
  final List<String> _selectedTags = [];
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _privateFeedbackController = TextEditingController();
  int _stayMonths = 6;
  bool _isAnonymous = false;

  @override
  void dispose() {
    _commentController.dispose();
    _privateFeedbackController.dispose();
    super.dispose();
  }

  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
      }
    });
  }

  Future<void> _submit() async {
    if (_stayMonths < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reviews can only be submitted after 30+ days of living together.')),
      );
      return;
    }

    final newReview = UserReview(
      id: 'rev_${DateTime.now().millisecondsSinceEpoch}',
      reviewerId: 'current_user',
      revieweeId: widget.revieweeId,
      reviewerName: 'You',
      rating: _rating,
      comment: _commentController.text.trim(),
      tags: _selectedTags,
      privateFeedback: _privateFeedbackController.text.trim(),
      stayDurationMonths: _stayMonths,
      isAnonymous: _isAnonymous,
      createdAt: DateTime.now(),
    );

    final success = await ref
        .read(reviewProvider(widget.revieweeId).notifier)
        .submitReview(newReview);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thank you! Your verified flatmate review has been posted.'),
          backgroundColor: Color(0xFF0D9488),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Review ${widget.revieweeName}'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rule Notice
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFBFDBFE)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.verified_user, color: Color(0xFF2563EB), size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'FlatFit Verified Stay Review: Available only after co-living for 30+ days.',
                      style: TextStyle(fontSize: 12, color: Color(0xFF1E40AF), fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Star Rating
            const Text('Overall Experience as a Flatmate', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: List.generate(5, (index) {
                final starValue = index + 1;
                return IconButton(
                  icon: Icon(
                    starValue <= _rating ? Icons.star : Icons.star_border,
                    color: const Color(0xFFF59E0B),
                    size: 36,
                  ),
                  onPressed: () => setState(() => _rating = starValue),
                );
              }),
            ),
            const SizedBox(height: 20),

            // Predefined Positive Review Tags
            const Text('What made living together great? (Positive Tags)', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ReviewTags.positiveTags.map((tag) {
                final isSelected = _selectedTags.contains(tag);
                return ReviewTagChip(
                  tag: tag,
                  isSelected: isSelected,
                  isSelectable: true,
                  onTap: () => _toggleTag(tag),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Neutral Lifestyle Tags
            const Text('Lifestyle Habits (Neutral Tags)', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ReviewTags.neutralTags.map((tag) {
                final isSelected = _selectedTags.contains(tag);
                return ReviewTagChip(
                  tag: tag,
                  isSelected: isSelected,
                  isSelectable: true,
                  onTap: () => _toggleTag(tag),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Public Review Comment
            TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                labelText: 'Public Review Comment',
                hintText: 'Describe communication, cleanliness, bill splitting...',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color(0xFFF8FAFC),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            // Private Feedback (Only visible to FlatFit team)
            TextField(
              controller: _privateFeedbackController,
              decoration: const InputDecoration(
                labelText: 'Private Feedback to FlatFit Team (Optional)',
                hintText: 'Confidential feedback that will not appear publicly on their profile',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color(0xFFF8FAFC),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),

            // Anonymous review toggle
            SwitchListTile.adaptive(
              title: const Text('Post as Anonymous Verified Flatmate'),
              subtitle: const Text('Your name will be hidden on their public review card'),
              value: _isAnonymous,
              onChanged: (val) => setState(() => _isAnonymous = val),
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Submit Verified Review',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
