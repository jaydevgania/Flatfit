import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/event.dart';
import '../providers/community_provider.dart';

class EventDetailScreen extends ConsumerWidget {
  final CommunityEvent event;

  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(communityProvider);
    final currentEvent = state.events.firstWhere((e) => e.id == event.id, orElse: () => event);
    final isGoing = currentEvent.userRsvp == RsvpStatus.going;

    return Scaffold(
      appBar: AppBar(
        title: Text(currentEvent.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      currentEvent.type.displayName,
                      style: const TextStyle(color: Color(0xFF0D9488), fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    currentEvent.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentEvent.description,
                    style: TextStyle(color: Colors.grey.shade800, fontSize: 14, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Date & Venue Details
            const Text('Event Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            _buildDetailRow(
              Icons.calendar_today,
              'Date & Time',
              '${currentEvent.date.day}/${currentEvent.date.month}/${currentEvent.date.year} at ${currentEvent.date.hour}:${currentEvent.date.minute.toString().padLeft(2, '0')} PM',
            ),
            _buildDetailRow(
              Icons.location_on_outlined,
              'Venue Location',
              '${currentEvent.locationName}\n${currentEvent.address}',
            ),
            _buildDetailRow(
              Icons.people_outline,
              'Attendance',
              '${currentEvent.currentAttendees} confirmed / ${currentEvent.maxAttendees} max capacity',
            ),
            _buildDetailRow(
              Icons.person_pin,
              'Organized by',
              currentEvent.organizerName,
            ),
            const SizedBox(height: 30),

            // RSVP button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: Icon(isGoing ? Icons.check : Icons.celebration),
                label: Text(isGoing ? 'You are Going (Cancel RSVP)' : 'RSVP to Attend'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isGoing ? Colors.grey.shade300 : const Color(0xFF0D9488),
                  foregroundColor: isGoing ? Colors.black87 : Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  ref.read(communityProvider.notifier).rsvpEvent(
                        currentEvent.id,
                        isGoing ? RsvpStatus.notGoing : RsvpStatus.going,
                      );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isGoing ? 'RSVP cancelled.' : 'RSVP confirmed! See you at the event.',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF0D9488), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
