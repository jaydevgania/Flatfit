import 'package:flutter/material.dart';
import 'package:flatfit/features/hub/domain/models/hub_models.dart';
import '../widgets/notice_card.dart';

/// Full Notice Board screen with posting, category filters, and pinning.
class NoticeBoardScreen extends StatefulWidget {
  final String flatId;
  final String currentUserId;
  final String currentUserName;
  final List<FlatNotice>? initialNotices;

  const NoticeBoardScreen({
    super.key,
    required this.flatId,
    required this.currentUserId,
    required this.currentUserName,
    this.initialNotices,
  });

  @override
  State<NoticeBoardScreen> createState() => _NoticeBoardScreenState();
}

class _NoticeBoardScreenState extends State<NoticeBoardScreen> {
  late List<FlatNotice> _notices;
  NoticeCategory? _filterCategory;

  @override
  void initState() {
    super.initState();
    _notices = widget.initialNotices != null
        ? List<FlatNotice>.from(widget.initialNotices!)
        : _getSampleNotices();
  }

  List<FlatNotice> _getSampleNotices() {
    return [
      FlatNotice(
        id: 'not_1',
        flatId: widget.flatId,
        userId: 'user_ananya',
        authorName: 'Ananya Sharma',
        content: '📢 Electrician coming at 4:30 PM today to fix the geyser in bathroom 2. Please leave keys if stepping out.',
        isPinned: true,
        category: NoticeCategory.maintenance,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      FlatNotice(
        id: 'not_2',
        flatId: widget.flatId,
        userId: widget.currentUserId,
        authorName: widget.currentUserName,
        content: '⚠️ Torrent Power notice: scheduled maintenance power cut this Saturday 11 AM - 2 PM.',
        isPinned: true,
        category: NoticeCategory.urgent,
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      ),
      FlatNotice(
        id: 'not_3',
        flatId: widget.flatId,
        userId: 'user_kabir',
        authorName: 'Kabir Mehta',
        content: '🍕 Swiggy instamart delivery arrived; kept milk and bread in the second shelf of fridge.',
        isPinned: false,
        category: NoticeCategory.general,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  void _showAddNoticeDialog() {
    final contentCtrl = TextEditingController();
    NoticeCategory selectedCat = NoticeCategory.general;
    bool isPinned = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Post House Notice'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: contentCtrl,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Share an announcement, rule reminder, or visitor heads-up...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                const Text('Category:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 6),
                DropdownButtonFormField<NoticeCategory>(
                  value: selectedCat,
                  decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true),
                  items: NoticeCategory.values
                      .map((c) => DropdownMenuItem(value: c, child: Text(c.name.toUpperCase())))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setDialogState(() => selectedCat = val);
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Checkbox(
                      value: isPinned,
                      onChanged: (val) => setDialogState(() => isPinned = val ?? false),
                    ),
                    const Text('Pin to top of notice board', style: TextStyle(fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade700,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (contentCtrl.text.trim().isEmpty) return;
                setState(() {
                  _notices.insert(
                    0,
                    FlatNotice(
                      id: 'not_${DateTime.now().millisecondsSinceEpoch}',
                      flatId: widget.flatId,
                      userId: widget.currentUserId,
                      authorName: widget.currentUserName,
                      content: contentCtrl.text.trim(),
                      isPinned: isPinned,
                      category: selectedCat,
                      createdAt: DateTime.now(),
                    ),
                  );
                });
                Navigator.pop(ctx);
              },
              child: const Text('Post Notice'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var displayList = _notices;
    if (_filterCategory != null) {
      displayList = displayList.where((n) => n.category == _filterCategory).toList();
    }
    // Sort pinned to top
    displayList.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return b.createdAt.compareTo(a.createdAt);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flat Notice Board'),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildCategoryFilters(),
          Expanded(
            child: displayList.isEmpty
                ? const Center(child: Text('No notices found in this category'))
                : ListView.builder(
                    itemCount: displayList.length,
                    itemBuilder: (_, idx) {
                      final notice = displayList[idx];
                      return NoticeCard(
                        notice: notice,
                        onTogglePin: () {
                          setState(() {
                            final i = _notices.indexWhere((n) => n.id == notice.id);
                            if (i != -1) {
                              _notices[i] = _notices[i].copyWith(isPinned: !_notices[i].isPinned);
                            }
                          });
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        onPressed: _showAddNoticeDialog,
        child: const Icon(Icons.add_comment_outlined),
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          ChoiceChip(
            label: const Text('All'),
            selected: _filterCategory == null,
            onSelected: (val) => setState(() => _filterCategory = null),
          ),
          const SizedBox(width: 6),
          ...NoticeCategory.values.map(
            (cat) => Padding(
              padding: const EdgeInsets.only(right: 6),
              child: ChoiceChip(
                label: Text(cat.name),
                selected: _filterCategory == cat,
                onSelected: (val) => setState(() => _filterCategory = val ? cat : null),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
