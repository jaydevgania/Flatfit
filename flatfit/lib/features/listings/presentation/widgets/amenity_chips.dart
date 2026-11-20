import 'package:flutter/material.dart';

class AmenityChips extends StatelessWidget {
  final List<String> amenities;
  final bool isSelectable;
  final List<String> selectedAmenities;
  final Function(String amenity)? onToggle;

  const AmenityChips({
    Key? key,
    required this.amenities,
    this.isSelectable = false,
    this.selectedAmenities = const [],
    this.onToggle,
  }) : super(key: key);

  static const Map<String, IconData> amenityIcons = {
    'WiFi': Icons.wifi,
    'AC': Icons.ac_unit,
    'Washing Machine': Icons.local_laundry_service,
    'Geyser': Icons.hot_tub,
    'Parking': Icons.local_parking,
    'Gym': Icons.fitness_center,
    'Power Backup': Icons.bolt,
    'Lift': Icons.elevator,
    'Security': Icons.shield,
    'Furnished Kitchen': Icons.soup_kitchen,
    'Balcony': Icons.balcony,
    'Swimming Pool': Icons.pool,
    'Cook Available': Icons.restaurant,
    'Maid Service': Icons.cleaning_services,
  };

  static IconData getIconForAmenity(String name) {
    return amenityIcons[name] ?? Icons.check_circle_outline;
  }

  @override
  Widget build(BuildContext context) {
    if (amenities.isEmpty) {
      return const Text(
        'No specific amenities listed',
        style: TextStyle(fontSize: 13, color: Colors.grey),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: amenities.map((amenity) {
        final icon = getIconForAmenity(amenity);
        final isSelected = selectedAmenities.contains(amenity);

        if (isSelectable) {
          return FilterChip(
            avatar: Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : const Color(0xFF6366F1),
            ),
            label: Text(amenity),
            selected: isSelected,
            selectedColor: const Color(0xFF6366F1),
            checkmarkColor: Colors.white,
            labelStyle: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : const Color(0xFF334155),
            ),
            backgroundColor: const Color(0xFFF1F5F9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: isSelected ? const Color(0xFF6366F1) : const Color(0xFFE2E8F0),
              ),
            ),
            onSelected: (_) => onToggle?.call(amenity),
          );
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: const Color(0xFF4F46E5)),
              const SizedBox(width: 6),
              Text(
                amenity,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF334155),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
