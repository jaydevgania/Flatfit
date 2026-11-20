import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/service_partner.dart';
import '../providers/marketplace_provider.dart';
import '../widgets/partner_card.dart';
import '../widgets/service_bundle_card.dart';
import 'service_detail_screen.dart';
import 'my_bookings_screen.dart';

class MarketplaceScreen extends ConsumerWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(marketplaceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FlatFit Services Marketplace'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long),
            tooltip: 'My Bookings',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const MyBookingsScreen()),
              );
            },
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => ref.read(marketplaceProvider.notifier).loadData(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Bar
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Search movers, deep cleaning, furniture, cooks...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      ),
                      onChanged: (val) => ref.read(marketplaceProvider.notifier).setSearchQuery(val),
                    ),
                    const SizedBox(height: 20),

                    // Curated Moving Bundles Carousel
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Moving Bundles & Deals',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          'Save up to 20%',
                          style: TextStyle(color: Colors.amber.shade900, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 195,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.bundles.length,
                        itemBuilder: (context, idx) {
                          final bundle = state.bundles[idx];
                          return ServiceBundleCard(
                            bundle: bundle,
                            onSelect: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Selected bundle: ${bundle.title}')),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Category Chips
                    const Text(
                      'Browse Services',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: ServiceCategory.values.map((cat) {
                          final isSelected = state.selectedCategory == cat;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(cat.displayName),
                              selected: isSelected,
                              selectedColor: const Color(0xFF0D9488),
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : Colors.black87,
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                              onSelected: (_) => ref.read(marketplaceProvider.notifier).filterCategory(cat),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Partner List
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Vetted Partners (${state.partners.length})',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const Row(
                          children: [
                            Icon(Icons.shield_outlined, size: 14, color: Color(0xFF0D9488)),
                            SizedBox(width: 4),
                            Text('100% Verified', style: TextStyle(color: Color(0xFF0D9488), fontSize: 12, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (state.partners.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(child: Text('No service partners found.')),
                      )
                    else
                      ...state.partners.map((partner) => PartnerCard(
                            partner: partner,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ServiceDetailScreen(partner: partner),
                                ),
                              );
                            },
                          )),
                  ],
                ),
              ),
            ),
    );
  }
}
