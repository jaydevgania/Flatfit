import 'package:flutter/material.dart';
import '../../domain/listing_model.dart';

class CurrentFlatmatesSection extends StatelessWidget {
  final List<FlatmateProfile> flatmates;

  const CurrentFlatmatesSection({
    Key? key,
    required this.flatmates,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (flatmates.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Text(
          'No current flatmates listed or flat is fully vacant.',
          style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.people_alt_outlined, size: 18, color: Color(0xFF6366F1)),
            SizedBox(width: 8),
            Text(
              'Current Flatmates (Shared with Consent)',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...flatmates.map((flatmate) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundImage: flatmate.avatarUrl != null
                      ? NetworkImage(flatmate.avatarUrl!)
                      : null,
                  child: flatmate.avatarUrl == null
                      ? Text(
                          flatmate.fullName.isNotEmpty ? flatmate.fullName[0] : 'F',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${flatmate.fullName}, ${flatmate.age}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          if (flatmate.isVerified) ...[
                            const SizedBox(width: 4),
                            const Icon(Icons.verified, size: 14, color: Color(0xFF0D9488)),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        flatmate.occupation,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6366F1),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (flatmate.bio != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          flatmate.bio!,
                          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}
