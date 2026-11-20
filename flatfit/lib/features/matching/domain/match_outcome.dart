/// Outcome of a match — used for future ML training data.
///
/// The progression is: matched → met → movedIn → stayed.
/// Each stage is logged independently so a learning-to-rank model can
/// weight features that predict long-term success.
enum MatchOutcome {
  /// Both users expressed interest (mutual match).
  matched,

  /// They met in person (either virtually or physically).
  met,

  /// They moved in together.
  movedIn,

  /// They stayed together for 3+ months.
  stayed;

  /// Numeric value for ordering / comparison.
  int get stageIndex => index;

  /// Whether this outcome indicates a successful living arrangement.
  bool get isSuccessful => this == movedIn || this == stayed;

  /// Parse from a database string.
  static MatchOutcome fromString(String value) {
    return MatchOutcome.values.firstWhere(
      (e) => e.name == value,
      orElse: () => MatchOutcome.matched,
    );
  }
}
