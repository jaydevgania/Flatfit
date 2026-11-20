import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/referral.dart';
import '../providers/community_provider.dart';

class ReferralScreen extends ConsumerWidget {
  const ReferralScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(communityProvider);
    final summary = state.referralSummary ?? ReferralEngine.getDefaultSummary('user_1', 'Jay');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Refer & Earn ₹250 Cash'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Reward Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFF3730A3)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(Icons.card_giftcard, color: Colors.amberAccent, size: 42),
                  const SizedBox(height: 10),
                  const Text(
                    'Give ₹50, Get ₹250 Cash',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Share FlatFit with flat-hunting friends. When they find their flatmate and move in, you earn ₹250 directly into your bank or UPI account.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildRewardStat('Total Earned', '₹${summary.totalCashEarned.toInt()}'),
                      _buildRewardStat('Pending Cash', '₹${summary.pendingCashRewards.toInt()}'),
                      _buildRewardStat('Moved In', '${summary.totalFriendsMovedIn} friends'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Invite Code Box
            const Text('Your Exclusive Referral Code', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      summary.referralCode,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.2),
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.copy, size: 16),
                    label: const Text('Copy'),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: summary.referralCode));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Referral code copied!')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Share buttons
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.share),
                label: const Text('Share Invite Link on WhatsApp'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: summary.referralLink));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Link copied to share: ${summary.referralLink}')),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Milestone Tracker
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.workspace_premium, color: Colors.amber.shade800, size: 22),
                      const SizedBox(width: 8),
                      const Text(
                        'Milestone: Free FlatFit Plus for 1 Month',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: (summary.totalFriendsMovedIn / 3).clamp(0.0, 1.0),
                    backgroundColor: Colors.amber.shade100,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.amber.shade800),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${summary.totalFriendsMovedIn} of 3 friends moved in. Get unlimited match requests & profile boosts once achieved!',
                    style: TextStyle(color: Colors.amber.shade900, fontSize: 11),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Referral History
            const Text('Your Referrals', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            ...summary.referralHistory.map((item) => _buildReferralHistoryCard(item)),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }

  Widget _buildReferralHistoryCard(ReferralItem item) {
    Color statusColor;
    String statusLabel;

    switch (item.status) {
      case ReferralStatus.movedIn:
        statusColor = const Color(0xFF16A34A);
        statusLabel = 'Moved In (+₹250 Paid)';
        break;
      case ReferralStatus.kycCompleted:
        statusColor = const Color(0xFF0D9488);
        statusLabel = 'KYC Verified (Pending Move-In)';
        break;
      case ReferralStatus.registered:
        statusColor = const Color(0xFFD97706);
        statusLabel = 'Registered on App';
        break;
      case ReferralStatus.sent:
      default:
        statusColor = Colors.grey;
        statusLabel = 'Invite Sent';
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.friendName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 2),
              Text(item.friendPhoneOrEmail, style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              statusLabel,
              style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}
