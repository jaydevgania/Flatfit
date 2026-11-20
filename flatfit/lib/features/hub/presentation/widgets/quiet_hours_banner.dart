import 'package:flutter/material.dart';

/// Interactive top banner displaying and toggling House Quiet-Hours.
class QuietHoursBanner extends StatelessWidget {
  final bool isActive;
  final ValueChanged<bool> onToggle;
  final String schedule;

  const QuietHoursBanner({
    super.key,
    required this.isActive,
    required this.onToggle,
    this.schedule = '11:00 PM - 07:30 AM',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isActive ? Colors.indigo.shade900 : Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(14),
        border: BorderSide(
          color: isActive ? Colors.indigo.shade700 : Colors.indigo.shade100,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: Colors.indigo.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: isActive ? Colors.amber : Colors.indigo.shade100,
            radius: 20,
            child: Icon(
              isActive ? Icons.nightlight_round : Icons.wb_sunny_outlined,
              color: isActive ? Colors.black87 : Colors.indigo.shade900,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      isActive ? 'Quiet Hours Active' : 'House Quiet Hours',
                      style: TextStyle(
                        color: isActive ? Colors.white : Colors.indigo.shade900,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    if (isActive) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red.shade400,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'ON',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  isActive
                      ? 'Please use headphones; flatmates sleeping/resting.'
                      : 'Scheduled: $schedule. Tap switch to turn on early.',
                  style: TextStyle(
                    color: isActive ? Colors.indigo.shade100 : Colors.indigo.shade700,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isActive,
            activeColor: Colors.amber,
            activeTrackColor: Colors.amber.shade200,
            onChanged: onToggle,
          ),
        ],
      ),
    );
  }
}
