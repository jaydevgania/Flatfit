import 'package:flutter/material.dart';

class WomenOnlyToggle extends StatelessWidget {
  final bool isEnabled;
  final Function(bool value) onChanged;

  const WomenOnlyToggle({
    Key? key,
    required this.isEnabled,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF2F8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFBCFE8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFFF472B6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.female, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Women-Only Community Mode',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF831843),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Strict privacy & verified safety filter',
                      style: TextStyle(fontSize: 11.5, color: Color(0xFF9D174D)),
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: isEnabled,
                activeColor: const Color(0xFFDB2777),
                onChanged: onChanged,
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'When turned ON, you will only see profiles and flat listings from verified female users, and your profile is only discoverable by verified women.',
            style: TextStyle(
              fontSize: 12.5,
              color: Color(0xFF9D174D),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
