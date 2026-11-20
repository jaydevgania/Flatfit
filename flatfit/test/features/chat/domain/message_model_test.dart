import 'package:flutter_test/flutter_test.dart';
import 'package:flatfit/features/chat/domain/chat_enums.dart';
import 'package:flatfit/features/chat/domain/conversation_model.dart';
import 'package:flatfit/features/chat/domain/message_model.dart';

void main() {
  group('Message and Conversation Domain Tests', () {
    test('Message json serialization and deserialization', () {
      final now = DateTime.now();
      final message = Message(
        id: 'msg_test_1',
        conversationId: 'conv_123',
        senderId: 'user_456',
        content: 'Hey, let us meet at Third Wave!',
        type: MessageType.text,
        metadata: {'platform': 'flatfit_mobile'},
        createdAt: now,
      );

      final json = message.toJson();
      expect(json['id'], 'msg_test_1');
      expect(json['content'], 'Hey, let us meet at Third Wave!');
      expect(json['type'], 'text');

      final deserialized = Message.fromJson(json);
      expect(deserialized.id, message.id);
      expect(deserialized.content, message.content);
      expect(deserialized.type, MessageType.text);
    });

    test('Voice note message metadata parsing', () {
      final msg = Message(
        id: 'voice_1',
        conversationId: 'c1',
        senderId: 'u1',
        type: MessageType.voice,
        metadata: {
          'audio_url': 'https://storage.flatfit.in/voice/123.mp3',
          'duration_seconds': 24,
        },
        createdAt: DateTime.now(),
      );

      expect(msg.audioUrl, 'https://storage.flatfit.in/voice/123.mp3');
      expect(msg.durationSeconds, 24);
      expect(msg.type, MessageType.voice);
    });

    test('Conversation other member retrieval', () {
      final memberA = ConversationMember(
        conversationId: 'c1',
        userId: 'user_me',
        fullName: 'Current User',
        joinedAt: DateTime.now(),
      );

      final memberB = ConversationMember(
        conversationId: 'c1',
        userId: 'user_ananya',
        fullName: 'Ananya Sharma',
        joinedAt: DateTime.now(),
        isVerified: true,
      );

      final conversation = Conversation(
        id: 'c1',
        members: [memberA, memberB],
        createdAt: DateTime.now(),
      );

      final other = conversation.getOtherMember('user_me');
      expect(other?.fullName, 'Ananya Sharma');
      expect(other?.isVerified, true);
      expect(conversation.getDisplayName('user_me'), 'Ananya Sharma');
    });
  });
}
