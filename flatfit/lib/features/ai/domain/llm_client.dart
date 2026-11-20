class PrivacySanitizeResult {
  final String sanitizedText;
  final bool hasRedactions;
  const PrivacySanitizeResult(this.sanitizedText, this.hasRedactions);
}

class PrivacyFilter {
  static PrivacySanitizeResult sanitize(String text) {
    var result = text;
    result = result.replaceAll(
      RegExp(r'\b(?:\+91[\s-]?)?[6-9]\d{9}\b'),
      '[PHONE_REDACTED]',
    );
    result = result.replaceAll(
      RegExp(r'\b\d{4}\s?\d{4}\s?\d{4}\b'),
      '[AADHAAR_REDACTED]',
    );
    result = result.replaceAll(
      RegExp(r'\b[A-Z]{5}\d{4}[A-Z]\b'),
      '[PAN_REDACTED]',
    );
    result = result.replaceAll(
      RegExp(r'\b[A-Za-z0-9._-]+@[A-Za-z0-9.-]+\b'),
      '[UPI_REDACTED]',
    );
    return PrivacySanitizeResult(result, result != text);
  }
}
