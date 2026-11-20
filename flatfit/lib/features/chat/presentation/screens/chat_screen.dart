import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/message_model.dart';
import '../providers/chat_provider.dart';
import '../widgets/ai_conversation_starter.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/masked_phone_widget.dart';
import '../widgets/message_bubble.dart';
import '../widgets/report_block_sheet.dart';
import 'meet_scheduler_screen.dart';
import 'video_call_screen.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String conversationId;
  final String otherMemberName;
  final String? otherMemberAvatar;
  final String? otherMemberPhone;

  const ChatScreen({
    Key? key,
    required this.conversationId,
    required this.otherMemberName,
    this.otherMemberAvatar,
    this.otherMemberPhone,
  }) : super(key: key);

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showAiStarters = true;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider(widget.conversationId));
    final chatNotifier = ref.read(chatProvider(widget.conversationId).notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFF6366F1).withOpacity(0.1),
              backgroundImage: widget.otherMemberAvatar != null
                  ? NetworkImage(widget.otherMemberAvatar!)
                  : null,
              child: widget.otherMemberAvatar == null
                  ? Text(
                      widget.otherMemberName.isNotEmpty
                          ? widget.otherMemberName[0].toUpperCase()
                          : 'F',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6366F1),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          widget.otherMemberName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.verified,
                        color: Color(0xFF0D9488),
                        size: 15,
                      ),
                    ],
                  ),
                  const Text(
                    'Online • 94% Compatibility',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF10B981),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          // Schedule Meet button
          IconButton(
            icon: const Icon(Icons.event_available, color: Color(0xFF6366F1)),
            tooltip: 'Schedule Public Meet',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MeetSchedulerScreen(
                    conversationId: widget.conversationId,
                    partnerName: widget.otherMemberName,
                  ),
                ),
              );
            },
          ),
          // In-app Video call placeholder
          IconButton(
            icon: const Icon(Icons.videocam_outlined, color: Color(0xFF475569)),
            tooltip: 'Video Call',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VideoCallScreen(
                    partnerName: widget.otherMemberName,
                    partnerAvatar: widget.otherMemberAvatar,
                  ),
                ),
              );
            },
          ),
          // Report / Block Menu
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Color(0xFF475569)),
            onSelected: (value) {
              if (value == 'report') {
                ReportBlockSheet.show(
                  context,
                  targetUserName: widget.otherMemberName,
                  onReport: (reason, desc) {
                    chatNotifier.reportUser('user_other', reason, desc);
                  },
                  onBlock: () {
                    chatNotifier.blockUser('user_other');
                    Navigator.pop(context);
                  },
                );
              } else if (value == 'safety') {
                _showSafetyInfo(context);
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: 'safety',
                child: Row(
                  children: [
                    Icon(Icons.shield_outlined, size: 18),
                    SizedBox(width: 8),
                    Text('Safety Checklist'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'report',
                child: Row(
                  children: [
                    Icon(Icons.flag_outlined, size: 18, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Report / Block User', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Masked phone consent widget
          MaskedPhoneWidget(
            isRevealed: chatState.isPhoneRevealed,
            hasRequested: chatState.hasRequestedPhoneReveal,
            phoneNumber: widget.otherMemberPhone ?? '+91 98201 44552',
            onRequestReveal: () => chatNotifier.requestPhoneReveal(),
            onAgreeReveal: () => chatNotifier.agreePhoneReveal(),
          ),

          // AI Conversation Starter Suggestions
          if (_showAiStarters && chatState.messages.length < 8)
            AiConversationStarter(
              onSelectStarter: (starterText) {
                chatNotifier.sendTextMessage(starterText);
                setState(() {
                  _showAiStarters = false;
                });
                _scrollToBottom();
              },
            ),

          // Chat messages list
          Expanded(
            child: chatState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: chatState.messages.length,
                    itemBuilder: (context, index) {
                      final msg = chatState.messages[index];
                      final isMe = msg.senderId == chatNotifier.currentUserId;
                      return MessageBubble(
                        message: msg,
                        isMe: isMe,
                      );
                    },
                  ),
          ),

          // Typing or sending indicator
          if (chatState.isSending)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              alignment: Alignment.centerRight,
              child: const Text(
                'Sending message...',
                style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
              ),
            ),

          // Bottom input bar
          ChatInputBar(
            onSendMessage: (text) {
              chatNotifier.sendTextMessage(text);
              _scrollToBottom();
            },
            onSendVoiceNote: (audioUrl, duration) {
              chatNotifier.sendVoiceNote(audioUrl, duration);
              _scrollToBottom();
            },
            onSendImage: (imageUrl) {
              chatNotifier.sendImage(imageUrl);
              _scrollToBottom();
            },
            onIcebreakerTap: () {
              setState(() {
                _showAiStarters = !_showAiStarters;
              });
            },
          ),
        ],
      ),
    );
  }

  void _showSafetyInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.verified_user, color: Color(0xFF0D9488)),
                SizedBox(width: 8),
                Text(
                  'FlatFit Safe Chat Protocol',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              '• All chat exchanges are scanned client-side for scam keywords and phishing links.',
              style: TextStyle(fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 8),
            const Text(
              '• Contact numbers remain encrypted and masked until mutual consent.',
              style: TextStyle(fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 8),
            const Text(
              '• Do not pay any token deposit before meeting at the flat and signing a trial or rent agreement.',
              style: TextStyle(fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1)),
                onPressed: () => Navigator.pop(context),
                child: const Text('Got it'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
