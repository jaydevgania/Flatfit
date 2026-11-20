import 'package:flutter/material.dart';
import '../../domain/review_tags.dart';

class ReviewTagChip extends StatelessWidget {
  final String tag;
  final bool isSelected;
  final bool isSelectable;
  final VoidCallback? onTap;

  const ReviewTagChip({
    Key? key,
    required this.tag,
    this.isSelected = false,
    this.isSelectable = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPos = ReviewTags.isPositive(tag);
    final icon = ReviewTags.getIconForTag(tag);

    final activeColor = isPos ? const Color(0xFF059669) : const Color(0xFF6366F1);
    final bgColor = isSelected
        ? activeColor
        : (isPos ? const Color(0xFFECFDF5) : const Color(0xFFEEF2FF));
    final textColor = isSelected
        ? Colors.white
        : (isPos ? const Color(0xFF065F46) : const Color(0xFF3730A3));

    return GestureDetector(
      onTap: isSelectable ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? activeColor
                : (isPos ? const Color(0xFFA7F3D0) : const Color(0xFFC7D2FE)),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 13,
              color: isSelected ? Colors.white : activeColor,
            ),
            const SizedBox(width: 5),
            Text(
              tag,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
