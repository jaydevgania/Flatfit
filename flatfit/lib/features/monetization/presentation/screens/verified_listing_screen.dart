import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/verified_listing_fee.dart';
import '../providers/monetization_provider.dart';

class VerifiedListingScreen extends ConsumerStatefulWidget {
  final String listingId;
  final String listingTitle;

  const VerifiedListingScreen({
    super.key,
    this.listingId = 'listing_sample_1',
    this.listingTitle = 'Spacious Master Bedroom in Bandra West 3BHK',
  });

  @override
  ConsumerState<VerifiedListingScreen> createState() => _VerifiedListingScreenState();
}

class _VerifiedListingScreenState extends ConsumerState<VerifiedListingScreen> {
  final VerifiedListingPackage _package = const VerifiedListingPackage();
  bool _isProcessing = false;

  Future<void> _handlePurchase() async {
    setState(() => _isProcessing = true);
    final success = await ref
        .read(monetizationProvider.notifier)
        .buyVerifiedListingBadge(widget.listingId);
    setState(() => _isProcessing = false);

    if (mounted) {
      if (success) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Row(
              children: [
                Icon(Icons.verified, color: Color(0xFF16A34A), size: 28),
                SizedBox(width: 8),
                Text('Verification Scheduled!'),
              ],
            ),
            content: const Text(
              'Your payment of ₹299 was successful. A FlatFit verification field agent will schedule a 15-minute video inspection today to certify your listing.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('Done'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get Verified Listing Badge'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Target listing
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.home, color: Color(0xFF0D9488)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Listing to Verify', style: TextStyle(color: Colors.grey, fontSize: 11)),
                        Text(widget.listingTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Benefit Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0D9488), Color(0xFF0F766E)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(Icons.verified_user, color: Colors.amberAccent, size: 48),
                  const SizedBox(height: 10),
                  Text(
                    _package.title,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _package.subtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'One-time Fee: ₹${_package.fee.toInt()} only',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Benefits list
            const Text('What is Included:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            ..._package.benefits.map((b) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle, color: Color(0xFF0D9488), size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(b, style: const TextStyle(fontSize: 13, height: 1.35)),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 32),

            // Purchase Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.lock_outline),
                label: Text(_isProcessing ? 'Processing...' : 'Pay ₹299 & Verify Listing'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D9488),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _isProcessing ? null : _handlePurchase,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
