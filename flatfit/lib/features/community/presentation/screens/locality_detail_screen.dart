import 'package:flutter/material.dart';
import '../../domain/city_guide.dart';

class LocalityDetailScreen extends StatelessWidget {
  final LocalityGuide guide;

  const LocalityDetailScreen({super.key, required this.guide});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(guide.localityName),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    guide.tagLine,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0D9488)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    guide.description,
                    style: TextStyle(color: Colors.grey.shade800, fontSize: 14, height: 1.45),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _buildPill(Icons.favorite, 'Vibe: ${guide.vibe}', Colors.pink.shade50, Colors.pink),
                      const SizedBox(width: 8),
                      _buildPill(Icons.shield, 'Women Safety ${guide.womenSafetyIndex}/5', Colors.green.shade50, Colors.green),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Rent Benchmarks
            const Text(
              'Expected Rent Benchmarks',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: guide.rentBreakdown.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(entry.key, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                        Text(
                          entry.value,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0D9488)),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Commute & Connectivity
            const Text(
              'Commute & Connectivity',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            _buildCommuteRow(Icons.train, 'Local Train', guide.commute.localTrainStation),
            _buildCommuteRow(Icons.subway, 'Metro Line', guide.commute.metroConnectivity),
            _buildCommuteRow(Icons.flight, 'Airport Distance', guide.commute.airportDistance),
            _buildCommuteRow(Icons.business, 'BKC Hub Distance', guide.commute.bkccDistance),
            _buildCommuteRow(Icons.traffic, 'Peak Traffic', guide.commute.peakTrafficNotes),
            const SizedBox(height: 24),

            // Highlights
            const Text(
              'Locality Highlights',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            ...guide.topHighlights.map((h) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, size: 16, color: Color(0xFF0D9488)),
                      const SizedBox(width: 8),
                      Expanded(child: Text(h, style: const TextStyle(fontSize: 13))),
                    ],
                  ),
                )),
            const SizedBox(height: 20),

            // Hangouts
            const Text(
              'Top Hangouts & Cafes',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: guide.popularHangouts.map((place) {
                return Chip(
                  avatar: const Icon(Icons.local_cafe, size: 14, color: Color(0xFF0D9488)),
                  label: Text(place, style: const TextStyle(fontSize: 12)),
                  backgroundColor: Colors.teal.shade50,
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildPill(IconData icon, String text, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: fg),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildCommuteRow(IconData icon, String title, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF0D9488), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
                Text(text, style: const TextStyle(fontSize: 13, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
