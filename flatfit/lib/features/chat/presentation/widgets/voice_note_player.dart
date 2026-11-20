import 'package:flutter/material.dart';

class VoiceNotePlayer extends StatefulWidget {
  final String? audioUrl;
  final int durationSeconds;
  final bool isMe;

  const VoiceNotePlayer({
    Key? key,
    this.audioUrl,
    required this.durationSeconds,
    this.isMe = false,
  }) : super(key: key);

  @override
  State<VoiceNotePlayer> createState() => _VoiceNotePlayerState();
}

class _VoiceNotePlayerState extends State<VoiceNotePlayer> {
  bool _isPlaying = false;
  double _playbackSpeed = 1.0;
  int _currentSeconds = 0;

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying && _currentSeconds >= widget.durationSeconds) {
        _currentSeconds = 0;
      }
    });
  }

  void _toggleSpeed() {
    setState(() {
      if (_playbackSpeed == 1.0) {
        _playbackSpeed = 1.5;
      } else if (_playbackSpeed == 1.5) {
        _playbackSpeed = 2.0;
      } else {
        _playbackSpeed = 1.0;
      }
    });
  }

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.isMe ? Colors.white : const Color(0xFF6366F1);
    final secondaryColor = widget.isMe ? Colors.white70 : Colors.grey.shade600;

    return Container(
      constraints: const BoxConstraints(maxWidth: 240),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Play / Pause Button
          GestureDetector(
            onTap: _togglePlay,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: widget.isMe
                    ? Colors.white.withOpacity(0.2)
                    : const Color(0xFF6366F1).withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: primaryColor,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Waveform bars simulation
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: List.generate(18, (index) {
                    final heights = [
                      10.0, 16.0, 22.0, 14.0, 8.0, 18.0, 24.0, 16.0, 12.0,
                      20.0, 15.0, 26.0, 18.0, 10.0, 22.0, 14.0, 12.0, 16.0,
                    ];
                    final barHeight = heights[index % heights.length];
                    final isPlayed = index < 8;

                    return Expanded(
                      child: Container(
                        height: barHeight,
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: BoxDecoration(
                          color: isPlayed ? primaryColor : secondaryColor.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(_isPlaying ? _currentSeconds : widget.durationSeconds),
                      style: TextStyle(
                        fontSize: 11,
                        color: secondaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: _toggleSpeed,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: widget.isMe
                              ? Colors.white.withOpacity(0.15)
                              : Colors.grey.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${_playbackSpeed.toStringAsFixed(1)}x',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
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
    );
  }
}
