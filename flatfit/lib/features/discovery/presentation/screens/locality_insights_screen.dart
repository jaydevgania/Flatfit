import 'package:flutter/material.dart';
import '../widgets/locality_card.dart';

/// Screen displaying Mumbai locality insights:
/// - Transit connectivity (Metro Line 1, 2A, 3, 7, Local trains)
/// - Proximity to IT Parks (Mindspace, NESCO, Powai SEZ, BKC)
/// - Average flatmate room rent trends
/// - Neighbourhood vibes and lifestyle amenities
class LocalityInsightsScreen extends StatefulWidget {
  const LocalityInsightsScreen({super.key});

  @override
  State<LocalityInsightsScreen> createState() => _LocalityInsightsScreenState();
}

class _LocalityInsightsScreenState extends State<LocalityInsightsScreen> {
  String _selectedVibeFilter = 'All';

  final List<Map<String, dynamic>> _localities = [
    {
      'name': 'Bandra West',
      'vibe': 'Cafes, boutique gyms, coastal promenades & startup founders.',
      'avgRent': '₹28k - ₹45k / room',
      'metroDistance': '1.2 km to Metro 3 & Local',
      'itParkDistance': '6 km to BKC Hub',
      'category': 'Lifestyle',
      'tags': ['Pali Hill', 'Hill Road', 'Carter Road', 'High-Energy'],
    },
    {
      'name': 'Andheri West',
      'vibe': 'Media, tech, Versova beach, vibrant nightlife & Lokhandwala buzz.',
      'avgRent': '₹18k - ₹30k / room',
      'metroDistance': '0.4 km to Metro Line 1 & 2A',
      'itParkDistance': '4 km to Nesco IT Park',
      'category': 'Transit Hub',
      'tags': ['Lokhandwala', 'Metro Connected', 'Media Hub', 'Active 24/7'],
    },
    {
      'name': 'Powai',
      'vibe': 'IIT Bombay campus, lakeside serenity, European streets & SaaS startups.',
      'avgRent': '₹22k - ₹35k / room',
      'metroDistance': '1.8 km to Metro Line 6',
      'itParkDistance': '0.8 km to Hiranandani SEZ',
      'category': 'Tech & Startups',
      'tags': ['Hiranandani', 'Lakeside', 'IIT Bombay', 'Greenery'],
    },
    {
      'name': 'Lower Parel',
      'vibe': 'Corporate towers, luxury malls, rooftop dining & financial analysts.',
      'avgRent': '₹35k - ₹55k / room',
      'metroDistance': '0.6 km to Monorail & Western Line',
      'itParkDistance': '0.2 km to One World Center',
      'category': 'Corporate',
      'tags': ['High-Rise', 'Kamala Mills', 'Phoenix Palladium', 'Finance'],
    },
    {
      'name': 'Versova',
      'vibe': 'Charming sea-facing lanes, creative filmmakers, cats & quaint coffee shops.',
      'avgRent': '₹20k - ₹32k / room',
      'metroDistance': '0.5 km to Versova Metro Terminal',
      'itParkDistance': '5 km to Mindspace Malad',
      'category': 'Creative',
      'tags': ['Beachfront', 'Indie Cafes', 'Creative Vibe', 'Pet Friendly'],
    },
    {
      'name': 'Khar West',
      'vibe': 'Peaceful residential avenues, 5 mins from Bandra, upscale yoga studios.',
      'avgRent': '₹24k - ₹38k / room',
      'metroDistance': '1.0 km to Khar Railway Station',
      'itParkDistance': '5.5 km to BKC',
      'category': 'Lifestyle',
      'tags': ['Quiet Avenues', 'Near Bandra', 'Yoga & Wellness'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedVibeFilter == 'All'
        ? _localities
        : _localities.where((l) => l['category'] == _selectedVibeFilter).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mumbai Locality Insights',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // Filter Tabs Bar
          Container(
            height: 48,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                'All',
                'Tech & Startups',
                'Lifestyle',
                'Corporate',
                'Transit Hub',
                'Creative',
              ].map((category) {
                final isSelected = _selectedVibeFilter == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(category, style: const TextStyle(fontSize: 12)),
                    selected: isSelected,
                    selectedColor: const Color(0xFF4F46E5),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF374151),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onSelected: (val) {
                      if (val) setState(() => _selectedVibeFilter = category);
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          // Locality cards list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 24),
              itemCount: filtered.length,
              itemBuilder: (context, idx) {
                final item = filtered[idx];
                return LocalityCard(
                  localityName: item['name'] as String,
                  vibe: item['vibe'] as String,
                  avgRent: item['avgRent'] as String,
                  metroDistance: item['metroDistance'] as String,
                  itParkDistance: item['itParkDistance'] as String,
                  tags: List<String>.from(item['tags'] as List),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Showing flatmates in ${item['name']}'),
                        backgroundColor: const Color(0xFF4F46E5),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
