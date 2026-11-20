class ReviewTags {
  static const positiveTags = ['Pays on time', 'Clean and tidy'];
  static const neutralTags = ['Night owl'];

  static bool isPositive(String tag) => positiveTags.contains(tag);
}
