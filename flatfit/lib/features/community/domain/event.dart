/// Type of community event organized for FlatFit members.
enum EventType {
  newInTownMixer,
  boardGameNight,
  flatmateSpeedDating,
  coffeeWalk,
  sportsAndFitness,
}

extension EventTypeExtension on EventType {
  String get displayName {
    switch (this) {
      case EventType.newInTownMixer:
        return 'New-in-Town Mixer';
      case EventType.boardGameNight:
        return 'Board Game Night';
      case EventType.flatmateSpeedDating:
        return 'Flatmate Speed Meet';
      case EventType.coffeeWalk:
        return 'Weekend Coffee Walk';
      case EventType.sportsAndFitness:
        return 'Turf Football / Badminton';
    }
  }
}

/// User RSVP response status.
enum RsvpStatus {
  going,
  interested,
  notGoing,
}

/// Community gathering or social mixer event.
class CommunityEvent {
  final String id;
  final String title;
  final EventType type;
  final String description;
  final DateTime date;
  final String locationName;
  final String address;
  final String city;
  final int maxAttendees;
  final int currentAttendees;
  final bool isFree;
  final double? fee;
  final String organizerName;
  final RsvpStatus userRsvp;
  final String? coverImageUrl;

  const CommunityEvent({
    required this.id,
    required this.title,
    required this.type,
    required this.description,
    required this.date,
    required this.locationName,
    required this.address,
    this.city = 'Mumbai',
    required this.maxAttendees,
    required this.currentAttendees,
    this.isFree = true,
    this.fee,
    required this.organizerName,
    this.userRsvp = RsvpStatus.notGoing,
    this.coverImageUrl,
  });

  CommunityEvent copyWith({
    RsvpStatus? userRsvp,
    int? currentAttendees,
  }) {
    return CommunityEvent(
      id: id,
      title: title,
      type: type,
      description: description,
      date: date,
      locationName: locationName,
      address: address,
      city: city,
      maxAttendees: maxAttendees,
      currentAttendees: currentAttendees ?? this.currentAttendees,
      isFree: isFree,
      fee: fee,
      organizerName: organizerName,
      userRsvp: userRsvp ?? this.userRsvp,
      coverImageUrl: coverImageUrl,
    );
  }

  bool get isFull => currentAttendees >= maxAttendees;
}

/// Seed list of upcoming community events in Mumbai.
class MockCommunityEvents {
  static final List<CommunityEvent> list = [
    CommunityEvent(
      id: 'event_mixer_1',
      title: 'Bandra Flatmate Speed Meet & Chai',
      type: EventType.flatmateSpeedDating,
      description: 'Looking for a flatmate in Bandra/Khar? Meet 20+ verified seekers over hot chai and casual 5-minute compatibility chats. Structured icebreakers included.',
      date: DateTime.now().add(const Duration(days: 3, hours: 18)),
      locationName: 'Doolally Taproom, Khar West',
      address: 'Raj Kutir, Khar West, Mumbai',
      maxAttendees: 30,
      currentAttendees: 22,
      isFree: true,
      organizerName: 'FlatFit Community Team',
    ),
    CommunityEvent(
      id: 'event_boardgames_1',
      title: 'Versova Board Game & Catan Social',
      type: EventType.boardGameNight,
      description: 'Break the ice without awkward small talk. Play Catan, Secret Hitler, and Exploding Kittens with fellow flat-hunters and new residents.',
      date: DateTime.now().add(const Duration(days: 6, hours: 19)),
      locationName: 'Leaping Windows Cafe, Versova',
      address: 'Yari Road, Versova, Andheri West',
      maxAttendees: 24,
      currentAttendees: 18,
      isFree: false,
      fee: 250, // covers beverage
      organizerName: 'Mumbai Dice Club',
    ),
    CommunityEvent(
      id: 'event_powai_run_1',
      title: 'Sunday Morning Powai Lake Walk & Coffee',
      type: EventType.coffeeWalk,
      description: 'A relaxed 4 km morning stroll around Powai lake promenade followed by iced coffees at Aroma\'s Cafe. Connect with flatmates in the tech hub.',
      date: DateTime.now().add(const Duration(days: 4, hours: 7)),
      locationName: 'Powai Lake Promenade & Haiko Plaza',
      address: 'Central Ave, Hiranandani Gardens, Powai',
      maxAttendees: 40,
      currentAttendees: 31,
      isFree: true,
      organizerName: 'Powai Young Professionals',
    ),
  ];
}
