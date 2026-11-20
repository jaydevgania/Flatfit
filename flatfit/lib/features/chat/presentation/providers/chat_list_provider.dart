import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/chat_repository.dart';
import '../../domain/conversation_model.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepositoryImpl();
});

class ChatListState {
  final List<Conversation> conversations;
  final bool isLoading;
  final String? errorMessage;
  final String searchQuery;
  final String activeTab; // 'all', 'unread', 'groups'

  const ChatListState({
    this.conversations = const [],
    this.isLoading = false,
    this.errorMessage,
    this.searchQuery = '',
    this.activeTab = 'all',
  });

  List<Conversation> get filteredConversations {
    return conversations.where((conv) {
      if (activeTab == 'unread' && conv.unreadCount == 0) return false;
      if (activeTab == 'groups' && conv.type.name != 'group') return false;

      if (searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        final nameMatch = conv.members.any((m) => m.fullName.toLowerCase().contains(query));
        final titleMatch = conv.title?.toLowerCase().contains(query) ?? false;
        final msgMatch = conv.lastMessage?.content?.toLowerCase().contains(query) ?? false;
        return nameMatch || titleMatch || msgMatch;
      }
      return true;
    }).toList();
  }

  ChatListState copyWith({
    List<Conversation>? conversations,
    bool? isLoading,
    String? errorMessage,
    String? searchQuery,
    String? activeTab,
  }) {
    return ChatListState(
      conversations: conversations ?? this.conversations,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      activeTab: activeTab ?? this.activeTab,
    );
  }
}

class ChatListNotifier extends StateNotifier<ChatListState> {
  final ChatRepository _repository;
  final String currentUserId;

  ChatListNotifier(this._repository, {this.currentUserId = 'current_user'})
      : super(const ChatListState()) {
    loadConversations();
  }

  Future<void> loadConversations() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final list = await _repository.getConversations(currentUserId);
      state = state.copyWith(conversations: list, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setActiveTab(String tab) {
    state = state.copyWith(activeTab: tab);
  }

  void markAsRead(String conversationId) {
    final updated = state.conversations.map((c) {
      if (c.id == conversationId) {
        return c.copyWith(unreadCount: 0);
      }
      return c;
    }).toList();
    state = state.copyWith(conversations: updated);
    _repository.markAsRead(conversationId, currentUserId);
  }
}

final chatListProvider =
    StateNotifierProvider<ChatListNotifier, ChatListState>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return ChatListNotifier(repository);
});
