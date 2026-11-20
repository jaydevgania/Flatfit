import 'dart:async';
import 'package:flutter/material.dart';

class VideoCallScreen extends StatefulWidget {
  final String partnerName;
  final String? partnerAvatar;

  const VideoCallScreen({
    Key? key,
    required this.partnerName,
    this.partnerAvatar,
  }) : super(key: key);

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  bool _isMuted = false;
  bool _isVideoOff = false;
  bool _isFrontCamera = true;
  int _callSeconds = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _callSeconds++;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Stack(
        children: [
          // Simulated Remote Video Feed (WebRTC / Agora stream)
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFF1E293B),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 54,
                    backgroundImage: widget.partnerAvatar != null
                        ? NetworkImage(widget.partnerAvatar!)
                        : null,
                    child: widget.partnerAvatar == null
                        ? Text(
                            widget.partnerName.isNotEmpty
                                ? widget.partnerName[0].toUpperCase()
                                : 'F',
                            style: const TextStyle(fontSize: 40, color: Colors.white),
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.partnerName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'FlatFit Video Intro • ${_formatDuration(_callSeconds)}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF38BDF8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Local Self-Preview Window (Picture-in-picture)
          Positioned(
            top: 50,
            right: 18,
            child: Container(
              width: 110,
              height: 155,
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white24, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _isVideoOff
                    ? const Center(
                        child: Icon(Icons.videocam_off, color: Colors.white60),
                      )
                    : Stack(
                        children: [
                          Container(
                            color: const Color(0xFF334155),
                            child: const Center(
                              child: Icon(Icons.person, size: 40, color: Colors.white38),
                            ),
                          ),
                          const Positioned(
                            bottom: 6,
                            left: 6,
                            child: Text(
                              'You',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),

          // FlatFit Privacy Watermark
          Positioned(
            top: 52,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: const [
                  Icon(Icons.lock, size: 12, color: Color(0xFF10B981)),
                  SizedBox(width: 4),
                  Text(
                    'End-to-End Encrypted',
                    style: TextStyle(fontSize: 11, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Control Panel
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Toggle Mic
                _buildControlButton(
                  icon: _isMuted ? Icons.mic_off : Icons.mic,
                  color: _isMuted ? Colors.red : Colors.white24,
                  iconColor: Colors.white,
                  onTap: () => setState(() => _isMuted = !_isMuted),
                ),
                // Toggle Camera
                _buildControlButton(
                  icon: _isVideoOff ? Icons.videocam_off : Icons.videocam,
                  color: _isVideoOff ? Colors.red : Colors.white24,
                  iconColor: Colors.white,
                  onTap: () => setState(() => _isVideoOff = !_isVideoOff),
                ),
                // Flip Camera
                _buildControlButton(
                  icon: Icons.flip_camera_ios,
                  color: Colors.white24,
                  iconColor: Colors.white,
                  onTap: () => setState(() => _isFrontCamera = !_isFrontCamera),
                ),
                // End Call
                _buildControlButton(
                  icon: Icons.call_end,
                  color: Colors.red.shade600,
                  iconColor: Colors.white,
                  size: 60,
                  iconSize: 30,
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
    double size = 50,
    double iconSize = 24,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: iconSize),
      ),
    );
  }
}
