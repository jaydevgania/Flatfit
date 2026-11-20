import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/ambassador.dart';
import '../providers/community_provider.dart';

class AmbassadorScreen extends ConsumerStatefulWidget {
  const AmbassadorScreen({super.key});

  @override
  ConsumerState<AmbassadorScreen> createState() => _AmbassadorScreenState();
}

class _AmbassadorScreenState extends ConsumerState<AmbassadorScreen> {
  AmbassadorType _selectedType = AmbassadorType.college;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _institutionController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _institutionController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submitApplication() {
    if (_nameController.text.trim().isEmpty || _institutionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields.')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Application Submitted!'),
        content: Text(
          'Thank you ${_nameController.text}! Our campus & corporate partnerships team will review your application for ${_institutionController.text} and email you an official kit with your unique code.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _nameController.clear();
              _institutionController.clear();
              _emailController.clear();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(communityProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ambassador Program'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0D9488), Color(0xFF0F766E)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Represent FlatFit at your Campus or Workplace',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Help new students and colleagues find trusted flatmates. Earn up to ₹500 commission per match, free FlatFit Plus, and official leadership certificates.',
                    style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.35),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Leaderboard
            const Text('Top Ambassadors', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            ...state.ambassadors.map((amb) => _buildAmbassadorCard(amb)),
            const SizedBox(height: 24),

            // Application Form
            const Text('Apply to Become an Ambassador', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            Row(
              children: [
                ChoiceChip(
                  label: const Text('College Ambassador'),
                  selected: _selectedType == AmbassadorType.college,
                  onSelected: (_) => setState(() => _selectedType = AmbassadorType.college),
                  selectedColor: const Color(0xFF0D9488),
                  labelStyle: TextStyle(
                    color: _selectedType == AmbassadorType.college ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Corporate Ambassador'),
                  selected: _selectedType == AmbassadorType.corporate,
                  onSelected: (_) => setState(() => _selectedType = AmbassadorType.corporate),
                  selectedColor: const Color(0xFF0D9488),
                  labelStyle: TextStyle(
                    color: _selectedType == AmbassadorType.corporate ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Full Name *',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _institutionController,
              decoration: InputDecoration(
                labelText: _selectedType == AmbassadorType.college
                    ? 'College / University Name (e.g. IIT Bombay, NMIMS) *'
                    : 'Company Name & Office Location (e.g. Google BKC, Deloitte Powai) *',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: _selectedType == AmbassadorType.college
                    ? 'Student .edu or college email *'
                    : 'Corporate work email (@company.com) *',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D9488),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _submitApplication,
                child: const Text('Submit Ambassador Application', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildAmbassadorCard(AmbassadorProfile amb) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFE6FFFA),
            child: Text(
              amb.name[0],
              style: const TextStyle(color: Color(0xFF0D9488), fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(amb.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text('${amb.institution} • Code: ${amb.ambassadorCode}', style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${amb.totalReferrals} matches', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0D9488))),
              Text('₹${amb.commissionEarned.toInt()} earned', style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}
