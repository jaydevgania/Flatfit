import 'package:flutter/material.dart';
import '../models/hub_models.dart';

/// Card displaying a flat notice with pin status, category icon, and author timestamp.
class NoticeCard extends StatelessWidget {
  final FlatNotice notice;
  final VoidCallback? onTogglePin;
  final VoidCallback? onDelete;

  const NoticeCard({
    super.key,
    required this.notice,
    this.onTogglePin,
    this.onDelete,
  });

  IconData _getCategoryIcon(NoticeCategory category) {
    switch (category) {
      case NoticeCategory.urgent:
        return Icons.warning_amber_rounded;
      case NoticeCategory.maintenance:
        return Icons.handyman_outlined;
      case NoticeCategory.partyOrGuests:
        return Icons.celebration_outlined;
      case NoticeCategory.applianceIssue:
        return Icons.microwave_outlined;
      case NoticeCategory.lostAndFound:
        return Icons.search_outlined;
      case NoticeCategory.general:
        return Icons.campaign_outlined;
    }
  }

  Color _getCategoryColor(NoticeCategory category) {
    switch (category) {
      case NoticeCategory.urgent:
        return Colors.red.shade700;
      case NoticeCategory.maintenance:
        return Colors.orange.shade800;
      case NoticeCategory.partyOrGuests:
        return Colors.purple.shade700;
      case NoticeCategory.applianceIssue:
        return Colors.blue.shade700;
      case NoticeCategory.lostAndFound:
        return Colors.teal.shade700;
      case NoticeCategory.general:
        return Colors.grey.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    final catColor = _getCategoryColor(notice.category);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: notice.isPinned ? 3 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: notice.isPinned ? Colors.amber.shade400 : Colors.grey.shade200,
          width: notice.isPinned ? 1.5 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: catColor.withOpacity(0.12),
                  child: Icon(_getCategoryIcon(notice.category), size: 16, color: catColor),
                ),
                const SizedBox(width: 8),
                Text(
                  notice.authorName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(width: 8),
                Text(
                  '• ${_timeAgo(notice.createdAt)}',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                ),
                const Spacer(),
                if (notice.isPinned)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    margin: const EdgeInsets.only(right: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.push_pin, size: 12, color: Colors.amber.shade900),
                        const SizedBox(width: 2),
                        Text(
                          'PINNED',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber.shade900,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (onTogglePin != null)
                  IconButton(
                    icon: Icon(
                      notice.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                      size: 18,
                      color: notice.isPinned ? Colors.amber.shade800 : Colors.grey,
                    ),
                    onPressed: onTogglePin,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              notice.content,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade800,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }
}
