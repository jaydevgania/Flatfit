import 'package:flutter_test/flutter_test.dart';
import 'package:flatfit/features/ai/domain/llm_client.dart';

void main() {
  group('PrivacyFilter Tests', () {
    test('Redacts Indian mobile numbers and UPI IDs', () {
      const prompt = 'Please reach me at 9820112345 or send money to rohan@okhdfcbank';
      final result = PrivacyFilter.sanitize(prompt);

      expect(result.hasRedactions, isTrue);
      expect(result.sanitizedText.contains('9820112345'), isFalse);
      expect(result.sanitizedText.contains('[PHONE_REDACTED]'), isTrue);
      expect(result.sanitizedText.contains('rohan@okhdfcbank'), isFalse);
      expect(result.sanitizedText.contains('[UPI_REDACTED]'), isTrue);
    });

    test('Redacts Aadhaar and PAN numbers', () {
      const prompt = 'My Aadhaar is 2345 6789 0123 and PAN is ABCDE1234F';
      final result = PrivacyFilter.sanitize(prompt);

      expect(result.hasRedactions, isTrue);
      expect(result.sanitizedText.contains('2345 6789 0123'), isFalse);
      expect(result.sanitizedText.contains('[AADHAAR_REDACTED]'), isTrue);
      expect(result.sanitizedText.contains('ABCDE1234F'), isFalse);
      expect(result.sanitizedText.contains('[PAN_REDACTED]'), isTrue);
    });
  });
}
