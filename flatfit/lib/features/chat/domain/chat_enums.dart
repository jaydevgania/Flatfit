/// Message types supported by FlatFit chat system.
enum MessageType {
  text,
  image,
  voice,
  system;

  static MessageType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'image':
        return MessageType.image;
      case 'voice':
        return MessageType.voice;
      case 'system':
        return MessageType.system;
      case 'text':
      default:
        return MessageType.text;
    }
  }

  String toJson() => name;
}

/// Type of conversation.
enum ConversationType {
  direct,
  group;

  static ConversationType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'group':
        return ConversationType.group;
      case 'direct':
      default:
        return ConversationType.direct;
    }
  }

  String toJson() => name;
}

/// Status of conversation.
enum ConversationStatus {
  active,
  archived,
  blocked,
}

/// Meetup status between potential flatmates.
enum MeetStatus {
  pending,
  accepted,
  declined,
  completed,
  cancelled;

  static MeetStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'accepted':
        return MeetStatus.accepted;
      case 'declined':
        return MeetStatus.declined;
      case 'completed':
        return MeetStatus.completed;
      case 'cancelled':
        return MeetStatus.cancelled;
      case 'pending':
      default:
        return MeetStatus.pending;
    }
  }

  String toJson() => name;
}
