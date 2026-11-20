import 'package:flutter/material.dart';
import '../models/agreement_models.dart';
import '../services/digital_signature_service.dart';

/// Interactive digital signing canvas screen with legal declaration.
class DigitalSignScreen extends StatefulWidget {
  final FlatmateAgreement agreement;
  final String userId;
  final String userName;

  const DigitalSignScreen({
    super.key,
    required this.agreement,
    required this.userId,
    required this.userName,
  });

  @override
  State<DigitalSignScreen> createState() => _DigitalSignScreenState();
}

class _DigitalSignScreenState extends State<DigitalSignScreen> {
  final List<List<Offset>> _strokes = [];
  List<Offset> _currentStroke = [];
  bool _hasAgreedToDeclaration = false;
  bool _isSigning = false;

  void _clearSignature() {
    setState(() {
      _strokes.clear();
      _currentStroke.clear();
    });
  }

  void _submitSignature() {
    if (_strokes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please draw your signature in the box above')),
      );
      return;
    }

    if (!_hasAgreedToDeclaration) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the legal declaration before signing')),
      );
      return;
    }

    setState(() => _isSigning = true);

    // Compute stroke coordinate count for mock SVG/data representation
    final totalPoints = _strokes.fold<int>(0, (sum, stroke) => sum + stroke.length);
    final signatureData = 'DRAWN_STROKES_${_strokes.length}_POINTS_$totalPoints';

    final result = DigitalSignatureService.signAgreement(
      agreement: widget.agreement,
      userId: widget.userId,
      userName: widget.userName,
      signatureData: signatureData,
      ipAddress: '49.36.128.42', // Mumbai Airtel broadband mock IP
    );

    setState(() => _isSigning = false);

    if (result.isSuccess && result.signature != null) {
      Navigator.pop(context, result.signature);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.errorMessage ?? 'Signing failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Signing'),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sign Co-Living Agreement',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Signing as ${widget.userName} for "${widget.agreement.title}".',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Draw Signature Inside Box',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Clear'),
                  onPressed: _clearSignature,
                ),
              ],
            ),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: BorderSide(color: Colors.teal.shade300, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: GestureDetector(
                onPanStart: (details) {
                  setState(() {
                    _currentStroke = [details.localPosition];
                    _strokes.add(_currentStroke);
                  });
                },
                onPanUpdate: (details) {
                  setState(() {
                    _currentStroke.add(details.localPosition);
                  });
                },
                child: CustomPaint(
                  painter: _SignaturePainter(strokes: _strokes),
                  size: Size.infinite,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Use your finger or stylus to sign above',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _hasAgreedToDeclaration,
                    activeColor: Colors.teal.shade700,
                    onChanged: (val) {
                      setState(() => _hasAgreedToDeclaration = val ?? false);
                    },
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'I declare that I have read and agreed to all ${_agreement.clauses.length} house rule clauses. '
                        'I understand this electronic signature is recognized under Section 10A of the Indian Information Technology Act, 2000.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade800,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: _isSigning
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.verified_user_outlined),
                label: Text(
                  _isSigning ? 'Securing Checksum...' : 'Confirm & Affix Signature',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                onPressed: _isSigning ? null : _submitSignature,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SignaturePainter extends CustomPainter {
  final List<List<Offset>> strokes;

  _SignaturePainter({required this.strokes});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.indigo.shade900
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    for (final stroke in strokes) {
      if (stroke.isEmpty) continue;
      final path = Path()..moveTo(stroke.first.dx, stroke.first.dy);
      for (int i = 1; i < stroke.length; i++) {
        path.lineTo(stroke[i].dx, stroke[i].dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SignaturePainter oldDelegate) => true;
}
