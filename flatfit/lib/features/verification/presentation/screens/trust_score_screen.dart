import 'package:flutter/material.dart';
import '../../domain/trust_score_model.dart';
import '../widgets/trust_meter.dart';

class TrustScoreScreen extends StatelessWidget {
  final TrustScore trustScore;

  const TrustScoreScreen({Key? key, required this.trustScore})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final factors = [
      {
        'title': 'Government ID / KYC Verified',
        'points': trustScore.kycPoints,
        'max': 30,
        'desc': 'Verified via Aadhaar/Passport and selfie liveness matching',
        'icon': Icons.badge_outlined,
      },
      {
        'title': 'Phone Number Verified',
        'points': trustScore.phonePoints,
        'max': 10,
        'desc': 'Verified via OTP during account creation',
        'icon': Icons.phone_android,
      },
      {
        'title': 'Official Email Verified',
        'points': trustScore.emailPoints,
        'max': 10,
        'desc': 'Work or academic domain confirmation',
        'icon': Icons.mail_outline,
      },
      {
        'title': 'Profile Questionnaire Complete',
        'points': trustScore.profilePoints,
        'max': 10,
        'desc': 'Compatibility questionnaire and lifestyle preferences filled',
        'icon': Icons.person_outline,
      },
      {
        'title': 'Positive Flatmate Reviews',
        'points': trustScore.reviewsPoints,
        'max': 30,
        'desc': 'Verified reviews from past flatmates (+5 points per review)',
        'icon': Icons.star_outline,
      },
      {
        'title': 'Platform Longevity / Account Age',
        'points': trustScore.accountAgePoints,
        'max': 10,
        'desc': '+1 point per active month on FlatFit (up to 10 months)',
        'icon': Icons.calendar_today_outlined,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Trust Score Breakdown'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            // Meter Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  TrustMeter(trustScore: trustScore, size: 150),
                  const SizedBox(height: 12),
                  Text(
                    'You are in the top 15% of trustworthy flatmates in Mumbai!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Factor Cards
            ...factors.map((item) {
              final pts = item['points'] as int;
              final max = item['max'] as int;
              final isEarned = pts > 0;

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isEarned
                            ? const Color(0xFFECFDF5)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        item['icon'] as IconData,
                        color: isEarned
                            ? const Color(0xFF0D9488)
                            : const Color(0xFF64748B),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item['title'] as String,
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              Text(
                                '$pts / $max pts',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isEarned
                                      ? const Color(0xFF0D9488)
                                      : const Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['desc'] as String,
                            style: TextStyle(
                              fontSize: 11.5,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
