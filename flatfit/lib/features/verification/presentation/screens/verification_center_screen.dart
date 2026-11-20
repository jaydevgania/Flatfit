import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/verification_type.dart';
import '../providers/trust_provider.dart';
import '../providers/verification_provider.dart';
import '../widgets/trust_meter.dart';
import 'email_verification_screen.dart';
import 'kyc_verification_screen.dart';
import 'safety_center_screen.dart';
import 'trust_score_screen.dart';

class VerificationCenterScreen extends ConsumerWidget {
  const VerificationCenterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final verState = ref.watch(verificationProvider);
    final trustState = ref.watch(trustProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Verification & Trust Center',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.health_and_safety_outlined, color: Colors.red),
            tooltip: 'Safety Center & SOS',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SafetyCenterScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trust Score Meter Card (tappable to view breakdown)
            GestureDetector(
              onTap: () {
                if (trustState.trustScore != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TrustScoreScreen(trustScore: trustState.trustScore!),
                    ),
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    if (trustState.trustScore != null)
                      TrustMeter(trustScore: trustState.trustScore!, size: 160)
                    else
                      const Center(child: CircularProgressIndicator()),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'View Complete Trust Factors Breakdown',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6366F1),
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.chevron_right, size: 16, color: Color(0xFF6366F1)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Verifications List Header
            const Text(
              'Identity & Trust Credentials',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Verified profiles receive up to 5x more roommate match responses.',
              style: TextStyle(fontSize: 12.5, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 14),

            // 5 Verification Tiles
            ...VerificationType.values.map((type) {
              final userVer = verState.getVerification(type);
              final status = userVer?.status ?? VerificationStatus.notStarted;
              final isDone = status == VerificationStatus.verified;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDone
                            ? const Color(0xFFECFDF5)
                            : const Color(0xFFEEF2FF),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isDone ? Icons.verified : type.icon,
                        color: isDone ? const Color(0xFF0D9488) : const Color(0xFF6366F1),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  type.displayName,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '+${type.trustPoints} pts',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF6366F1),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            type.description,
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (isDone)
                      const Chip(
                        label: Text('Verified', style: TextStyle(fontSize: 11, color: Color(0xFF047857))),
                        backgroundColor: Color(0xFFD1FAE5),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      )
                    else
                      ElevatedButton(
                        onPressed: () {
                          _handleStartVerification(context, type);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6366F1),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Text('Verify', style: TextStyle(fontSize: 12)),
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

  void _handleStartVerification(BuildContext context, VerificationType type) {
    if (type == VerificationType.kyc) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const KycVerificationScreen()),
      );
    } else if (type == VerificationType.employerEmail) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const EmailVerificationScreen(isCollege: false)),
      );
    } else if (type == VerificationType.collegeEmail) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const EmailVerificationScreen(isCollege: true)),
      );
    } else if (type == VerificationType.linkedin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Redirecting to LinkedIn OAuth...')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phone number is verified during sign-in.')),
      );
    }
  }
}
