/// Listing types:
/// haveRoom: User has an available room in their flat and is seeking a flatmate.
/// needFlatmate: Group of individuals looking for a flat together or person needing a flatmate.
enum ListingType {
  haveRoom,
  needFlatmate;

  static ListingType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'need_flatmate':
      case 'needflatmate':
        return ListingType.needFlatmate;
      case 'have_room':
      case 'haveroom':
      default:
        return ListingType.haveRoom;
    }
  }

  String toDbValue() {
    switch (this) {
      case ListingType.haveRoom:
        return 'have_room';
      case ListingType.needFlatmate:
        return 'need_flatmate';
    }
  }

  String get displayName {
    switch (this) {
      case ListingType.haveRoom:
        return 'Have a Room (Need Flatmate)';
      case ListingType.needFlatmate:
        return 'Need Flatmate (Looking Together)';
    }
  }
}

/// Lifecycle status of a property listing.
enum ListingStatus {
  active,
  paused,
  filled;

  static ListingStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'paused':
        return ListingStatus.paused;
      case 'filled':
        return ListingStatus.filled;
      case 'active':
      default:
        return ListingStatus.active;
    }
  }

  String toDbValue() => name;
}

/// Types of rooms available in a flat.
enum RoomType {
  single,
  shared,
  master,
  hall;

  static RoomType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'shared':
        return RoomType.shared;
      case 'master':
        return RoomType.master;
      case 'hall':
        return RoomType.hall;
      case 'single':
      default:
        return RoomType.single;
    }
  }

  String get displayName {
    switch (this) {
      case RoomType.single:
        return 'Private / Single Room';
      case RoomType.shared:
        return 'Shared / Double Occupancy';
      case RoomType.master:
        return 'Master Bedroom with Attached Bath';
      case RoomType.hall:
        return 'Partition / Hall Spot';
    }
  }
}
