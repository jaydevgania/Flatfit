import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/subscription.dart';
import '../providers/monetization_provider.dart';
import 'verified_listing_screen.dart';
import 'concierge_screen.dart';

class FlatFitPlusScreen extends ConsumerWidget {
  const FlatFitPlusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(monetizationProvider);
    final plans = SubscriptionCatalog.plans;
    final isAlreadyPlus = state.subscription.isPlusActive;

    return Scaffold(
      appBar: AppBar(
        title: const Text('FlatFit Plus'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Hero Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.amber.shade300),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.workspace_premium, color: Color(0xFFD97706), size: 16),
                  SizedBox(width: 6),
                  Text(
                    'FLATFIT PLUS MEMBERSHIP',
                    style: TextStyle(
                      color: Color(0xFF92400E),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Find Your Ideal Flatmate 3x Faster',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Unlimited requests, see who viewed you, advanced compatibility filters, and weekly profile boosts.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade700, fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 24),

            // Plan Options Cards
            ...plans.map((p) => _buildPlanCard(context, ref, p, state.selectedPeriod == p.period)),
            const SizedBox(height: 20),

            // Upgrade Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D9488),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 2,
                ),
                onPressed: state.isLoading
                    ? null
                    : () async {
                        final success = await ref
                            .read(monetizationProvider.notifier)
                            .upgradeToPlus(state.selectedPeriod);
                        if (context.mounted) {
                          if (success) {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                title: const Text('Welcome to FlatFit Plus! 🎉'),
                                content: const Text(
                                  'Your membership is now active. You have unlocked unlimited match requests, profile viewers, and priority placement.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(ctx).pop(),
                                    child: const Text('Let\'s Go'),
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                      },
                child: Text(
                  isAlreadyPlus ? 'Manage Active Plus Plan' : 'Get FlatFit Plus',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Cancel anytime. 100% secure payment via UPI & Cards.',
              style: TextStyle(color: Colors.grey, fontSize: 11),
            ),
            const SizedBox(height: 30),

            // Feature Comparison Table
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Plan Comparison',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 12),
            _buildComparisonTable(),
            const SizedBox(height: 28),

            // Other Services Cards (Verified Listing & Concierge)
            _buildOtherMonetizationCards(context),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(
    BuildContext context,
    WidgetRef ref,
    PlusPlanOption plan,
    bool isSelected,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFF0FDF4) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected ? const Color(0xFF0D9488) : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () => ref.read(monetizationProvider.notifier).selectPeriod(plan.period),
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(
                isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: isSelected ? const Color(0xFF0D9488) : Colors.grey,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          plan.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        if (plan.isPopular) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'MOST POPULAR',
                              style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '₹${plan.perMonthPrice.toInt()}/month • ${plan.savingsLabel}',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Text(
                '₹${plan.totalPrice.toInt()}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF0D9488),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComparisonTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: SubscriptionCatalog.comparisonTable.map((item) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Text(
                    item.featureName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: item.isHighlighted ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    item.freeTierValue,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    item.plusTierValue,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF0D9488),
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOtherMonetizationCards(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Additional Premium Services', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFFE6FFFA),
              child: Icon(Icons.verified, color: Color(0xFF0D9488)),
            ),
            title: const Text('Verified Listing Fee (₹299)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: const Text('Get your property audited and earn 4.2x more tenant leads', style: TextStyle(fontSize: 12)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const VerifiedListingScreen()),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFFEEF2FF),
              child: Icon(Icons.support_agent, color: Color(0xFF4F46E5)),
            ),
            title: const Text('VIP Matching Concierge (₹2,499)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: const Text('Human-assisted flatmate matching with dedicated relocation manager', style: TextStyle(fontSize: 12)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ConciergeScreen()),
              );
            },
          ),
        ),
      ],
    );
  }
}
