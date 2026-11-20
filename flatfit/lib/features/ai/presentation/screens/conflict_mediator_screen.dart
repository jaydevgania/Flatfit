import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/conflict_mediator.dart';
import '../providers/ai_providers.dart';

/// Screen helping flatmates draft constructive, de-escalating messages during disagreements.
class ConflictMediatorScreen extends ConsumerStatefulWidget {
  const ConflictMediatorScreen({super.key});

  @override
  ConsumerState<ConflictMediatorScreen> createState() => _ConflictMediatorScreenState();
}

class _ConflictMediatorScreenState extends ConsumerState<ConflictMediatorScreen> {
  final TextEditingController _inputController = TextEditingController();

  final List<String> _quickDisputes = [
    'Dishes piled in the sink again',
    'Electricity bill is overdue',
    'Friends staying over without heads-up',
    'Loud music late night while sleeping',
    'Someone drank my almond milk from fridge',
  ];

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _runMediation(String text) {
    _inputController.text = text;
    ref.read(conflictMediatorProvider.notifier).mediate(text);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(conflictMediatorProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FlatFit Conflict Mediator'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Intro Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFBBF7D0)),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.handshake_outlined, color: Color(0xFF16A34A), size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'De-escalate House Friction',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF15803D)),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Type what is bothering you in your own words. We will rephrase it into polite, actionable communication that gets results without awkward tension.',
                          style: TextStyle(fontSize: 12, color: Color(0xFF166534), height: 1.3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Quick disputes
            const Text('Common Situations', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _quickDisputes.map((q) {
                return ActionChip(
                  label: Text(q, style: const TextStyle(fontSize: 12)),
                  backgroundColor: Colors.grey.shade100,
                  onPressed: () => _runMediation(q),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Input TextField
            const Text('What do you want to say?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            TextField(
              controller: _inputController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'e.g. "You never wash your dishes and the sink is overflowing..."',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Transform to Kind & Clear'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D9488),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => _runMediation(_inputController.text),
              ),
            ),
            const SizedBox(height: 24),

            // Result Display
            if (state.result != null) ...[
              _buildToneSelector(state),
              const SizedBox(height: 12),
              _buildRewrittenMessageCard(context, state),
              const SizedBox(height: 16),
              _buildHouseRuleProposal(context, state.result!.suggestedCompromiseRule),
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildToneSelector(ConflictMediatorState state) {
    final tones = [
      {'tone': MediatorTone.gentleFriendly, 'label': 'Gentle & Warm'},
      {'tone': MediatorTone.diplomaticBalanced, 'label': 'Diplomatic'},
      {'tone': MediatorTone.clearDirect, 'label': 'Clear & Direct'},
    ];

    return Row(
      children: tones.map((item) {
        final tone = item['tone'] as MediatorTone;
        final label = item['label'] as String;
        final isSelected = state.selectedTone == tone;

        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(label),
            selected: isSelected,
            selectedColor: const Color(0xFF4F46E5),
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 12,
            ),
            onSelected: (_) => ref.read(conflictMediatorProvider.notifier).setTone(tone),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRewrittenMessageCard(BuildContext context, ConflictMediatorState state) {
    final text = state.result!.rewrites[state.selectedTone] ?? '';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF4F46E5).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.check_circle_outline, color: Color(0xFF4F46E5), size: 18),
                  SizedBox(width: 6),
                  Text('Send this to your flatmate:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.copy, size: 18),
                tooltip: 'Copy Message',
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: text));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Message copied to clipboard!')),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            text,
            style: const TextStyle(fontSize: 14, height: 1.45, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildHouseRuleProposal(BuildContext context, String rule) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.rule, color: Colors.amber.shade900, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Long-term Solution',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF78350F)),
                ),
                const SizedBox(height: 4),
                Text(
                  rule,
                  style: TextStyle(fontSize: 12, color: Colors.amber.shade900, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
