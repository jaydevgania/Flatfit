import 'package:flutter/material.dart';

/// Predefined review tags for FlatFit flatmate reviews.
class ReviewTags {
  ReviewTags._();

  static const List<String> positiveTags = [
    'Pays on time',
    'Great with chores',
    'Respectful of space',
    'Good communicator',
    'Clean and tidy',
    'Friendly',
    'Quiet and considerate',
  ];

  static const List<String> neutralTags = [
    'Night owl',
    'Social butterfly',
    'Homebody',
    'Early riser',
  ];

  static bool isPositive(String tag) => positiveTags.contains(tag);

  static IconData getIconForTag(String tag) {
    switch (tag) {
      case 'Pays on time':
        return Icons.payments_outlined;
      case 'Great with chores':
        return Icons.cleaning_services_outlined;
      case 'Respectful of space':
        return Icons.shield_outlined;
      case 'Good communicator':
        return Icons.forum_outlined;
      case 'Clean and tidy':
        return Icons.sparkles;
      case 'Friendly':
        return Icons.sentiment_satisfied_alt;
      case 'Quiet and considerate':
        return Icons.volume_off_outlined;
      case 'Night owl':
        return Icons.nightlight_outlined;
      case 'Social butterfly':
        return Icons.celebration_outlined;
      case 'Homebody':
        return Icons.cottage_outlined;
      case 'Early riser':
        return Icons.wb_sunny_outlined;
      default:
        return Icons.tag;
    }
  }
}
