/// Occupation type for user profiles.
enum OccupationType {
  working('working', 'Working Professional', '💼'),
  student('student', 'Student', '🎓'),
  freelancer('freelancer', 'Freelancer', '💻');

  const OccupationType(this.value, this.label, this.emoji);

  /// Database value.
  final String value;

  /// Human-readable label.
  final String label;

  /// Emoji icon.
  final String emoji;

  /// Parse from a database string value.
  static OccupationType fromValue(String value) {
    return OccupationType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => OccupationType.working,
    );
  }
}
