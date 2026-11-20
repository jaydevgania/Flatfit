import 'package:flutter/material.dart';

/// Convenient extensions for BuildContext and standard Dart types.
extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;

  bool get isDarkMode => theme.brightness == Brightness.dark;

  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? colorScheme.error : null,
      ),
    );
  }
}

extension StringExtensions on String {
  /// Capitalizes first letter of the string.
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalizes each word in a string.
  String titleCase() {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize()).join(' ');
  }

  /// Truncates string with ellipsis.
  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }
}

extension IntExtensions on int {
  /// Returns a SizedBox with height = this.
  Widget get verticalSpace => SizedBox(height: toDouble());

  /// Returns a SizedBox with width = this.
  Widget get horizontalSpace => SizedBox(width: toDouble());
}

extension DoubleExtensions on double {
  Widget get verticalSpace => SizedBox(height: this);
  Widget get horizontalSpace => SizedBox(width: this);
}
