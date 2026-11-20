import 'package:flutter/foundation.dart';

/// Hard filters that must pass before compatibility scoring begins.
///
/// If any hard filter fails, the pair is instantly rejected (no score computed).
@immutable
class HardFilters {
  /// Minimum budget overlap percentage required (0.0–1.0).
  /// Default is 0.20 (20%).
  final double minBudgetOverlapRatio;

  /// Maximum distance in km between preferred localities.
  /// Used when no locality strings overlap exactly.
  final double maxDistanceKm;

  /// Maximum allowed gap in days between move-in dates.
  final int moveInWindowDays;

  /// Whether gender preference filtering is enabled.
  final bool enforceGenderPref;

  /// Whether deal-breaker conflict filtering is enabled.
  final bool enforceDealBreakers;

  const HardFilters({
    this.minBudgetOverlapRatio = 0.20,
    this.maxDistanceKm = 5.0,
    this.moveInWindowDays = 30,
    this.enforceGenderPref = true,
    this.enforceDealBreakers = true,
  });

  /// Default hard filters.
  static const defaults = HardFilters();

  // ---------- Hard filter checks (pure, no side effects) ----------

  /// Returns true if the budget ranges overlap by at least
  /// [minBudgetOverlapRatio] of the smaller range span.
  bool budgetOverlaps({
    required int aMin,
    required int aMax,
    required int bMin,
    required int bMax,
  }) {
    if (aMax < bMin || bMax < aMin) return false;

    final overlapStart = aMin > bMin ? aMin : bMin;
    final overlapEnd = aMax < bMax ? aMax : bMax;
    final overlap = (overlapEnd - overlapStart).toDouble();

    final spanA = (aMax - aMin).toDouble();
    final spanB = (bMax - bMin).toDouble();
    final smallerSpan = spanA < spanB ? spanA : spanB;

    // If either range is a single point, overlap > 0 is enough.
    if (smallerSpan == 0) return overlap >= 0;

    return (overlap / smallerSpan) >= minBudgetOverlapRatio;
  }

  /// Returns true if the two users share at least one preferred locality
  /// or their geo-points are within [maxDistanceKm].
  bool locationMatches({
    required List<String> localitiesA,
    required List<String> localitiesB,
    double? distanceKm,
  }) {
    // Check exact locality overlap (case-insensitive).
    final setA = localitiesA.map((l) => l.toLowerCase()).toSet();
    final setB = localitiesB.map((l) => l.toLowerCase()).toSet();
    if (setA.intersection(setB).isNotEmpty) return true;

    // Fallback to geo-distance.
    if (distanceKm != null && distanceKm <= maxDistanceKm) return true;

    return false;
  }

  /// Returns true if move-in dates are within [moveInWindowDays] of each other.
  bool moveInDatesAlign(DateTime? dateA, DateTime? dateB) {
    if (dateA == null || dateB == null) return true; // flexible
    final diff = dateA.difference(dateB).inDays.abs();
    return diff <= moveInWindowDays;
  }

  /// Returns true if gender preferences are compatible.
  ///
  /// [genderA]/[genderB] – the user's own gender (male/female/non_binary).
  /// [prefA]/[prefB] – the gender they prefer in a flatmate (null = any).
  bool genderPrefMatches({
    required String genderA,
    required String genderB,
    String? prefA,
    String? prefB,
  }) {
    if (!enforceGenderPref) return true;
    if (prefA != null && prefA != 'any' && prefA != genderB) return false;
    if (prefB != null && prefB != 'any' && prefB != genderA) return false;
    return true;
  }

  HardFilters copyWith({
    double? minBudgetOverlapRatio,
    double? maxDistanceKm,
    int? moveInWindowDays,
    bool? enforceGenderPref,
    bool? enforceDealBreakers,
  }) {
    return HardFilters(
      minBudgetOverlapRatio:
          minBudgetOverlapRatio ?? this.minBudgetOverlapRatio,
      maxDistanceKm: maxDistanceKm ?? this.maxDistanceKm,
      moveInWindowDays: moveInWindowDays ?? this.moveInWindowDays,
      enforceGenderPref: enforceGenderPref ?? this.enforceGenderPref,
      enforceDealBreakers: enforceDealBreakers ?? this.enforceDealBreakers,
    );
  }
}
