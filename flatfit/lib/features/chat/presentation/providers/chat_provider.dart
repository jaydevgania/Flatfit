import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/chat_repository.dart';
import '../../domain/conversation_model.dart';
import '../../domain/message_model.dart';
import 'chat_list_provider.dart';

class ChatState {
  final String conversationId;
  final List<Message> messages;
  final bool isLoading;
  final bool isSending;
  final String? errorMessage;
  final bool isPhoneRevealed;
  final bool hasRequestedPhoneReveal;

  const ChatState({
    required this.conversationId,
    this.messages = const [],
    this.isLoading = false,
    this.isSending = false,
    this.errorMessage,
    this.isPhoneRevealed = false,
    this.hasRequestedPhoneReveal = false,
  });

  ChatState copyWith({
    String? conversationId,
    List<Message>? messages,
    bool? isLoading,
    bool? isSending,
    String? errorMessage,
    bool? isPhoneRevealed,
    bool? hasRequestedPhoneReveal,
  }) {
    return ChatState(
      conversationId: conversationId ?? this.conversationId,
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isSending: isSending ?? this.isSending,
      errorMessage: errorMessage,
      isPhoneRevealed: isPhoneRevealed ?? this.isPhoneRevealed,
      hasRequestedPhoneReveal:
          hasRequestedPhoneReveal ?? this.hasRequestedPhoneReveal,
    );
  }
}

class ChatNotifier extends StateNotifier<ChatState> {
  final ChatRepository _repository;
  final String conversationId;
  final String currentUserId;
  StreamSubscription<Message>? _messageSubscription;

  ChatNotifier(
    this._repository, {
    required this.conversationId,
    this.currentUserId = 'current_user',
  }) : super(ChatState(conversationId: conversationId)) {
    loadMessages();
    _subscribeToRealtime();
  }

  Future<void> loadMessages() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final msgs = await _repository.getMessages(conversationId);
      final hasPhoneReveal = msgs.any(
        (m) => m.type.name == 'system' && m.systemAction == 'phone_revealed',
      );
      state = state.copyWith(
        messages: msgs,
        isLoading: false,
        isPhoneRevealed: hasPhoneReveal,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void _subscribeToRealtime() {
    _messageSubscription?.cancel();
    _messageSubscription =
        _repository.subscribeToNewMessages(conversationId).listen((newMsg) {
      // Check if message is already in list
      if (!state.messages.any((m) => m.id == newMsg.id)) {
        state = state.copyWith(
          messages: [newMsg, ...state.messages],
        );
      }
    });
  }

  Future<void> sendTextMessage(String text) async {
    if (text.trim().isEmpty) return;
    state = state.copyWith(isSending: true);
    try {
      final newMsg = await _repository.sendMessage(
        conversationId: conversationId,
        senderId: currentUserId,
        text: text.trim(),
      );
      if (!state.messages.any((m) => m.id == newMsg.id)) {
        state = state.copyWith(
          messages: [newMsg, ...state.messages],
          isSending: false,
        );
      } else {
        state = state.copyWith(isSending: false);
      }
    } catch (e) {
      state = state.copyWith(isSending: false, errorMessage: e.toString());
    }
  }

  Future<void> sendImage(String imageUrl, {String? caption}) async {
    state = state.copyWith(isSending: true);
    try {
      final newMsg = await _repository.sendImageMessage(
        conversationId: conversationId,
        senderId: currentUserId,
        imageUrl: imageUrl,
        caption: caption,
      );
      state = state.copyWith(
        messages: [newMsg, ...state.messages],
        isSending: false,
      );
    } catch (e) {
      state = state.copyWith(isSending: false, errorMessage: e.toString());
    }
  }

  Future<void> sendVoiceNote(String audioUrl, int durationSeconds) async {
    state = state.copyWith(isSending: true);
    try {
      final newMsg = await _repository.sendVoiceNote(
        conversationId: conversationId,
        senderId: currentUserId,
        audioUrl: audioUrl,
        durationSeconds: durationSeconds,
      );
      state = state.copyWith(
        messages: [newMsg, ...state.messages],
        isSending: false,
      );
    } catch (e) {
      state = state.copyWith(isSending: false, errorMessage: e.toString());
    }
  }

  Future<void> requestPhoneReveal() async {
    state = state.copyWith(hasRequestedPhoneReveal: true);
    await _repository.requestPhoneReveal(conversationId, currentUserId);
  }

  Future<void> agreePhoneReveal() async {
    // Both agreed
    state = state.copyWith(isPhoneRevealed: true);
    await _repository.sendSystemMessage(
      conversationId: conversationId,
      content: 'Phone numbers unlocked: Both members agreed to share contact info.',
      action: 'phone_revealed',
    );
  }

  Future<void> blockUser(String otherUserId) async {
    await _repository.blockUser(currentUserId, otherUserId);
  }

  Future<void> reportUser(String otherUserId, String reason, String? description) async {
    await _repository.reportUser(
      reporterId: currentUserId,
      reportedUserId: otherUserId,
      reason: reason,
      description: description,
    );
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    super.dispose();
  }
}

final chatProvider =
    StateNotifierProvider.family<ChatNotifier, ChatState, String>(
        (ref, conversationId) {
  final repository = ref.watch(chatRepositoryProvider);
  return ChatNotifier(repository, conversationId: conversationId);
});
