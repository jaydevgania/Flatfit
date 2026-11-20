import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/chat_enums.dart';
import '../domain/conversation_model.dart';
import '../domain/message_model.dart';
import 'chat_data_source.dart';

abstract class ChatRepository {
  Future<List<Conversation>> getConversations(String userId);
  Future<List<Message>> getMessages(String conversationId, {int limit = 50, DateTime? before});
  Stream<Message> subscribeToNewMessages(String conversationId);
  Future<Message> sendMessage({
    required String conversationId,
    required String senderId,
    required String text,
    Map<String, dynamic>? metadata,
  });
  Future<Message> sendImageMessage({
    required String conversationId,
    required String senderId,
    required String imageUrl,
    String? caption,
  });
  Future<Message> sendVoiceNote({
    required String conversationId,
    required String senderId,
    required String audioUrl,
    required int durationSeconds,
  });
  Future<Message> sendSystemMessage({
    required String conversationId,
    required String content,
    required String action,
    Map<String, dynamic>? extra,
  });
  Future<void> markAsRead(String conversationId, String userId);
  Future<void> blockUser(String blockerId, String blockedId, {String? reason});
  Future<void> reportUser({
    required String reporterId,
    String? reportedUserId,
    String? reportedMessageId,
    required String reason,
    String? description,
  });
  Future<bool> requestPhoneReveal(String conversationId, String userId);
}

class ChatRepositoryImpl implements ChatRepository {
  final ChatDataSource _dataSource;
  final Map<String, StreamController<Message>> _messageStreams = {};

  ChatRepositoryImpl({ChatDataSource? dataSource})
      : _dataSource = dataSource ?? ChatDataSource();

  @override
  Future<List<Conversation>> getConversations(String userId) async {
    final rawList = await _dataSource.fetchConversations(userId);
    return rawList.map((e) => Conversation.fromJson(e, currentUserId: userId)).toList();
  }

  @override
  Future<List<Message>> getMessages(
    String conversationId, {
    int limit = 50,
    DateTime? before,
  }) async {
    final rawMessages = await _dataSource.fetchMessages(
      conversationId,
      limit: limit,
      before: before,
    );
    return rawMessages.map((e) => Message.fromJson(e)).toList();
  }

  @override
  Stream<Message> subscribeToNewMessages(String conversationId) {
    if (_messageStreams.containsKey(conversationId)) {
      return _messageStreams[conversationId]!.stream;
    }

    final controller = StreamController<Message>.broadcast();
    _messageStreams[conversationId] = controller;

    _dataSource.subscribeToMessages(
      conversationId: conversationId,
      onNewMessage: (payload) {
        final message = Message.fromJson(payload);
        controller.add(message);
      },
    );

    return controller.stream;
  }

  @override
  Future<Message> sendMessage({
    required String conversationId,
    required String senderId,
    required String text,
    Map<String, dynamic>? metadata,
  }) async {
    final data = {
      'conversation_id': conversationId,
      'sender_id': senderId,
      'content': text,
      'type': MessageType.text.toJson(),
      'metadata': metadata ?? {},
      'created_at': DateTime.now().toIso8601String(),
    };

    final result = await _dataSource.sendMessage(data);
    final message = Message.fromJson(result);
    _messageStreams[conversationId]?.add(message);
    return message;
  }

  @override
  Future<Message> sendImageMessage({
    required String conversationId,
    required String senderId,
    required String imageUrl,
    String? caption,
  }) async {
    final data = {
      'conversation_id': conversationId,
      'sender_id': senderId,
      'content': caption,
      'type': MessageType.image.toJson(),
      'metadata': {
        'image_url': imageUrl,
      },
      'created_at': DateTime.now().toIso8601String(),
    };

    final result = await _dataSource.sendMessage(data);
    final message = Message.fromJson(result);
    _messageStreams[conversationId]?.add(message);
    return message;
  }

  @override
  Future<Message> sendVoiceNote({
    required String conversationId,
    required String senderId,
    required String audioUrl,
    required int durationSeconds,
  }) async {
    final data = {
      'conversation_id': conversationId,
      'sender_id': senderId,
      'content': 'Voice note ($durationSeconds s)',
      'type': MessageType.voice.toJson(),
      'metadata': {
        'audio_url': audioUrl,
        'duration_seconds': durationSeconds,
      },
      'created_at': DateTime.now().toIso8601String(),
    };

    final result = await _dataSource.sendMessage(data);
    final message = Message.fromJson(result);
    _messageStreams[conversationId]?.add(message);
    return message;
  }

  @override
  Future<Message> sendSystemMessage({
    required String conversationId,
    required String content,
    required String action,
    Map<String, dynamic>? extra,
  }) async {
    final metadata = {
      'system_action': action,
      ...?extra,
    };

    final data = {
      'conversation_id': conversationId,
      'sender_id': 'system',
      'content': content,
      'type': MessageType.system.toJson(),
      'metadata': metadata,
      'created_at': DateTime.now().toIso8601String(),
    };

    final result = await _dataSource.sendMessage(data);
    final message = Message.fromJson(result);
    _messageStreams[conversationId]?.add(message);
    return message;
  }

  @override
  Future<void> markAsRead(String conversationId, String userId) async {
    await _dataSource.markAsRead(conversationId, userId);
  }

  @override
  Future<void> blockUser(String blockerId, String blockedId, {String? reason}) async {
    await _dataSource.blockUser(blockerId, blockedId, reason: reason);
  }

  @override
  Future<void> reportUser({
    required String reporterId,
    String? reportedUserId,
    String? reportedMessageId,
    required String reason,
    String? description,
  }) async {
    await _dataSource.reportUser(
      reporterId: reporterId,
      reportedUserId: reportedUserId,
      reportedMessageId: reportedMessageId,
      reason: reason,
      description: description,
    );
  }

  @override
  Future<bool> requestPhoneReveal(String conversationId, String userId) async {
    // Both users must tap Reveal Phone to unlock contact numbers
    await sendSystemMessage(
      conversationId: conversationId,
      content: 'Phone reveal requested. Both parties must tap Reveal to exchange contact numbers safely.',
      action: 'phone_reveal',
      extra: {'requested_by': userId, 'timestamp': DateTime.now().toIso8601String()},
    );
    return true;
  }
}
