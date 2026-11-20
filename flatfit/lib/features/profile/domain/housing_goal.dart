/// Represents the user's housing goal / intent on FlatFit.
enum HousingGoal {
  /// Looking for a room in an existing flat.
  needRoom('need_room', 'I need a room', '🔍'),

  /// Has a room/flat and looking for a flatmate.
  haveRoom('have_room', 'I have a room', '🏠'),

  /// Wants to find someone to look for a flat together.
  lookingTogether('looking_together', 'Looking together', '🤝');

  const HousingGoal(this.value, this.label, this.emoji);

  /// Stored in the database.
  final String value;

  /// Human-readable label.
  final String label;

  /// Emoji for visual identity.
  final String emoji;

  /// Parse from a database string value.
  static HousingGoal fromValue(String value) {
    return HousingGoal.values.firstWhere(
      (e) => e.value == value,
      orElse: () => HousingGoal.needRoom,
    );
  }
}
