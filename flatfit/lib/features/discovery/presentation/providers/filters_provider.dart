import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/discovery_filters.dart';

/// StateNotifier managing discovery filter parameters.
class FiltersNotifier extends StateNotifier<DiscoveryFilters> {
  FiltersNotifier() : super(DiscoveryFilters.defaults);

  void updateFilters(DiscoveryFilters newFilters) {
    state = newFilters;
  }

  void setBudgetRange(double min, double max) {
    state = state.copyWith(budgetMin: min, budgetMax: max);
  }

  void toggleLocality(String locality) {
    final list = List<String>.from(state.localities);
    if (list.contains(locality)) {
      list.remove(locality);
    } else {
      list.add(locality);
    }
    state = state.copyWith(localities: list);
  }

  void setRoomType(String roomType) {
    state = state.copyWith(roomType: roomType);
  }

  void setFurnishing(String furnishing) {
    state = state.copyWith(furnishing: furnishing);
  }

  void setGender(String gender) {
    state = state.copyWith(gender: gender);
  }

  void setAgeRange(int min, int max) {
    state = state.copyWith(ageMin: min, ageMax: max);
  }

  void toggleOccupation(String occupation) {
    final list = List<String>.from(state.occupations);
    if (list.contains(occupation)) {
      list.remove(occupation);
    } else {
      list.add(occupation);
    }
    state = state.copyWith(occupations: list);
  }

  void setHousingGoal(String goal) {
    state = state.copyWith(housingGoal: goal);
  }

  void setMinCompatibilityScore(double score) {
    state = state.copyWith(minCompatibilityScore: score);
  }

  void toggleOnlyVerified() {
    state = state.copyWith(onlyVerified: !state.onlyVerified);
  }

  void resetFilters() {
    state = DiscoveryFilters.defaults;
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersNotifier, DiscoveryFilters>((ref) {
  return FiltersNotifier();
});
