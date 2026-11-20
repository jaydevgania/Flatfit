import 'chat_enums.dart';

/// Represents a single chat message in FlatFit.
class Message {
  final String id;
  final String conversationId;
  final String senderId;
  final String? content;
  final MessageType type;
  final Map<String, dynamic> metadata;
  final bool isDeleted;
  final DateTime createdAt;

  const Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    this.content,
    this.type = MessageType.text,
    this.metadata = const {},
    this.isDeleted = false,
    required this.createdAt,
  });

  /// Helper getters for metadata
  String? get imageUrl => metadata['image_url'] as String? ?? metadata['imageUrl'] as String?;
  String? get audioUrl => metadata['audio_url'] as String? ?? metadata['audioUrl'] as String?;
  int? get durationSeconds => metadata['duration_seconds'] as int? ?? metadata['durationSeconds'] as int?;
  String? get systemAction => metadata['system_action'] as String? ?? metadata['action'] as String?;
  bool get isMaskedPhoneReveal => systemAction == 'phone_reveal';

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      conversationId: json['conversation_id'] as String? ?? json['conversationId'] as String? ?? '',
      senderId: json['sender_id'] as String? ?? json['senderId'] as String? ?? '',
      content: json['content'] as String?,
      type: json['type'] != null 
          ? MessageType.fromString(json['type'].toString()) 
          : MessageType.text,
      metadata: json['metadata'] != null && json['metadata'] is Map 
          ? Map<String, dynamic>.from(json['metadata'] as Map) 
          : const {},
      isDeleted: json['is_deleted'] as bool? ?? json['isDeleted'] as bool? ?? false,
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'sender_id': senderId,
      'content': content,
      'type': type.toJson(),
      'metadata': metadata,
      'is_deleted': isDeleted,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Message copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? content,
    MessageType? type,
    Map<String, dynamic>? metadata,
    bool? isDeleted,
    DateTime? createdAt,
  }) {
    return Message(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      type: type ?? this.type,
      metadata: metadata ?? this.metadata,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Message &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
