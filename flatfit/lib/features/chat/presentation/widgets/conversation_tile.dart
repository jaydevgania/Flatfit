import 'package:flutter/material.dart';
import '../../domain/conversation_model.dart';
import '../../domain/chat_enums.dart';

class ConversationTile extends StatelessWidget {
  final Conversation conversation;
  final String currentUserId;
  final VoidCallback onTap;

  const ConversationTile({
    Key? key,
    required this.conversation,
    required this.currentUserId,
    required this.onTap,
  }) : super(key: key);

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${dateTime.day}/${dateTime.month}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final otherMember = conversation.getOtherMember(currentUserId);
    final displayName = conversation.getDisplayName(currentUserId);
    final avatarUrl = conversation.getDisplayAvatar(currentUserId);
    final isVerified = otherMember?.isVerified ?? false;
    final lastMsg = conversation.lastMessage;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.12),
              width: 1,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar with verified badge
            Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: const Color(0xFF6366F1).withOpacity(0.1),
                  backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
                  child: avatarUrl == null
                      ? Text(
                          displayName.isNotEmpty ? displayName[0].toUpperCase() : 'F',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6366F1),
                          ),
                        )
                      : null,
                ),
                if (isVerified)
                  Positioned(
                    bottom: 0,
                    right: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified,
                        color: Color(0xFF0D9488),
                        size: 16,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            // Name and message preview
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          displayName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E293B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (lastMsg != null)
                        Text(
                          _formatTime(lastMsg.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: conversation.unreadCount > 0
                                ? const Color(0xFF6366F1)
                                : Colors.grey.shade500,
                            fontWeight: conversation.unreadCount > 0
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: _buildMessagePreview(lastMsg),
                      ),
                      if (conversation.unreadCount > 0)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6366F1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            conversation.unreadCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessagePreview(lastMsg) {
    if (lastMsg == null) {
      return Text(
        'Start your compatibility conversation',
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey.shade400,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    IconData? leadingIcon;
    String text = lastMsg.content ?? '';

    if (lastMsg.type == MessageType.voice) {
      leadingIcon = Icons.mic;
      text = 'Voice note (${lastMsg.durationSeconds ?? 0}s)';
    } else if (lastMsg.type == MessageType.image) {
      leadingIcon = Icons.photo;
      text = 'Photo';
    } else if (lastMsg.type == MessageType.system) {
      leadingIcon = Icons.info_outline;
    }

    return Row(
      children: [
        if (leadingIcon != null) ...[
          Icon(leadingIcon, size: 14, color: Colors.grey.shade600),
          const SizedBox(width: 4),
        ],
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13.5,
              color: conversation.unreadCount > 0
                  ? const Color(0xFF1E293B)
                  : Colors.grey.shade600,
              fontWeight: conversation.unreadCount > 0
                  ? FontWeight.w500
                  : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}
