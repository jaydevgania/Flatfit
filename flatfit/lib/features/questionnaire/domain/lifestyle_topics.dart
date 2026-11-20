/// All lifestyle topics covered by the questionnaire.
enum LifestyleTopic {
  sleep('sleep', 'Sleep', '😴', 0xFF5C6BC0),
  cleanliness('cleanliness', 'Cleanliness', '🧹', 0xFF26A69A),
  food('food', 'Food', '🍽️', 0xFFEF5350),
  cooking('cooking', 'Cooking', '👨‍🍳', 0xFFFF7043),
  smoking('smoking', 'Smoking', '🚬', 0xFF78909C),
  drinking('drinking', 'Drinking', '🍺', 0xFFFFA726),
  guests('guests', 'Guests', '🏠', 0xFF42A5F5),
  noise('noise', 'Noise', '🔊', 0xFFAB47BC),
  pets('pets', 'Pets', '🐾', 0xFF8D6E63),
  wfh('wfh', 'Work from Home', '💻', 0xFF5C6BC0),
  bills('bills', 'Bills', '💰', 0xFF66BB6A),
  rentPunctuality('rent_punctuality', 'Rent', '🏦', 0xFF26C6DA),
  introvertExtrovert('introvert_extrovert', 'Social Energy', '🧑‍🤝‍🧑', 0xFFEC407A),
  conflict('conflict', 'Conflict', '🤝', 0xFFFFCA28),
  parties('parties', 'Parties', '🎉', 0xFFFF7043),
  weekend('weekend', 'Weekend', '☀️', 0xFF29B6F6);

  const LifestyleTopic(this.value, this.label, this.emoji, this.colorValue);

  /// Database value.
  final String value;

  /// Display label.
  final String label;

  /// Emoji icon.
  final String emoji;

  /// Color value (ARGB int).
  final int colorValue;

  /// Parse from database value.
  static LifestyleTopic fromValue(String value) {
    return LifestyleTopic.values.firstWhere(
      (e) => e.value == value,
      orElse: () => LifestyleTopic.sleep,
    );
  }
}
