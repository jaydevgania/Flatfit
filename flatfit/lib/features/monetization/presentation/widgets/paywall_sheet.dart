import 'package:flutter/material.dart';
import '../screens/flatfit_plus_screen.dart';

class PaywallSheet extends StatelessWidget {
  final String featureTitle;
  final String featureDescription;

  const PaywallSheet({
    super.key,
    required this.featureTitle,
    required this.featureDescription,
  });

  static Future<void> show(
    BuildContext context, {
    required String featureTitle,
    required String featureDescription,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => PaywallSheet(
        featureTitle: featureTitle,
        featureDescription: featureDescription,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          const CircleAvatar(
            radius: 30,
            backgroundColor: Color(0xFFFEF3C7),
            child: Icon(Icons.workspace_premium, color: Color(0xFFD97706), size: 36),
          ),
          const SizedBox(height: 16),
          Text(
            featureTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            featureDescription,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFBBF7D0)),
            ),
            child: const Row(
              children: [
                Icon(Icons.check_circle, color: Color(0xFF16A34A), size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Basic matching & chatting always remain 100% free!',
                    style: TextStyle(color: Color(0xFF15803D), fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D9488),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const FlatFitPlusScreen()),
                );
              },
              child: const Text('Unlock with FlatFit Plus', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Maybe Later', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}
