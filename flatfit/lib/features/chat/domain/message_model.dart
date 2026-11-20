import 'chat_enums.dart';

class Message {
  final String id;
  final String conversationId;
  final String senderId;
  final String content;
  final MessageType type;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;

  const Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    this.content = '',
    required this.type,
    this.metadata = const {},
    required this.createdAt,
  });

  String? get audioUrl => metadata['audio_url'] as String?;
  int? get durationSeconds => metadata['duration_seconds'] as int?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'conversation_id': conversationId,
        'sender_id': senderId,
        'content': content,
        'type': type.name,
        'metadata': metadata,
        'created_at': createdAt.toIso8601String(),
      };

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json['id'] as String,
        conversationId: json['conversation_id'] as String,
        senderId: json['sender_id'] as String,
        content: json['content'] as String? ?? '',
        type: MessageType.values
            .firstWhere((e) => e.name == json['type'], orElse: () => MessageType.text),
        metadata: Map<String, dynamic>.from(json['metadata'] as Map? ?? {}),
        createdAt: DateTime.parse(json['created_at'] as String),
      );
}
