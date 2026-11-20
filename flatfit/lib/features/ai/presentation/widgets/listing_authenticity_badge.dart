import 'package:flutter/material.dart';
import '../../domain/listing_authenticity.dart';

/// Interactive chip/badge indicating AI authenticity evaluation of a listing.
class ListingAuthenticityBadge extends StatelessWidget {
  final ListingAuthenticityReport report;
  final bool compact;

  const ListingAuthenticityBadge({
    super.key,
    required this.report,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;
    String label;

    switch (report.grade) {
      case AuthenticityGrade.verifiedAuthentic:
        color = const Color(0xFF16A34A);
        icon = Icons.verified;
        label = 'Verified Authentic';
        break;
      case AuthenticityGrade.fairMarketPrice:
        color = const Color(0xFF0D9488);
        icon = Icons.check_circle_outline;
        label = 'Fair Market Price';
        break;
      case AuthenticityGrade.suspiciouslyLow:
        color = const Color(0xFFDC2626);
        icon = Icons.warning_amber_rounded;
        label = 'Suspiciously Low Rent';
        break;
      case AuthenticityGrade.overpriced:
        color = const Color(0xFFD97706);
        icon = Icons.trending_up;
        label = 'Above Area Average';
        break;
      case AuthenticityGrade.duplicateRisk:
        color = const Color(0xFFEA580C);
        icon = Icons.content_copy;
        label = 'Duplicate Check Alert';
        break;
    }

    return InkWell(
      onTap: () => _showAuthenticitySheet(context),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 10, vertical: compact ? 4 : 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: compact ? 14 : 16),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: compact ? 11 : 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAuthenticitySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.security, color: Color(0xFF0D9488), size: 24),
                  const SizedBox(width: 8),
                  const Text(
                    'AI Authenticity Analysis',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Score: ${report.trustScore}/100',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D9488),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                report.aiVerdict,
                style: const TextStyle(fontSize: 13, height: 1.4, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              _buildPriceStatsRow(),
              const SizedBox(height: 16),
              if (report.flaggedAnomalies.isNotEmpty) ...[
                const Text('Potential Risks', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.red)),
                const SizedBox(height: 6),
                ...report.flaggedAnomalies.map((a) => _buildCheckItem(Icons.error_outline, Colors.red, a)),
                const SizedBox(height: 12),
              ],
              if (report.positiveSignals.isNotEmpty) ...[
                const Text('Verified Trust Signals', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.green)),
                const SizedBox(height: 6),
                ...report.positiveSignals.map((p) => _buildCheckItem(Icons.check_circle_outline, Colors.green, p)),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D9488),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Got it'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPriceStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Text('₹${report.askedRent.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 2),
            const Text('Asked Rent', style: TextStyle(color: Colors.grey, fontSize: 11)),
          ],
        ),
        Column(
          children: [
            Text('₹${report.expectedMedianRent.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 2),
            const Text('Area Median', style: TextStyle(color: Colors.grey, fontSize: 11)),
          ],
        ),
        Column(
          children: [
            Text(
              '${report.priceDeviationPercent > 0 ? "+" : ""}${report.priceDeviationPercent}%',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: report.priceDeviationPercent < -40 ? Colors.red : Colors.green,
              ),
            ),
            const SizedBox(height: 2),
            const Text('Deviation', style: TextStyle(color: Colors.grey, fontSize: 11)),
          ],
        ),
      ],
    );
  }

  Widget _buildCheckItem(IconData icon, Color color, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 12, height: 1.3))),
        ],
      ),
    );
  }
}
