import 'chat_enums.dart';
import 'message_model.dart';

/// Member profile info within a conversation.
class ConversationMember {
  final String conversationId;
  final String userId;
  final String fullName;
  final String? avatarUrl;
  final bool isVerified;
  final String? phone;
  final DateTime joinedAt;
  final DateTime? lastReadAt;
  final bool isMuted;

  const ConversationMember({
    required this.conversationId,
    required this.userId,
    required this.fullName,
    this.avatarUrl,
    this.isVerified = false,
    this.phone,
    required this.joinedAt,
    this.lastReadAt,
    this.isMuted = false,
  });

  factory ConversationMember.fromJson(Map<String, dynamic> json) {
    final profile = json['profiles'] as Map<String, dynamic>?;
    return ConversationMember(
      conversationId: json['conversation_id'] as String? ?? '',
      userId: json['user_id'] as String? ?? (profile != null ? profile['id'] as String? ?? '' : ''),
      fullName: profile != null 
          ? profile['full_name'] as String? ?? 'Flatmate' 
          : json['full_name'] as String? ?? 'Flatmate',
      avatarUrl: profile != null ? profile['avatar_url'] as String? : json['avatar_url'] as String?,
      isVerified: profile != null ? (profile['is_verified'] as bool? ?? false) : false,
      phone: profile != null ? profile['phone'] as String? : json['phone'] as String?,
      joinedAt: json['joined_at'] != null 
          ? DateTime.tryParse(json['joined_at'].toString()) ?? DateTime.now() 
          : DateTime.now(),
      lastReadAt: json['last_read_at'] != null 
          ? DateTime.tryParse(json['last_read_at'].toString()) 
          : null,
      isMuted: json['is_muted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'conversation_id': conversationId,
      'user_id': userId,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'is_verified': isVerified,
      'phone': phone,
      'joined_at': joinedAt.toIso8601String(),
      'last_read_at': lastReadAt?.toIso8601String(),
      'is_muted': isMuted,
    };
  }
}

/// Represents a conversation channel between flatmates.
class Conversation {
  final String id;
  final ConversationType type;
  final String? title;
  final List<ConversationMember> members;
  final Message? lastMessage;
  final int unreadCount;
  final DateTime createdAt;
  final bool isPhoneRevealed;

  const Conversation({
    required this.id,
    this.type = ConversationType.direct,
    this.title,
    this.members = const [],
    this.lastMessage,
    this.unreadCount = 0,
    required this.createdAt,
    this.isPhoneRevealed = false,
  });

  /// Returns the other participant in a 1-to-1 conversation.
  ConversationMember? getOtherMember(String currentUserId) {
    if (members.isEmpty) return null;
    return members.firstWhere(
      (m) => m.userId != currentUserId,
      orElse: () => members.first,
    );
  }

  /// Display title for the conversation (other member's name or group title).
  String getDisplayName(String currentUserId) {
    if (type == ConversationType.group && title != null && title!.isNotEmpty) {
      return title!;
    }
    final other = getOtherMember(currentUserId);
    return other?.fullName ?? 'Flatmate';
  }

  /// Display avatar URL for the conversation.
  String? getDisplayAvatar(String currentUserId) {
    final other = getOtherMember(currentUserId);
    return other?.avatarUrl;
  }

  factory Conversation.fromJson(Map<String, dynamic> json, {String? currentUserId}) {
    final rawMembers = json['conversation_members'] as List<dynamic>? ?? [];
    final membersList = rawMembers
        .map((m) => ConversationMember.fromJson(m as Map<String, dynamic>))
        .toList();

    Message? lastMsg;
    if (json['last_message'] != null && json['last_message'] is Map) {
      lastMsg = Message.fromJson(Map<String, dynamic>.from(json['last_message'] as Map));
    } else if (json['messages'] != null && (json['messages'] as List).isNotEmpty) {
      lastMsg = Message.fromJson(Map<String, dynamic>.from((json['messages'] as List).first as Map));
    }

    return Conversation(
      id: json['id'] as String,
      type: json['type'] != null 
          ? ConversationType.fromString(json['type'].toString()) 
          : ConversationType.direct,
      title: json['title'] as String?,
      members: membersList,
      lastMessage: lastMsg,
      unreadCount: json['unread_count'] as int? ?? 0,
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now() 
          : DateTime.now(),
      isPhoneRevealed: json['is_phone_revealed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toJson(),
      'title': title,
      'members': members.map((m) => m.toJson()).toList(),
      'last_message': lastMessage?.toJson(),
      'unread_count': unreadCount,
      'created_at': createdAt.toIso8601String(),
      'is_phone_revealed': isPhoneRevealed,
    };
  }

  Conversation copyWith({
    String? id,
    ConversationType? type,
    String? title,
    List<ConversationMember>? members,
    Message? lastMessage,
    int? unreadCount,
    DateTime? createdAt,
    bool? isPhoneRevealed,
  }) {
    return Conversation(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      members: members ?? this.members,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
      createdAt: createdAt ?? this.createdAt,
      isPhoneRevealed: isPhoneRevealed ?? this.isPhoneRevealed,
    );
  }
}
