import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/trust_provider.dart';
import '../providers/verification_provider.dart';

class EmailVerificationScreen extends ConsumerStatefulWidget {
  final bool isCollege;

  const EmailVerificationScreen({
    Key? key,
    this.isCollege = false,
  }) : super(key: key);

  @override
  ConsumerState<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState
    extends ConsumerState<EmailVerificationScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _codeSent = false;
  bool _isVerifying = false;

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _sendCode() {
    if (_emailController.text.trim().isEmpty || !_emailController.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid official email address.')),
      );
      return;
    }
    setState(() {
      _codeSent = true;
    });
  }

  Future<void> _verifyCode() async {
    final code = _otpController.text.trim();
    if (code.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the 4-digit code sent to your email.')),
      );
      return;
    }

    setState(() => _isVerifying = true);
    final success = await ref
        .read(verificationProvider.notifier)
        .verifyEmailOtp(code, isCollege: widget.isCollege);

    if (success) {
      await ref.read(trustProvider.notifier).recalculate();
    }

    if (mounted) {
      setState(() => _isVerifying = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${widget.isCollege ? "College" : "Work"} email verified! +10 Trust points added.',
          ),
          backgroundColor: const Color(0xFF0D9488),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isCollege
        ? 'University / College Email'
        : 'Official Work Email';
    final hint = widget.isCollege
        ? 'rollnumber@iitb.ac.in or student@du.ac.in'
        : 'yourname@company.com';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Verify your ${widget.isCollege ? "Student / Alumni" : "Employment"} Status',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'A verification code will be sent to confirm your institutional domain. We never send spam or share your email publicly.',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.4),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              enabled: !_codeSent,
              decoration: InputDecoration(
                labelText: widget.isCollege ? 'College Email Address' : 'Corporate Email Address',
                hintText: hint,
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                prefixIcon: Icon(widget.isCollege ? Icons.school : Icons.business),
              ),
            ),
            const SizedBox(height: 16),
            if (!_codeSent)
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _sendCode,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1)),
                  child: const Text('Send Verification Code'),
                ),
              )
            else ...[
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Enter 4-Digit Verification Code',
                  hintText: '1234',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color(0xFFF8FAFC),
                  prefixIcon: Icon(Icons.key),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isVerifying ? null : _verifyCode,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D9488)),
                  child: _isVerifying
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Confirm & Verify Email'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
