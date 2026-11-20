/// Validation utilities for user input throughout FlatFit.
class Validators {
  const Validators._();

  static final RegExp _indianPhoneRegex = RegExp(r'^[6-9]\d{9}$');
  static final RegExp _emailRegex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );
  static final RegExp _otpRegex = RegExp(r'^\d{6}$');

  /// Validates standard 10-digit Indian mobile number.
  static String? validateIndianPhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Mobile number is required';
    }
    final sanitized = value.replaceAll(RegExp(r'\D'), '');
    final tenDigit = sanitized.length > 10 ? sanitized.substring(sanitized.length - 10) : sanitized;

    if (tenDigit.length != 10) {
      return 'Enter a 10-digit mobile number';
    }
    if (!_indianPhoneRegex.hasMatch(tenDigit)) {
      return 'Enter a valid Indian mobile number starting with 6-9';
    }
    return null;
  }

  /// Sanitizes phone number to +91XXXXXXXXXX format.
  static String sanitizeIndianPhone(String value) {
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    final tenDigit = digitsOnly.length > 10 ? digitsOnly.substring(digitsOnly.length - 10) : digitsOnly;
    return '+91$tenDigit';
  }

  /// Validates standard 6-digit OTP.
  static String? validateOtp(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'OTP is required';
    }
    if (!_otpRegex.hasMatch(value.trim())) {
      return 'Enter a valid 6-digit OTP';
    }
    return null;
  }

  /// Validates email address format.
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!_emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  /// Validates required text.
  static String? validateRequired(String? value, [String fieldName = 'Field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validates minimum string length.
  static String? validateMinLength(String? value, int minLength, [String fieldName = 'Field']) {
    if (value == null || value.trim().length < minLength) {
      return '$fieldName must be at least $minLength characters';
    }
    return null;
  }

  /// Validates maximum string length.
  static String? validateMaxLength(String? value, int maxLength, [String fieldName = 'Field']) {
    if (value != null && value.trim().length > maxLength) {
      return '$fieldName cannot exceed $maxLength characters';
    }
    return null;
  }

  /// Validates integer within a range.
  static String? validateNumberRange(
    String? value, {
    required int min,
    required int max,
    String fieldName = 'Value',
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    final num = int.tryParse(value.trim());
    if (num == null) {
      return '$fieldName must be a valid number';
    }
    if (num < min || num > max) {
      return '$fieldName must be between $min and $max';
    }
    return null;
  }
}
