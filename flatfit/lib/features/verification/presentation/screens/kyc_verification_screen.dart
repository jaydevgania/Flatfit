import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/trust_provider.dart';
import '../providers/verification_provider.dart';

class KycVerificationScreen extends ConsumerStatefulWidget {
  const KycVerificationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<KycVerificationScreen> createState() =>
      _KycVerificationScreenState();
}

class _KycVerificationScreenState extends ConsumerState<KycVerificationScreen> {
  String _selectedIdType = 'aadhaar';
  final TextEditingController _idNumberController =
      TextEditingController(text: 'XXXX-XXXX-4589');
  bool _hasUploadedIdPhoto = true;
  bool _hasUploadedSelfie = true;
  bool _isProcessing = false;

  @override
  void dispose() {
    _idNumberController.dispose();
    super.dispose();
  }

  Future<void> _submitKyc() async {
    setState(() => _isProcessing = true);

    // Simulate OCR and Face-Match Liveness
    await Future.delayed(const Duration(milliseconds: 1500));

    final success = await ref.read(verificationProvider.notifier).submitKyc(
          idType: _selectedIdType,
          maskedIdNumber: _idNumberController.text.trim(),
          idPhotoUrl: 'https://images.unsplash.com/photo-1544717305-2782549b5136?w=400',
          selfiePhotoUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400',
        );

    if (success) {
      await ref.read(trustProvider.notifier).recalculate();
    }

    if (mounted) {
      setState(() => _isProcessing = false);
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Row(
            children: const [
              Icon(Icons.check_circle, color: Color(0xFF0D9488)),
              SizedBox(width: 8),
              Text('KYC Verified!'),
            ],
          ),
          content: const Text(
            'Your identity document was verified against face liveness matching. +30 Trust Points added to your profile!',
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1)),
              child: const Text('Back to Center'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Government ID Verification'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // DPDP Privacy Notice
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFBBF7D0)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.lock, color: Color(0xFF16A34A), size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'DPDP Act & UIDAI Compliance: FlatFit does not store raw Aadhaar numbers or physical document copies. Only cryptographically hashed verification tokens are preserved.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF15803D),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Select Document Type
            const Text(
              '1. Select Identity Document',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedIdType,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color(0xFFF8FAFC),
              ),
              items: const [
                DropdownMenuItem(value: 'aadhaar', child: Text('Aadhaar Card (Masked)')),
                DropdownMenuItem(value: 'passport', child: Text('Indian Passport')),
                DropdownMenuItem(value: 'driving_license', child: Text('Driving License')),
                DropdownMenuItem(value: 'voter_id', child: Text('Voter ID (EPIC)')),
              ],
              onChanged: (val) => setState(() => _selectedIdType = val!),
            ),
            const SizedBox(height: 16),

            // Masked ID Number
            TextField(
              controller: _idNumberController,
              decoration: InputDecoration(
                labelText: 'Masked Document Number',
                hintText: 'e.g. XXXX-XXXX-1234',
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                suffixIcon: const Icon(Icons.shield_outlined),
              ),
            ),
            const SizedBox(height: 24),

            // Upload Document Front & Back
            const Text(
              '2. Document Scan / Photo',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFCBD5E1), style: BorderStyle.solid),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.document_scanner, color: Color(0xFF6366F1), size: 36),
                  const SizedBox(width: 12),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Document Uploaded & Redacted',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      Text(
                        'aadhaar_masked_scan.jpg (Verified)',
                        style: TextStyle(color: Color(0xFF0D9488), fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Selfie Liveness Match
            const Text(
              '3. Live Selfie for Face-Match Verification',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFCBD5E1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: Color(0xFFEEF2FF),
                    child: Icon(Icons.face_retouching_natural, color: Color(0xFF6366F1), size: 28),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Selfie Captured (Liveness Confirmed)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      Text(
                        '98.4% Match with Document Photo',
                        style: TextStyle(color: Color(0xFF0D9488), fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _submitKyc,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isProcessing
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          ),
                          SizedBox(width: 12),
                          Text('Verifying Document via Mock Provider...'),
                        ],
                      )
                    : const Text(
                        'Submit KYC for Instant Verification',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
