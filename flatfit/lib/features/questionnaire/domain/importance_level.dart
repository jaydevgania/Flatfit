/// How important a particular lifestyle preference is to the user.
enum ImportanceLevel {
  dealBreaker('deal_breaker', 'Deal-breaker', '🚫', 0xFFE53935),
  important('important', 'Important', '⭐', 0xFFFFA726),
  niceToHave('nice_to_have', 'Nice to have', '👌', 0xFF66BB6A);

  const ImportanceLevel(this.value, this.label, this.emoji, this.colorValue);

  /// Database value.
  final String value;

  /// Display label.
  final String label;

  /// Emoji for visual identity.
  final String emoji;

  /// Color value (ARGB int) for UI.
  final int colorValue;

  /// Parse from database value.
  static ImportanceLevel fromValue(String value) {
    return ImportanceLevel.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ImportanceLevel.niceToHave,
    );
  }
}
