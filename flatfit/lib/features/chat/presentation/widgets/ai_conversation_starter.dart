import 'package:flutter/material.dart';

class AiConversationStarter extends StatelessWidget {
  final Function(String starter) onSelectStarter;

  const AiConversationStarter({
    Key? key,
    required this.onSelectStarter,
  }) : super(key: key);

  static const List<Map<String, dynamic>> _starters = [
    {
      'icon': Icons.nightlight_round,
      'topic': 'Sleep Habit Match',
      'prompt': 'Hey! I noticed we both sleep around 11 PM. Do you prefer absolute silence or ambient fan sound?',
    },
    {
      'icon': Icons.restaurant_menu,
      'topic': 'Cook & Food Sharing',
      'prompt': 'Hi! Saw you enjoy home cooking too. Do you prefer sharing a cook or cooking individual meals?',
    },
    {
      'icon': Icons.laptop_chromebook,
      'topic': 'WFH Schedule',
      'prompt': 'Hey! Are you working from home full-time or hybrid? Just checking daytime noise expectations.',
    },
    {
      'icon': Icons.weekend,
      'topic': 'Weekend Guests',
      'prompt': 'Hi! What is your general preference regarding having friends over on weekends?',
    },
    {
      'icon': Icons.cleaning_services,
      'topic': 'House Cleanliness',
      'prompt': 'Hey! How do you like splitting daily chores or maid management?',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.12)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                const Icon(
                  Icons.auto_awesome,
                  size: 14,
                  color: Color(0xFF8B5CF6),
                ),
                const SizedBox(width: 6),
                Text(
                  'AI Compatibility Icebreakers',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.purple.shade700,
                    letterSpacing: 0.2,
                  ),
                ),
                const Spacer(),
                Text(
                  'Tap to send',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 38,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _starters.length,
              itemBuilder: (context, index) {
                final item = _starters[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ActionChip(
                    avatar: Icon(
                      item['icon'] as IconData,
                      size: 14,
                      color: const Color(0xFF6366F1),
                    ),
                    label: Text(
                      item['topic'] as String,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF334155),
                      ),
                    ),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    elevation: 0,
                    onPressed: () {
                      onSelectStarter(item['prompt'] as String);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
