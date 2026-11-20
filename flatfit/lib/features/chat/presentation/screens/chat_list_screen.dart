import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/chat_list_provider.dart';
import '../widgets/conversation_tile.dart';
import 'chat_screen.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(chatListProvider);
    final notifier = ref.read(chatListProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Messages',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.shield_outlined, color: Color(0xFF6366F1)),
            tooltip: 'Trust & Safety Guide',
            onPressed: () {
              _showSafetyTipsDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                // Search bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    onChanged: notifier.setSearchQuery,
                    decoration: const InputDecoration(
                      hintText: 'Search flatmates or messages...',
                      hintStyle: TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
                      prefixIcon: Icon(Icons.search, color: Color(0xFF94A3B8), size: 20),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Tabs: All, Unread, Groups
                Row(
                  children: [
                    _buildTabChip('All', 'all', state.activeTab, notifier),
                    const SizedBox(width: 8),
                    _buildTabChip('Unread', 'unread', state.activeTab, notifier),
                    const SizedBox(width: 8),
                    _buildTabChip('Groups', 'groups', state.activeTab, notifier),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          // Conversation list
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => notifier.loadConversations(),
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : state.filteredConversations.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          itemCount: state.filteredConversations.length,
                          itemBuilder: (context, index) {
                            final conversation =
                                state.filteredConversations[index];
                            return ConversationTile(
                              conversation: conversation,
                              currentUserId: notifier.currentUserId,
                              onTap: () {
                                notifier.markAsRead(conversation.id);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ChatScreen(
                                      conversationId: conversation.id,
                                      otherMemberName: conversation
                                          .getDisplayName(notifier.currentUserId),
                                      otherMemberAvatar: conversation
                                          .getDisplayAvatar(notifier.currentUserId),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabChip(
    String label,
    String tabKey,
    String activeTab,
    ChatListNotifier notifier,
  ) {
    final isSelected = activeTab == tabKey;
    return GestureDetector(
      onTap: () => notifier.setActiveTab(tabKey),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6366F1) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chat_bubble_outline,
                size: 48,
                color: Color(0xFF6366F1),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No Conversations Yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Browse matches with high compatibility and send an intro to start chatting!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSafetyTipsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.security, color: Color(0xFF0D9488)),
            SizedBox(width: 8),
            Text('FlatFit Safety Principles'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('1. Keep your conversation on FlatFit until mutual trust is established.'),
            SizedBox(height: 8),
            Text('2. Use the Schedule Meet feature to meet at neutral public cafes.'),
            SizedBox(height: 8),
            Text('3. Phone numbers stay masked until both parties agree to reveal.'),
            SizedBox(height: 8),
            Text('4. Never transfer token deposit without a signed digital agreement.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Understood'),
          ),
        ],
      ),
    );
  }
}
