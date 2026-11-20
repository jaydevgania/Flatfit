import '../models/hub_models.dart';

/// Predefined guest announcement templates for 1-tap sharing.
class GuestAnnouncementTemplate {
  final String title;
  final String description;
  final CalendarEventType type;
  final Duration duration;

  const GuestAnnouncementTemplate({
    required this.title,
    required this.description,
    required this.type,
    required this.duration,
  });

  static const List<GuestAnnouncementTemplate> presets = [
    GuestAnnouncementTemplate(
      title: 'Friend staying over tonight',
      description: 'College friend in town for job interviews; staying on the living room sofa bed tonight.',
      type: CalendarEventType.guest,
      duration: Duration(days: 1),
    ),
    GuestAnnouncementTemplate(
      title: 'Parents visiting this weekend',
      description: 'Parents arriving Saturday morning and staying till Sunday evening. Will keep common spaces tidy!',
      type: CalendarEventType.guest,
      duration: Duration(days: 2),
    ),
    GuestAnnouncementTemplate(
      title: 'IPL / World Cup match screening',
      description: '3 friends coming over for match night with snacks between 7:30 PM - 11:00 PM.',
      type: CalendarEventType.party,
      duration: Duration(hours: 4),
    ),
    GuestAnnouncementTemplate(
      title: 'Society Maintenance / Pest Control',
      description: 'Society technician coming for scheduled quarterly pest control & pipe inspection.',
      type: CalendarEventType.maintenance,
      duration: Duration(hours: 2),
    ),
    GuestAnnouncementTemplate(
      title: 'Planned Torrent Power / Adani Power Cut',
      description: 'Scheduled maintenance power cut between 10:00 AM - 1:00 PM. Charge laptops beforehand!',
      type: CalendarEventType.powerCut,
      duration: Duration(hours: 3),
    ),
    GuestAnnouncementTemplate(
      title: 'Maid taking leave tomorrow',
      description: 'Sunita didi will not be coming tomorrow (personal work). Clean your own plates!',
      type: CalendarEventType.maidOff,
      duration: Duration(days: 1),
    ),
  ];
}

/// Service handling House Hub operations.
class HubService {
  /// Creates a calendar event and an automatic notice board post from a one-tap guest announcement.
  static ({HubCalendarEvent event, FlatNotice notice}) broadcastAnnouncement({
    required String flatId,
    required String userId,
    required String userName,
    required GuestAnnouncementTemplate template,
    required DateTime startTime,
    String? customNote,
  }) {
    final now = DateTime.now();
    final eventId = 'evt_${now.millisecondsSinceEpoch}';
    final noticeId = 'not_${now.millisecondsSinceEpoch}';

    final fullDescription = customNote != null && customNote.isNotEmpty
        ? '${template.description}\nNote: $customNote'
        : template.description;

    final event = HubCalendarEvent(
      id: eventId,
      flatId: flatId,
      userId: userId,
      creatorName: userName,
      title: template.title,
      description: fullDescription,
      type: template.type,
      startTime: startTime,
      endTime: startTime.add(template.duration),
      isAllDay: template.duration.inHours >= 24,
      createdAt: now,
    );

    final notice = FlatNotice(
      id: noticeId,
      flatId: flatId,
      userId: userId,
      authorName: userName,
      content: '📢 [${template.title}] $fullDescription',
      isPinned: template.type == CalendarEventType.powerCut || template.type == CalendarEventType.maidOff,
      category: template.type == CalendarEventType.powerCut
          ? NoticeCategory.urgent
          : template.type == CalendarEventType.guest || template.type == CalendarEventType.party
              ? NoticeCategory.partyOrGuests
              : NoticeCategory.general,
      createdAt: now,
    );

    return (event: event, notice: notice);
  }

  /// Calculates human-readable status for Quiet Hours.
  static String getQuietHoursStatusMessage({
    required bool isQuietHoursActive,
    String schedule = '11:00 PM - 07:30 AM',
  }) {
    if (isQuietHoursActive) {
      return '🌙 Quiet Hours ACTIVE. Headphone mode on, please keep volume down.';
    } else {
      return '☀️ Normal Hours. Standard quiet hours: $schedule.';
    }
  }
}
