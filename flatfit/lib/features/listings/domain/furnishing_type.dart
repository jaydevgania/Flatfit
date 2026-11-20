import 'package:flutter/material.dart';

/// Level of furnishing for flats in Indian cities.
enum FurnishingType {
  fullyFurnished,
  semiFurnished,
  unfurnished;

  static FurnishingType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'fully_furnished':
      case 'furnished':
        return FurnishingType.fullyFurnished;
      case 'semi_furnished':
      case 'semifurnished':
        return FurnishingType.semiFurnished;
      case 'unfurnished':
      default:
        return FurnishingType.unfurnished;
    }
  }

  String toDbValue() {
    switch (this) {
      case FurnishingType.fullyFurnished:
        return 'fully_furnished';
      case FurnishingType.semiFurnished:
        return 'semi_furnished';
      case FurnishingType.unfurnished:
        return 'unfurnished';
    }
  }

  String get displayName {
    switch (this) {
      case FurnishingType.fullyFurnished:
        return 'Fully Furnished';
      case FurnishingType.semiFurnished:
        return 'Semi-Furnished';
      case FurnishingType.unfurnished:
        return 'Unfurnished';
    }
  }

  String get description {
    switch (this) {
      case FurnishingType.fullyFurnished:
        return 'Bed, mattress, wardrobe, AC, TV, sofa, washing machine, fridge, gas';
      case FurnishingType.semiFurnished:
        return 'Wardrobes, modular kitchen, lights, fans, geyser';
      case FurnishingType.unfurnished:
        return 'Basic fittings only, bring your own furniture';
    }
  }

  IconData get icon {
    switch (this) {
      case FurnishingType.fullyFurnished:
        return Icons.weekend_outlined;
      case FurnishingType.semiFurnished:
        return Icons.kitchen_outlined;
      case FurnishingType.unfurnished:
        return Icons.check_box_outline_blank;
    }
  }
}
