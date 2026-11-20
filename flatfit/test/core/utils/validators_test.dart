import 'package:flutter_test/flutter_test.dart';
import 'package:flatfit/core/utils/validators.dart';

void main() {
  group('Validators Test Suite', () {
    group('validateIndianPhone', () {
      test('rejects empty and null phone numbers', () {
        expect(Validators.validateIndianPhone(null), isNotNull);
        expect(Validators.validateIndianPhone(''), isNotNull);
        expect(Validators.validateIndianPhone('   '), isNotNull);
      });

      test('accepts valid 10-digit Indian phone starting with 6, 7, 8, or 9', () {
        expect(Validators.validateIndianPhone('9876543210'), isNull);
        expect(Validators.validateIndianPhone('8765432109'), isNull);
        expect(Validators.validateIndianPhone('7654321098'), isNull);
        expect(Validators.validateIndianPhone('6543210987'), isNull);
      });

      test('accepts formatted Indian phone with spaces or +91 prefix', () {
        expect(Validators.validateIndianPhone('+91 98765 43210'), isNull);
        expect(Validators.validateIndianPhone('+919876543210'), isNull);
        expect(Validators.validateIndianPhone('98765-43210'), isNull);
      });

      test('rejects numbers starting with invalid digits (0-5)', () {
        expect(Validators.validateIndianPhone('5876543210'), isNotNull);
        expect(Validators.validateIndianPhone('1234567890'), isNotNull);
        expect(Validators.validateIndianPhone('0876543210'), isNotNull);
      });

      test('rejects phone numbers with incorrect digit length', () {
        expect(Validators.validateIndianPhone('98765'), isNotNull);
        expect(Validators.validateIndianPhone('987654321000'), isNotNull);
      });
    });

    group('sanitizeIndianPhone', () {
      test('converts 10-digit number to +91XXXXXXXXXX', () {
        expect(Validators.sanitizeIndianPhone('9876543210'), '+919876543210');
      });

      test('handles numbers already containing +91 and spaces', () {
        expect(Validators.sanitizeIndianPhone('+91 98765 43210'), '+919876543210');
        expect(Validators.sanitizeIndianPhone('09876543210'), '+919876543210');
      });
    });

    group('validateOtp', () {
      test('rejects null, empty, or short OTP', () {
        expect(Validators.validateOtp(null), isNotNull);
        expect(Validators.validateOtp(''), isNotNull);
        expect(Validators.validateOtp('123'), isNotNull);
        expect(Validators.validateOtp('12345'), isNotNull);
      });

      test('rejects OTP containing non-digits', () {
        expect(Validators.validateOtp('12a456'), isNotNull);
        expect(Validators.validateOtp('abcdef'), isNotNull);
      });

      test('accepts valid 6-digit numeric OTP', () {
        expect(Validators.validateOtp('123456'), isNull);
        expect(Validators.validateOtp('000000'), isNull);
        expect(Validators.validateOtp('999999'), isNull);
      });
    });

    group('validateEmail', () {
      test('rejects null or empty emails', () {
        expect(Validators.validateEmail(null), isNotNull);
        expect(Validators.validateEmail(''), isNotNull);
      });

      test('rejects invalid email formats', () {
        expect(Validators.validateEmail('plainaddress'), isNotNull);
        expect(Validators.validateEmail('@missingusername.com'), isNotNull);
        expect(Validators.validateEmail('username@.com'), isNotNull);
      });

      test('accepts standard valid email addresses', () {
        expect(Validators.validateEmail('test@flatfit.in'), isNull);
        expect(Validators.validateEmail('user.name+tag@example.com'), isNull);
      });
    });

    group('validateRequired', () {
      test('rejects null or empty', () {
        expect(Validators.validateRequired(null, 'Name'), 'Name is required');
        expect(Validators.validateRequired('   ', 'Name'), 'Name is required');
      });

      test('accepts valid input', () {
        expect(Validators.validateRequired('Priya', 'Name'), isNull);
      });
    });
  });
}
