import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/interest_model.dart';
import '../providers/interest_provider.dart';
import 'profile_detail_screen.dart';

/// Screen displaying incoming and outgoing connection / interest requests.
class InterestRequestsScreen extends ConsumerWidget {
  const InterestRequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final interestState = ref.watch(interestProvider);
    final interestNotifier = ref.read(interestProvider.notifier);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Interest Requests',
              style: TextStyle(fontWeight: FontWeight.bold)),
          bottom: const TabBar(
            labelColor: Color(0xFF4F46E5),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFF4F46E5),
            tabs: [
              Tab(text: 'Received'),
              Tab(text: 'Sent'),
            ],
          ),
        ),
        body: interestState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  // Received Requests Tab
                  _buildInterestList(
                    context: context,
                    interests: interestState.incoming,
                    isIncoming: true,
                    onAccept: (id) =>
                        interestNotifier.respondToInterest(interestId: id, accept: true),
                    onDecline: (id) =>
                        interestNotifier.respondToInterest(interestId: id, accept: false),
                  ),

                  // Sent Requests Tab
                  _buildInterestList(
                    context: context,
                    interests: interestState.outgoing,
                    isIncoming: false,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildInterestList({
    required BuildContext context,
    required List<InterestModel> interests,
    required bool isIncoming,
    ValueChanged<String>? onAccept,
    ValueChanged<String>? onDecline,
  }) {
    if (interests.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isIncoming ? Icons.inbox_rounded : Icons.outbox_rounded,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                isIncoming
                    ? 'No incoming requests yet'
                    : 'No outgoing requests yet',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                isIncoming
                    ? 'When other flatmates swipe right or send you an interest, they will appear here.'
                    : 'Profiles you express interest in will show here.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: interests.length,
      itemBuilder: (context, index) {
        final item = interests[index];
        final profile = isIncoming ? item.fromProfile : item.toProfile;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: item.isSuperInterest
                  ? const Color(0xFFF59E0B)
                  : Colors.grey.shade200,
              width: item.isSuperInterest ? 1.5 : 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: photo, name, super interest badge, status
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        profile?.displayPhoto ??
                            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=600&q=80',
                        width: 52,
                        height: 52,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  profile != null
                                      ? '${profile.fullName}, ${profile.age}'
                                      : 'FlatFit Flatmate',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (item.isSuperInterest) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFEF3C7),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    '⭐ Super',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFB45309),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            profile?.locality ?? 'Mumbai',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Status pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _statusBgColor(item.status),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.status.name.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: _statusTextColor(item.status),
                        ),
                      ),
                    ),
                  ],
                ),

                // Note if present
                if (item.note != null && item.note!.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Text(
                      '"${item.note!}"',
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                ],

                // Action buttons for incoming pending requests
                if (isIncoming && item.status == InterestStatus.pending) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => onDecline?.call(item.id),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey.shade700,
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Decline'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => onAccept?.call(item.id),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: const Text('Accept & Chat'),
                        ),
                      ),
                    ],
                  ),
                ],

                // View profile link
                if (profile != null) ...[
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ProfileDetailScreen(profile: profile),
                          ),
                        );
                      },
                      child: const Text(
                        'View Full Profile →',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4F46E5),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Color _statusBgColor(InterestStatus status) {
    switch (status) {
      case InterestStatus.accepted:
        return const Color(0xFFD1FAE5);
      case InterestStatus.declined:
        return const Color(0xFFFEE2E2);
      case InterestStatus.pending:
      default:
        return const Color(0xFFFEF3C7);
    }
  }

  Color _statusTextColor(InterestStatus status) {
    switch (status) {
      case InterestStatus.accepted:
        return const Color(0xFF047857);
      case InterestStatus.declined:
        return const Color(0xFFB91C1C);
      case InterestStatus.pending:
      default:
        return const Color(0xFFB45309);
    }
  }
}
