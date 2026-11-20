class ConversationMember {
  final String conversationId;
  final String userId;
  final String fullName;
  final DateTime joinedAt;
  final bool isVerified;

  const ConversationMember({
    required this.conversationId,
    required this.userId,
    required this.fullName,
    required this.joinedAt,
    this.isVerified = false,
  });
}

class Conversation {
  final String id;
  final List<ConversationMember> members;
  final DateTime createdAt;

  const Conversation({
    required this.id,
    required this.members,
    required this.createdAt,
  });

  ConversationMember? getOtherMember(String currentUserId) {
    for (final member in members) {
      if (member.userId != currentUserId) return member;
    }
    return null;
  }

  String? getDisplayName(String currentUserId) =>
      getOtherMember(currentUserId)?.fullName;
}
