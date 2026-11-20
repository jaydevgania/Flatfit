import 'package:flutter/material.dart';
import '../domain/discovery_filters.dart';

/// Horizontal scrollable bar displaying active filter pills and quick filter shortcuts.
class FilterChipBar extends StatelessWidget {
  final DiscoveryFilters filters;
  final VoidCallback onOpenFilters;
  final ValueChanged<String>? onQuickLocalityToggle;
  final VoidCallback? onResetFilters;

  const FilterChipBar({
    super.key,
    required this.filters,
    required this.onOpenFilters,
    this.onQuickLocalityToggle,
    this.onResetFilters,
  });

  static const List<String> quickLocalities = [
    'Bandra West',
    'Andheri West',
    'Powai',
    'Versova',
    'Lower Parel',
    'Khar',
  ];

  @override
  Widget build(BuildContext context) {
    final activeCount = filters.activeFilterCount;

    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // Filter button with badge
          ActionChip(
            avatar: Icon(
              Icons.tune_rounded,
              size: 16,
              color: activeCount > 0 ? Colors.white : const Color(0xFF4B5563),
            ),
            label: Text(
              activeCount > 0 ? 'Filters ($activeCount)' : 'All Filters',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: activeCount > 0 ? Colors.white : const Color(0xFF374151),
              ),
            ),
            backgroundColor: activeCount > 0
                ? const Color(0xFF4F46E5)
                : const Color(0xFFF3F4F6),
            side: BorderSide.none,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            onPressed: onOpenFilters,
          ),
          const SizedBox(width: 8),

          // Budget chip indicator
          FilterChip(
            label: Text(
              '₹${(filters.budgetMin / 1000).toInt()}k - ₹${(filters.budgetMax / 1000).toInt()}k',
              style: const TextStyle(fontSize: 12),
            ),
            selected: filters.budgetMin != 10000 || filters.budgetMax != 40000,
            onSelected: (_) => onOpenFilters(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          const SizedBox(width: 8),

          // Quick locality pills
          ...quickLocalities.map((loc) {
            final isSelected = filters.localities.contains(loc);
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(loc, style: const TextStyle(fontSize: 12)),
                selected: isSelected,
                selectedColor: const Color(0xFFE0E7FF),
                checkmarkColor: const Color(0xFF4F46E5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                side: BorderSide(
                  color: isSelected ? const Color(0xFF6366F1) : Colors.grey.shade300,
                ),
                onSelected: (_) {
                  onQuickLocalityToggle?.call(loc);
                },
              ),
            );
          }),

          if (filters.hasActiveFilters && onResetFilters != null)
            ActionChip(
              avatar: const Icon(Icons.close_rounded, size: 14, color: Colors.red),
              label: const Text(
                'Reset',
                style: TextStyle(fontSize: 12, color: Colors.red),
              ),
              backgroundColor: const Color(0xFFFEE2E2),
              side: BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              onPressed: onResetFilters,
            ),
        ],
      ),
    );
  }
}
