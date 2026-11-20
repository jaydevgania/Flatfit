import 'dart:async';
import 'package:flutter/material.dart';

class SafetySosButton extends StatefulWidget {
  final VoidCallback onTriggerSos;

  const SafetySosButton({Key? key, required this.onTriggerSos})
      : super(key: key);

  @override
  State<SafetySosButton> createState() => _SafetySosButtonState();
}

class _SafetySosButtonState extends State<SafetySosButton> {
  bool _isHolding = false;
  double _holdProgress = 0.0;
  Timer? _holdTimer;

  void _startHolding() {
    setState(() {
      _isHolding = true;
      _holdProgress = 0.0;
    });

    _holdTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        _holdProgress += 0.05;
        if (_holdProgress >= 1.0) {
          timer.cancel();
          _isHolding = false;
          _holdProgress = 0.0;
          widget.onTriggerSos();
        }
      });
    });
  }

  void _cancelHolding() {
    _holdTimer?.cancel();
    setState(() {
      _isHolding = false;
      _holdProgress = 0.0;
    });
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) => _startHolding(),
      onLongPressEnd: (_) => _cancelHolding(),
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          color: Colors.red.shade600,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.4),
              blurRadius: 18,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (_isHolding)
              SizedBox(
                width: 136,
                height: 136,
                child: CircularProgressIndicator(
                  value: _holdProgress,
                  strokeWidth: 6,
                  color: Colors.white,
                ),
              ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.emergency, color: Colors.white, size: 40),
                const SizedBox(height: 6),
                const Text(
                  'SOS',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  _isHolding ? 'HOLDING...' : 'HOLD 2 SEC',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
