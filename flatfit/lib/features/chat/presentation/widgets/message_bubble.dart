import 'package:flutter/material.dart';
import '../../domain/chat_enums.dart';
import '../../domain/message_model.dart';
import 'voice_note_player.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;
  final VoidCallback? onSystemActionTap;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.isMe,
    this.onSystemActionTap,
  }) : super(key: key);

  String _formatTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    if (message.type == MessageType.system) {
      return _buildSystemMessage(context);
    }

    final bg = isMe ? const Color(0xFF6366F1) : Colors.white;
    final textColor = isMe ? Colors.white : const Color(0xFF1E293B);

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 16),
          ),
          boxShadow: [
            BoxSideEffect(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Content by type
              if (message.type == MessageType.text)
                Text(
                  message.content ?? '',
                  style: TextStyle(
                    fontSize: 15,
                    color: textColor,
                    height: 1.35,
                  ),
                )
              else if (message.type == MessageType.image)
                _buildImageContent(context)
              else if (message.type == MessageType.voice)
                VoiceNotePlayer(
                  audioUrl: message.audioUrl,
                  durationSeconds: message.durationSeconds ?? 15,
                  isMe: isMe,
                ),

              const SizedBox(height: 4),
              // Timestamp and checkmark
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatTime(message.createdAt),
                    style: TextStyle(
                      fontSize: 10.5,
                      color: isMe ? Colors.white70 : Colors.grey.shade500,
                    ),
                  ),
                  if (isMe) ...[
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.done_all,
                      size: 14,
                      color: Colors.white70,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageContent(BuildContext context) {
    final imgUrl = message.imageUrl;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            color: Colors.grey.shade200,
            constraints: const BoxConstraints(maxHeight: 220),
            width: double.infinity,
            child: imgUrl != null
                ? Image.network(
                    imgUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    ),
                  )
                : const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Icon(Icons.image, color: Colors.grey),
                    ),
                  ),
          ),
        ),
        if (message.content != null && message.content!.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            message.content!,
            style: TextStyle(
              fontSize: 14,
              color: isMe ? Colors.white : const Color(0xFF1E293B),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSystemMessage(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF3C7),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFDE68A)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.shield_outlined,
              size: 16,
              color: Color(0xFFD97706),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                message.content ?? 'System Notification',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF92400E),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BoxSideEffect extends BoxShadow {
  const BoxSideEffect({
    Color color = const Color(0xFF000000),
    Offset offset = Offset.zero,
    double blurRadius = 0.0,
    double spreadRadius = 0.0,
  }) : super(
          color: color,
          offset: offset,
          blurRadius: blurRadius,
          spreadRadius: spreadRadius,
        );
}
