import 'package:flutter/material.dart';
import '../../domain/meet_model.dart';

class MeetPlaceCard extends StatelessWidget {
  final PublicPlaceSuggestion place;
  final bool isSelected;
  final VoidCallback onSelect;

  const MeetPlaceCard({
    Key? key,
    required this.place,
    required this.isSelected,
    required this.onSelect,
  }) : super(key: key);

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'mall':
        return Icons.local_mall_outlined;
      case 'metro station':
        return Icons.subway_outlined;
      case 'co-working':
        return Icons.business_outlined;
      case 'cafe':
      default:
        return Icons.local_cafe_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected ? const Color(0xFF6366F1) : const Color(0xFFE2E8F0),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? const Color(0xFF6366F1).withOpacity(0.08)
                : Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF6366F1).withOpacity(0.12)
                : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            _getCategoryIcon(place.category),
            color: isSelected ? const Color(0xFF6366F1) : const Color(0xFF64748B),
            size: 22,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                place.name,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star, size: 12, color: Color(0xFFD97706)),
                  const SizedBox(width: 3),
                  Text(
                    place.rating.toString(),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF92400E),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                place.address,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF64748B),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(Icons.near_me_outlined, size: 12, color: Color(0xFF0D9488)),
                  const SizedBox(width: 4),
                  Text(
                    '${place.distanceKm} km midpoint between localities',
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF0D9488),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        trailing: Radio<bool>(
          value: true,
          groupValue: isSelected,
          activeColor: const Color(0xFF6366F1),
          onChanged: (_) => onSelect(),
        ),
        onTap: onSelect,
      ),
    );
  }
}
