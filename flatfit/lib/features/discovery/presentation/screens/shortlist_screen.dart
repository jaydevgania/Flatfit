import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/interest_provider.dart';
import '../providers/shortlist_provider.dart';
import 'compare_screen.dart';
import 'profile_detail_screen.dart';

/// Screen managing saved flatmate profiles with multi-select comparison support.
class ShortlistScreen extends ConsumerWidget {
  const ShortlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shortlistState = ref.watch(shortlistProvider);
    final shortlistNotifier = ref.read(shortlistProvider.notifier);
    final selectedForCompare = shortlistState.selectedForCompare;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Profiles', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          if (shortlistState.shortlisted.isNotEmpty)
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CompareScreen(
                      initialProfiles: shortlistState.shortlisted.take(3).toList(),
                    ),
                  ),
                );
              },
              child: const Text('Compare All'),
            ),
        ],
      ),
      body: shortlistState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : shortlistState.shortlisted.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.favorite_border_rounded,
                            size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text(
                          'No saved profiles yet',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap the heart icon on any match card to save and compare them later.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 80),
                  itemCount: shortlistState.shortlisted.length,
                  itemBuilder: (context, idx) {
                    final profile = shortlistState.shortlisted[idx];
                    final isSelected = selectedForCompare.any((p) => p.id == profile.id);

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: isSelected ? const Color(0xFF4F46E5) : Colors.grey.shade200,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                profile.displayPhoto,
                                width: 56,
                                height: 56,
                                fit: BoxFit.cover,
                              ),
                            ),
                            if (isSelected)
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF4F46E5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.check, size: 14, color: Colors.white),
                                ),
                              ),
                          ],
                        ),
                        title: Text(
                          '${profile.fullName}, ${profile.age}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${profile.locality ?? profile.city} • ${profile.budgetDisplay}',
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              profile.occupation,
                              style: const TextStyle(fontSize: 11, color: Color(0xFF4F46E5)),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: isSelected,
                              activeColor: const Color(0xFF4F46E5),
                              onChanged: (_) {
                                shortlistNotifier.toggleSelectForCompare(profile);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.grey),
                              onPressed: () => shortlistNotifier.toggleShortlist(profile),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ProfileDetailScreen(profile: profile),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: selectedForCompare.length >= 2
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CompareScreen(initialProfiles: selectedForCompare),
                  ),
                );
              },
              icon: const Icon(Icons.compare_arrows_rounded),
              label: Text('Compare (${selectedForCompare.length}) Profiles'),
              backgroundColor: const Color(0xFF4F46E5),
              foregroundColor: Colors.white,
            )
          : null,
    );
  }
}
