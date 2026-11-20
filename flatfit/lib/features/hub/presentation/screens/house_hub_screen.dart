import 'package:flutter/material.dart';
import '../models/hub_models.dart';
import '../services/hub_service.dart';
import '../widgets/quiet_hours_banner.dart';
import '../widgets/guest_announcement_sheet.dart';
import '../widgets/notice_card.dart';
import 'notice_board_screen.dart';
import 'shared_calendar_screen.dart';
import 'grocery_list_screen.dart';
import 'house_memory_screen.dart';

/// Central House Hub screen for shared co-living communication and household harmony.
class HouseHubScreen extends StatefulWidget {
  final String flatId;
  final String currentUserId;
  final String currentUserName;

  const HouseHubScreen({
    super.key,
    required this.flatId,
    required this.currentUserId,
    this.currentUserName = 'Rohan Verma',
  });

  @override
  State<HouseHubScreen> createState() => _HouseHubScreenState();
}

class _HouseHubScreenState extends State<HouseHubScreen> {
  bool _isQuietHoursActive = false;
  late List<FlatNotice> _notices;
  late List<HubCalendarEvent> _calendarEvents;
  late List<GroceryItem> _groceryItems;

  @override
  void initState() {
    super.initState();
    _loadSampleHubData();
  }

  void _loadSampleHubData() {
    _notices = [
      FlatNotice(
        id: 'not_1',
        flatId: widget.flatId,
        userId: 'user_ananya',
        authorName: 'Ananya Sharma',
        content: '📢 Electrician coming at 4:30 PM today to fix the geyser in bathroom 2. Please be home or leave keys.',
        isPinned: true,
        category: NoticeCategory.maintenance,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      FlatNotice(
        id: 'not_2',
        flatId: widget.flatId,
        userId: 'user_kabir',
        authorName: 'Kabir Mehta',
        content: '🎉 Ordered 20L Bisleri water jar; please settle ₹90 on FlatFit expenses.',
        isPinned: false,
        category: NoticeCategory.general,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
    ];

    _calendarEvents = [
      HubCalendarEvent(
        id: 'evt_1',
        flatId: widget.flatId,
        userId: 'user_kabir',
        creatorName: 'Kabir Mehta',
        title: 'Friends visiting for match screening',
        description: '3 friends over for Ind vs Aus match from 7:30 PM.',
        type: CalendarEventType.party,
        startTime: DateTime.now().add(const Duration(hours: 3)),
        endTime: DateTime.now().add(const Duration(hours: 7)),
        createdAt: DateTime.now(),
      ),
      HubCalendarEvent(
        id: 'evt_2',
        flatId: widget.flatId,
        userId: 'user_ananya',
        creatorName: 'Ananya Sharma',
        title: 'Pest Control Service',
        description: 'Society quarterly pest control',
        type: CalendarEventType.maintenance,
        startTime: DateTime.now().add(const Duration(days: 2)),
        createdAt: DateTime.now(),
      ),
    ];

    _groceryItems = [
      GroceryItem(
        id: 'gro_1',
        flatId: widget.flatId,
        name: 'Amul Taaza Milk (2 Pouches)',
        quantity: '1 Litre',
        category: GroceryCategory.dairyAndEggs,
        addedByUserId: widget.currentUserId,
        addedByName: widget.currentUserName,
        createdAt: DateTime.now(),
      ),
      GroceryItem(
        id: 'gro_2',
        flatId: widget.flatId,
        name: 'Tata Salt & Fortune Sunflower Oil',
        quantity: '1 packet each',
        category: GroceryCategory.pantryAndSpices,
        addedByUserId: 'user_ananya',
        addedByName: 'Ananya Sharma',
        createdAt: DateTime.now(),
      ),
    ];
  }

  void _onBroadcastAnnouncement(GuestAnnouncementTemplate tmpl, String? note) {
    final result = HubService.broadcastAnnouncement(
      flatId: widget.flatId,
      userId: widget.currentUserId,
      userName: widget.currentUserName,
      template: tmpl,
      startTime: DateTime.now(),
      customNote: note,
    );

    setState(() {
      _calendarEvents.insert(0, result.event);
      _notices.insert(0, result.notice);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Broadcasted "${tmpl.title}" to House Notice Board & Calendar!'),
        backgroundColor: Colors.teal.shade700,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Palm Breeze House Hub'),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.campaign_outlined),
            tooltip: 'One-Tap Guest Announcement',
            onPressed: () {
              GuestAnnouncementSheet.show(
                context,
                onAnnounce: _onBroadcastAnnouncement,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            QuietHoursBanner(
              isActive: _isQuietHoursActive,
              onToggle: (val) {
                setState(() => _isQuietHoursActive = val);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      val
                          ? '🌙 Quiet hours activated. Flatmates notified.'
                          : '☀️ Quiet hours deactivated.',
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            _buildNavigationGrid(context),
            const SizedBox(height: 16),
            _buildSectionHeader(
              title: 'Flat Notice Board',
              actionText: 'View All (${_notices.length})',
              onAction: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => NoticeBoardScreen(
                      flatId: widget.flatId,
                      currentUserId: widget.currentUserId,
                      currentUserName: widget.currentUserName,
                      initialNotices: _notices,
                    ),
                  ),
                );
              },
            ),
            ..._notices.take(2).map((notice) => NoticeCard(
                  notice: notice,
                  onTogglePin: () {
                    setState(() {
                      final idx = _notices.indexWhere((n) => n.id == notice.id);
                      if (idx != -1) {
                        _notices[idx] = _notices[idx].copyWith(isPinned: !_notices[idx].isPinned);
                      }
                    });
                  },
                )),
            const SizedBox(height: 16),
            _buildSectionHeader(
              title: 'Upcoming House Calendar',
              actionText: 'Calendar View',
              onAction: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SharedCalendarScreen(
                      flatId: widget.flatId,
                      currentUserId: widget.currentUserId,
                      currentUserName: widget.currentUserName,
                      events: _calendarEvents,
                    ),
                  ),
                );
              },
            ),
            ..._calendarEvents.take(2).map((evt) => _buildCalendarEventSnippet(evt)),
            const SizedBox(height: 16),
            _buildSectionHeader(
              title: 'Shared Grocery Checklist',
              actionText: 'Open List (${_groceryItems.length})',
              onAction: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GroceryListScreen(
                      flatId: widget.flatId,
                      currentUserId: widget.currentUserId,
                      currentUserName: widget.currentUserName,
                      items: _groceryItems,
                    ),
                  ),
                );
              },
            ),
            ..._groceryItems.take(2).map((item) => _buildGrocerySnippet(item)),
            const SizedBox(height: 24),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_alert_outlined),
        label: const Text('Post Alert / Guest'),
        onPressed: () {
          GuestAnnouncementSheet.show(
            context,
            onAnnounce: _onBroadcastAnnouncement,
          );
        },
      ),
    );
  }

  Widget _buildNavigationGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildNavCard(
              title: 'Notice Board',
              subtitle: 'Pinned alerts & rules',
              icon: Icons.push_pin_outlined,
              color: Colors.amber.shade800,
              bgColor: Colors.amber.shade50,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NoticeBoardScreen(
                    flatId: widget.flatId,
                    currentUserId: widget.currentUserId,
                    currentUserName: widget.currentUserName,
                    initialNotices: _notices,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildNavCard(
              title: 'House Calendar',
              subtitle: 'Guests & maid off',
              icon: Icons.event_outlined,
              color: Colors.blue.shade700,
              bgColor: Colors.blue.shade50,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SharedCalendarScreen(
                    flatId: widget.flatId,
                    currentUserId: widget.currentUserId,
                    currentUserName: widget.currentUserName,
                    events: _calendarEvents,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildNavCard(
              title: 'House Memory',
              subtitle: 'Warranty & bills',
              icon: Icons.inventory_2_outlined,
              color: Colors.teal.shade700,
              bgColor: Colors.teal.shade50,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HouseMemoryScreen(
                    flatId: widget.flatId,
                    currentUserId: widget.currentUserId,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: BorderSide(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12.5,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String actionText,
    required VoidCallback onAction,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: onAction,
            child: Text(actionText, style: const TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarEventSnippet(HubCalendarEvent evt) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: BorderSide(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(
                  '${evt.startTime.day}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blue.shade900,
                  ),
                ),
                Text(
                  _monthShort(evt.startTime.month),
                  style: TextStyle(fontSize: 10, color: Colors.blue.shade700),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  evt.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                ),
                Text(
                  'By ${evt.creatorName} • ${evt.description ?? ""}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 11.5),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrocerySnippet(GroceryItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: BorderSide(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.shopping_basket_outlined, size: 18, color: Colors.teal.shade700),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '${item.name} (${item.quantity ?? "1"})',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            'Added by ${item.addedByName.split(' ')[0]}',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  String _monthShort(int month) {
    const m = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return m[month - 1];
  }
}
