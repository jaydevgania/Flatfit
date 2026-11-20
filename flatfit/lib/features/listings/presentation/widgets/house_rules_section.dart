import 'package:flutter/material.dart';

class HouseRulesSection extends StatelessWidget {
  final Map<String, dynamic> houseRules;

  const HouseRulesSection({
    Key? key,
    required this.houseRules,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (houseRules.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Text(
          'Standard friendly co-living etiquette applies.',
          style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
        ),
      );
    }

    final rulesList = [
      {
        'title': 'Quiet Hours',
        'value': houseRules['quiet_hours'] ?? houseRules['quietHours'] ?? '11:00 PM - 07:00 AM',
        'icon': Icons.nightlight_round,
        'color': const Color(0xFF6366F1),
      },
      {
        'title': 'Guests & Friends',
        'value': houseRules['guests_allowed'] ?? houseRules['guests'] ?? 'Friends welcome with advance notice',
        'icon': Icons.group_outlined,
        'color': const Color(0xFF0D9488),
      },
      {
        'title': 'Smoking Policy',
        'value': houseRules['smoking_allowed'] ?? houseRules['smoking'] ?? 'Balcony / designated area only',
        'icon': Icons.smoke_free,
        'color': const Color(0xFFE11D48),
      },
      {
        'title': 'Pet Policy',
        'value': houseRules['pets_allowed'] ?? houseRules['pets'] ?? 'Case by case basis',
        'icon': Icons.pets_outlined,
        'color': const Color(0xFFD97706),
      },
      {
        'title': 'Diet & Kitchen',
        'value': houseRules['food_preference'] ?? houseRules['food'] ?? 'Vegetarian and non-veg allowed',
        'icon': Icons.restaurant_outlined,
        'color': const Color(0xFF2563EB),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.rule_folder_outlined, size: 18, color: Color(0xFF6366F1)),
            SizedBox(width: 8),
            Text(
              'House Rules & Culture',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: rulesList.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: (item['color'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        item['icon'] as IconData,
                        color: item['color'] as Color,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title'] as String,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF475569),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item['value'] as String,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
