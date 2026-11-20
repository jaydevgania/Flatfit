import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/onboarding_provider.dart';

/// Screen 5 in Onboarding: Bio text area with character counter and prompt ideas
class BioScreen extends ConsumerStatefulWidget {
  const BioScreen({super.key});

  @override
  ConsumerState<BioScreen> createState() => _BioScreenState();
}

class _BioScreenState extends ConsumerState<BioScreen> {
  late TextEditingController _bioController;
  static const int _maxLength = 500;
  static const int _minRecommended = 40;

  final List<String> _promptTemplates = [
    '☕ Early riser who loves morning chai & quiet mornings.',
    '💻 Full-time WFH software dev, easygoing & respectful of privacy.',
    '🧹 Clean freak about the kitchen and common spaces.',
    '🍳 Love cooking pasta & North Indian curries on weekends.',
    '🎧 Ambivert: recharge in my room, but down for board games.',
  ];

  @override
  void initState() {
    super.initState();
    final draft = ref.read(onboardingProvider);
    _bioController = TextEditingController(text: draft.bio);
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  void _addPrompt(String prompt) {
    final current = _bioController.text.trim();
    if (current.isEmpty) {
      _bioController.text = prompt;
    } else {
      _bioController.text = '$current\n$prompt';
    }
    _syncState();
    setState(() {});
  }

  void _syncState() {
    ref.read(onboardingProvider.notifier).setBio(_bioController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textLength = _bioController.text.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Write your bio ✍️',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Share a bit about your lifestyle, hobbies, and what you are like to live with.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),

          // Bio Text Area
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: textLength >= _minRecommended
                    ? Colors.grey.shade400
                    : Colors.amber.shade400,
              ),
              color: Colors.grey.shade50,
            ),
            child: Column(
              children: [
                TextField(
                  controller: _bioController,
                  maxLines: 7,
                  maxLength: _maxLength,
                  decoration: const InputDecoration(
                    hintText:
                        'e.g. Hey! I am a product designer in Bangalore. I keep things chill, clean up after cooking, and respect personal boundaries. Looking for like-minded flatmates!',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                    counterText: '',
                  ),
                  onChanged: (_) {
                    _syncState();
                    setState(() {});
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        textLength < _minRecommended
                            ? 'Need at least ${_minRecommended - textLength} more chars'
                            : 'Looks good! ✨',
                        style: TextStyle(
                          fontSize: 12,
                          color: textLength < _minRecommended
                              ? Colors.amber.shade800
                              : Colors.green.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '$textLength/$_maxLength',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Prompts / Inspiration
          Text(
            'Need inspiration? Tap to add:',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 10),
          Column(
            children: _promptTemplates.map((prompt) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: () => _addPrompt(prompt),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            prompt,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.add_circle_outline,
                          size: 18,
                          color: theme.colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
