import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flatfit/features/matching/presentation/providers/matching_provider.dart';
import 'package:flatfit/features/discovery/domain/discovery_filters.dart';
import '../providers/discovery_provider.dart';
import '../providers/filters_provider.dart';

/// Screen to view, apply, and manage saved search criteria.
class SavedSearchesScreen extends ConsumerStatefulWidget {
  const SavedSearchesScreen({super.key});

  @override
  ConsumerState<SavedSearchesScreen> createState() => _SavedSearchesScreenState();
}

class _SavedSearchesScreenState extends ConsumerState<SavedSearchesScreen> {
  List<Map<String, dynamic>> _savedSearches = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    setState(() => _isLoading = true);
    final repo = ref.read(discoveryRepositoryProvider);
    final userId = ref.read(currentUserIdProvider);
    final list = await repo.getSavedSearches(userId);
    if (mounted) {
      setState(() {
        _savedSearches = list;
        _isLoading = false;
      });
    }
  }

  void _applySearch(Map<String, dynamic> item) {
    final filtersJson = item['filters'] as Map<String, dynamic>? ?? {};
    final filters = DiscoveryFilters.fromJson(filtersJson);

    ref.read(filtersProvider.notifier).updateFilters(filters);
    ref.read(discoveryProvider.notifier).loadProfiles();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Applied "${item['name'] ?? 'Saved Search'}"'),
        backgroundColor: const Color(0xFF4F46E5),
      ),
    );
    Navigator.of(context).pop();
  }

  Future<void> _deleteSearch(String id) async {
    final repo = ref.read(discoveryRepositoryProvider);
    await repo.deleteSavedSearch(id);
    setState(() {
      _savedSearches.removeWhere((s) => s['id'] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Searches', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _savedSearches.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.bookmark_border_rounded,
                            size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text(
                          'No saved searches',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Save your favorite filter combinations on the filters screen to quickly check new flatmates.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _savedSearches.length,
                  itemBuilder: (context, idx) {
                    final item = _savedSearches[idx];
                    final filters = item['filters'] as Map<String, dynamic>? ?? {};
                    final localities = (filters['localities'] as List<dynamic>?)
                            ?.join(', ') ??
                        'Any Locality';
                    final budgetMin = filters['budget_min'] ?? 10000;
                    final budgetMax = filters['budget_max'] ?? 40000;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: Colors.grey.shade200),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item['name'] ?? 'Saved Filter',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF111827),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline,
                                      size: 20, color: Colors.grey),
                                  onPressed: () => _deleteSearch(item['id'] as String),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '📍 $localities',
                              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '💰 ₹$budgetMin - ₹$budgetMax / month',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF4F46E5),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      item['alert_enabled'] == true
                                          ? Icons.notifications_active_rounded
                                          : Icons.notifications_none_rounded,
                                      size: 16,
                                      color: item['alert_enabled'] == true
                                          ? const Color(0xFF10B981)
                                          : Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      item['alert_enabled'] == true
                                          ? 'Instant Alerts ON'
                                          : 'Alerts OFF',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: item['alert_enabled'] == true
                                            ? const Color(0xFF10B981)
                                            : Colors.grey,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                ElevatedButton(
                                  onPressed: () => _applySearch(item),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4F46E5),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text('Apply',
                                      style: TextStyle(fontSize: 12)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
