import 'dart:async';
import 'package:flutter/material.dart';

class ChatInputBar extends StatefulWidget {
  final Function(String text) onSendMessage;
  final Function(String audioUrl, int durationSeconds) onSendVoiceNote;
  final Function(String imageUrl) onSendImage;
  final VoidCallback? onIcebreakerTap;

  const ChatInputBar({
    Key? key,
    required this.onSendMessage,
    required this.onSendVoiceNote,
    required this.onSendImage,
    this.onIcebreakerTap,
  }) : super(key: key);

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final TextEditingController _textController = TextEditingController();
  bool _isRecording = false;
  int _recordSeconds = 0;
  Timer? _recordTimer;

  @override
  void dispose() {
    _textController.dispose();
    _recordTimer?.cancel();
    super.dispose();
  }

  void _handleSend() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      widget.onSendMessage(text);
      _textController.clear();
      setState(() {});
    }
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _recordSeconds = 0;
    });
    _recordTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordSeconds++;
      });
    });
  }

  void _stopAndSendRecording() {
    _recordTimer?.cancel();
    final duration = _recordSeconds > 0 ? _recordSeconds : 3;
    setState(() {
      _isRecording = false;
      _recordSeconds = 0;
    });

    widget.onSendVoiceNote(
      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
      duration,
    );
  }

  void _cancelRecording() {
    _recordTimer?.cancel();
    setState(() {
      _isRecording = false;
      _recordSeconds = 0;
    });
  }

  void _pickMockImage() {
    // Show mock image selector
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final mockPhotos = [
          'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=500',
          'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=500',
          'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=500',
        ];
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Share Room Photo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: mockPhotos.map((url) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(ctx);
                      widget.onSendImage(url);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        url,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: _isRecording ? _buildRecordingBar() : _buildNormalInputBar(),
      ),
    );
  }

  Widget _buildRecordingBar() {
    final m = _recordSeconds ~/ 60;
    final s = _recordSeconds % 60;
    final timeStr = '$m:${s.toString().padLeft(2, '0')}';

    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: _cancelRecording,
        ),
        const SizedBox(width: 8),
        Container(
          width: 10,
          height: 10,
          decoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Recording voice note... $timeStr',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.red,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: _stopAndSendRecording,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFF6366F1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.send, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildNormalInputBar() {
    final hasText = _textController.text.trim().isNotEmpty;

    return Row(
      children: [
        // Attach image
        IconButton(
          icon: const Icon(Icons.add_photo_alternate_outlined),
          color: const Color(0xFF64748B),
          onPressed: _pickMockImage,
        ),
        // Icebreaker trigger
        if (widget.onIcebreakerTap != null)
          IconButton(
            icon: const Icon(Icons.auto_awesome_outlined),
            color: const Color(0xFF8B5CF6),
            tooltip: 'AI Icebreakers',
            onPressed: widget.onIcebreakerTap,
          ),
        // Text field
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(24),
            ),
            child: TextField(
              controller: _textController,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
              maxLines: 4,
              minLines: 1,
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Send or Voice Note button
        if (hasText)
          GestureDetector(
            onTap: _handleSend,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color(0xFF6366F1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send, color: Colors.white, size: 20),
            ),
          )
        else
          GestureDetector(
            onTap: _startRecording,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.mic,
                color: Color(0xFF6366F1),
                size: 20,
              ),
            ),
          ),
      ],
    );
  }
}
