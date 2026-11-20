import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/chat_enums.dart';
import '../domain/conversation_model.dart';
import '../domain/message_model.dart';

/// Data source interacting directly with Supabase Database and Realtime service.
class ChatDataSource {
  final SupabaseClient? _client;

  ChatDataSource({SupabaseClient? client})
      : _client = client ?? (Supabase.instance.isInitialized ? Supabase.instance.client : null);

  SupabaseClient? get client => _client;

  /// Fetch conversations for a specific user ID
  Future<List<Map<String, dynamic>>> fetchConversations(String userId) async {
    if (_client == null) {
      return _mockConversations(userId);
    }

    try {
      final response = await _client!
          .from('conversation_members')
          .select('''
            conversation_id,
            joined_at,
            last_read_at,
            is_muted,
            conversations (
              id,
              type,
              title,
              created_at
            ),
            profiles (
              id,
              full_name,
              avatar_url,
              phone
            )
          ''')
          .eq('user_id', userId);

      final List<Map<String, dynamic>> results = [];
      for (final item in (response as List<dynamic>)) {
        final conv = item['conversations'] as Map<String, dynamic>?;
        if (conv != null) {
          // Fetch members for this conversation
          final membersResponse = await _client!
              .from('conversation_members')
              .select('user_id, last_read_at, is_muted, profiles(id, full_name, avatar_url, phone)')
              .eq('conversation_id', conv['id']);

          // Fetch latest message
          final lastMsgResponse = await _client!
              .from('messages')
              .select()
              .eq('conversation_id', conv['id'])
              .order('created_at', ascending: false)
              .limit(1);

          final Map<String, dynamic> convData = {
            'id': conv['id'],
            'type': conv['type'],
            'title': conv['title'],
            'created_at': conv['created_at'],
            'conversation_members': membersResponse,
            'last_message': (lastMsgResponse as List).isNotEmpty ? lastMsgResponse.first : null,
            'unread_count': 0,
          };
          results.add(convData);
        }
      }
      return results;
    } catch (e) {
      // Fallback to mock in case of table/auth absence during testing
      return _mockConversations(userId);
    }
  }

  /// Fetch messages for a conversation with pagination
  Future<List<Map<String, dynamic>>> fetchMessages(
    String conversationId, {
    int limit = 50,
    DateTime? before,
  }) async {
    if (_client == null) {
      return _mockMessages(conversationId);
    }

    try {
      var query = _client!
          .from('messages')
          .select()
          .eq('conversation_id', conversationId)
          .order('created_at', ascending: false)
          .limit(limit);

      if (before != null) {
        query = query.lt('created_at', before.toIso8601String());
      }

      final response = await query;
      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      return _mockMessages(conversationId);
    }
  }

  /// Subscribe to Realtime messages on a conversation channel
  RealtimeChannel? subscribeToMessages({
    required String conversationId,
    required void Function(Map<String, dynamic> payload) onNewMessage,
    void Function(Map<String, dynamic> payload)? onMessageUpdated,
  }) {
    if (_client == null) return null;

    final channelName = 'chat:$conversationId';
    final channel = _client!.channel(channelName);

    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'conversation_id',
            value: conversationId,
          ),
          callback: (payload) {
            onNewMessage(payload.newRecord);
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'conversation_id',
            value: conversationId,
          ),
          callback: (payload) {
            if (onMessageUpdated != null) {
              onMessageUpdated(payload.newRecord);
            }
          },
        )
        .subscribe();

    return channel;
  }

  /// Send message to Supabase
  Future<Map<String, dynamic>> sendMessage(Map<String, dynamic> messageData) async {
    if (_client == null) {
      return {
        ...messageData,
        'id': 'msg_${DateTime.now().millisecondsSinceEpoch}',
        'created_at': DateTime.now().toIso8601String(),
      };
    }

    try {
      final response = await _client!
          .from('messages')
          .insert(messageData)
          .select()
          .single();
      return response;
    } catch (e) {
      return {
        ...messageData,
        'id': 'msg_offline_${DateTime.now().millisecondsSinceEpoch}',
        'created_at': DateTime.now().toIso8601String(),
      };
    }
  }

  /// Mark conversation as read
  Future<void> markAsRead(String conversationId, String userId) async {
    if (_client == null) return;
    try {
      await _client!
          .from('conversation_members')
          .update({'last_read_at': DateTime.now().toIso8601String()})
          .match({'conversation_id': conversationId, 'user_id': userId});
    } catch (_) {}
  }

  /// Block a user
  Future<void> blockUser(String blockerId, String blockedId, {String? reason}) async {
    if (_client == null) return;
    try {
      await _client!.from('blocked_users').insert({
        'blocker_id': blockerId,
        'blocked_id': blockedId,
        'reason': reason ?? 'Blocked from chat',
      });
    } catch (_) {}
  }

  /// Report a user or message
  Future<void> reportUser({
    required String reporterId,
    String? reportedUserId,
    String? reportedMessageId,
    required String reason,
    String? description,
  }) async {
    if (_client == null) return;
    try {
      await _client!.from('reports').insert({
        'reporter_id': reporterId,
        'reported_user_id': reportedUserId,
        'reported_message_id': reportedMessageId,
        'reason': reason,
        'description': description,
        'status': 'pending',
      });
    } catch (_) {}
  }

  /// Mock data fallback for preview & tests
  List<Map<String, dynamic>> _mockConversations(String userId) {
    return [
      {
        'id': 'conv_1',
        'type': 'direct',
        'created_at': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
        'conversation_members': [
          {
            'user_id': userId,
            'full_name': 'You',
            'last_read_at': DateTime.now().toIso8601String(),
            'is_muted': false,
          },
          {
            'user_id': 'user_ananya',
            'full_name': 'Ananya Sharma',
            'avatar_url': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
            'phone': '+91 98201 44552',
            'last_read_at': DateTime.now().subtract(const Duration(minutes: 5)).toIso8601String(),
            'is_muted': false,
            'profiles': {
              'id': 'user_ananya',
              'full_name': 'Ananya Sharma',
              'avatar_url': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
              'phone': '+91 98201 44552',
              'is_verified': true,
            }
          }
        ],
        'last_message': {
          'id': 'msg_1',
          'conversation_id': 'conv_1',
          'sender_id': 'user_ananya',
          'content': 'Hey! Are you open to visiting the Bandra 2BHK this Saturday morning?',
          'type': 'text',
          'created_at': DateTime.now().subtract(const Duration(minutes: 12)).toIso8601String(),
        },
        'unread_count': 1,
        'is_phone_revealed': false,
      },
      {
        'id': 'conv_2',
        'type': 'direct',
        'created_at': DateTime.now().subtract(const Duration(days: 5)).toIso8601String(),
        'conversation_members': [
          {
            'user_id': userId,
            'full_name': 'You',
            'last_read_at': DateTime.now().toIso8601String(),
            'is_muted': false,
          },
          {
            'user_id': 'user_rohit',
            'full_name': 'Rohit Verma',
            'avatar_url': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
            'phone': '+91 98192 33411',
            'last_read_at': DateTime.now().subtract(const Duration(hours: 3)).toIso8601String(),
            'is_muted': false,
            'profiles': {
              'id': 'user_rohit',
              'full_name': 'Rohit Verma',
              'avatar_url': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
              'phone': '+91 98192 33411',
              'is_verified': true,
            }
          }
        ],
        'last_message': {
          'id': 'msg_2',
          'conversation_id': 'conv_2',
          'sender_id': userId,
          'content': 'Sounds good. Let us meet at Third Wave Coffee.',
          'type': 'text',
          'created_at': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
        },
        'unread_count': 0,
        'is_phone_revealed': true,
      }
    ];
  }

  List<Map<String, dynamic>> _mockMessages(String conversationId) {
    final now = DateTime.now();
    return [
      {
        'id': 'msg_101',
        'conversation_id': conversationId,
        'sender_id': 'system',
        'content': 'FlatFit Safety Tip: Keep conversations on-app until your first neutral public meetup.',
        'type': 'system',
        'metadata': {'system_action': 'safety_alert'},
        'created_at': now.subtract(const Duration(hours: 4)).toIso8601String(),
      },
      {
        'id': 'msg_102',
        'conversation_id': conversationId,
        'sender_id': 'user_ananya',
        'content': 'Hi! Saw your profile on FlatFit. We both work from home and love quiet evenings!',
        'type': 'text',
        'metadata': {},
        'created_at': now.subtract(const Duration(hours: 3)).toIso8601String(),
      },
      {
        'id': 'msg_103',
        'conversation_id': conversationId,
        'sender_id': 'current_user',
        'content': 'Hey Ananya! Yes, exactly. I usually sleep by 11 PM and keep the common areas clean.',
        'type': 'text',
        'metadata': {},
        'created_at': now.subtract(const Duration(hours: 2)).toIso8601String(),
      },
      {
        'id': 'msg_104',
        'conversation_id': conversationId,
        'sender_id': 'user_ananya',
        'content': 'Here is a quick voice note about the society amenities and cook arrangements!',
        'type': 'voice',
        'metadata': {
          'audio_url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
          'duration_seconds': 18,
        },
        'created_at': now.subtract(const Duration(minutes: 45)).toIso8601String(),
      },
      {
        'id': 'msg_105',
        'conversation_id': conversationId,
        'sender_id': 'user_ananya',
        'content': 'Hey! Are you open to visiting the Bandra 2BHK this Saturday morning?',
        'type': 'text',
        'metadata': {},
        'created_at': now.subtract(const Duration(minutes: 12)).toIso8601String(),
      },
    ];
  }
}
