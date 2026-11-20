class Validators {
  static String? validateIndianPhone(String? phone) {
    if (phone == null || phone.trim().isEmpty) return 'Invalid phone number';
    var digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('91') && digits.length == 12) digits = digits.substring(2);
    if (digits.startsWith('0') && digits.length == 11) digits = digits.substring(1);
    if (digits.length != 10 || !RegExp(r'^[6-9]').hasMatch(digits)) {
      return 'Invalid phone number';
    }
    return null;
  }

  static String sanitizeIndianPhone(String phone) {
    var digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('91') && digits.length == 12) digits = digits.substring(2);
    if (digits.startsWith('0') && digits.length == 11) digits = digits.substring(1);
    return '+91$digits';
  }

  static String? validateOtp(String? otp) {
    if (otp == null || otp.length != 6 || !RegExp(r'^\d{6}$').hasMatch(otp)) {
      return 'Invalid OTP';
    }
    return null;
  }

  static String? validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) return 'Email is required';
    final pattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return pattern.hasMatch(email) ? null : 'Invalid email';
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) return '$fieldName is required';
    return null;
  }
}
