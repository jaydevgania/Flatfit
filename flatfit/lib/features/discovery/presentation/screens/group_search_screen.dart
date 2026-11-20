import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flatfit/features/matching/presentation/providers/matching_provider.dart';
import 'package:flatfit/features/discovery/domain/group_search_model.dart';
import '../providers/discovery_provider.dart';

/// Screen for Group Matching (2 to 4 friends searching together).
class GroupSearchScreen extends ConsumerStatefulWidget {
  const GroupSearchScreen({super.key});

  @override
  ConsumerState<GroupSearchScreen> createState() => _GroupSearchScreenState();
}

class _GroupSearchScreenState extends ConsumerState<GroupSearchScreen> {
  List<GroupSearchModel> _groups = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    setState(() => _isLoading = true);
    final repo = ref.read(discoveryRepositoryProvider);
    final userId = ref.read(currentUserIdProvider);
    final list = await repo.getUserGroups(userId);
    if (mounted) {
      setState(() {
        _groups = list;
        _isLoading = false;
      });
    }
  }

  void _showCreateGroupSheet() {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.group_add_rounded, color: Color(0xFF4F46E5)),
                  SizedBox(width: 8),
                  Text(
                    'Create Flat Hunt Squad',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Search for 2BHK or 3BHK flats in Mumbai with 2 to 4 friends.',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: 'Squad Name',
                  hintText: 'e.g. Bandra Terrace Squad',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descCtrl,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'What are you looking for?',
                  hintText: 'e.g. Spacious 3BHK with parking near Bandra/Khar',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    if (nameCtrl.text.trim().isEmpty) return;
                    Navigator.of(ctx).pop();
                    final repo = ref.read(discoveryRepositoryProvider);
                    final userId = ref.read(currentUserIdProvider);
                    final newGrp = await repo.createGroup(
                      name: nameCtrl.text.trim(),
                      description: descCtrl.text.trim(),
                      userId: userId,
                    );
                    setState(() {
                      _groups.insert(0, newGrp);
                    });
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Squad "${newGrp.name}" created!')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Create Squad & Invite Friends'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Search (Squads)',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _groups.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.groups_rounded, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text(
                          'No Flat Hunt Squads yet',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Team up with 1 to 3 friends to pool budgets, find 2BHK/3BHK flats, and move in together.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: _showCreateGroupSheet,
                          icon: const Icon(Icons.add),
                          label: const Text('Create a Squad'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4F46E5),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _groups.length,
                  itemBuilder: (context, idx) {
                    final group = _groups[idx];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
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
                                Expanded(
                                  child: Text(
                                    group.name,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF111827),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEEF2FF),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '${group.members.length}/${group.maxMembers} Members',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF4F46E5),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (group.description != null) ...[
                              const SizedBox(height: 6),
                              Text(
                                group.description!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                            const SizedBox(height: 12),

                            // Combined budget & areas
                            Row(
                              children: [
                                const Icon(Icons.currency_rupee_rounded,
                                    size: 15, color: Color(0xFF4F46E5)),
                                const SizedBox(width: 4),
                                Text(
                                  'Pooled: ₹${(group.combinedBudgetMin / 1000).toInt()}k - ₹${(group.combinedBudgetMax / 1000).toInt()}k',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.place_outlined,
                                    size: 15, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  group.preferredLocalities.join(', '),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),

                            // Members avatars
                            Row(
                              children: [
                                ...group.members.map((m) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 6),
                                    child: CircleAvatar(
                                      radius: 16,
                                      backgroundImage: NetworkImage(
                                        m.profile?.displayPhoto ??
                                            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=600&q=80',
                                      ),
                                    ),
                                  );
                                }),
                                if (!group.isFull)
                                  InkWell(
                                    onTap: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Squad invite link copied to clipboard!'),
                                        ),
                                      );
                                    },
                                    child: CircleAvatar(
                                      radius: 16,
                                      backgroundColor: const Color(0xFFEEF2FF),
                                      child: const Icon(
                                        Icons.add,
                                        size: 18,
                                        color: Color(0xFF4F46E5),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 14),

                            // Search Flats as a Squad button
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Filtering 2BHK/3BHK flats for ${group.name}'),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.search, size: 16),
                                label: const Text('Search Flats for Squad'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFF4F46E5),
                                  side: const BorderSide(color: Color(0xFF4F46E5)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateGroupSheet,
        backgroundColor: const Color(0xFF4F46E5),
        child: const Icon(Icons.group_add_rounded, color: Colors.white),
      ),
    );
  }
}
