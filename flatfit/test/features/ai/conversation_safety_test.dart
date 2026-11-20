import 'package:flutter_test/flutter_test.dart';
import 'package:flatfit/features/ai/domain/conversation_safety.dart';

void main() {
  group('ConversationSafetyEngine Tests', () {
    test('Safe casual message passes without warnings', () {
      const msg = 'Hey, what time are you free on Saturday to see the flat? Let us know!';
      final result = ConversationSafetyEngine.scanMessage(msg);

      expect(result.isSafe, isTrue);
      expect(result.maxRisk, equals(SafetyRiskLevel.safe));
      expect(result.warnings, isEmpty);
      expect(result.shouldBlockMessage, isFalse);
    });

    test('Detects upfront advance payment / token scam', () {
      const msg = 'Please pay Rs 2000 token advance before visit so I can block the room for you.';
      final result = ConversationSafetyEngine.scanMessage(msg);

      expect(result.isSafe, isFalse);
      expect(result.maxRisk, equals(SafetyRiskLevel.critical));
      expect(result.warnings.any((w) => w.type == SafetyWarningType.advancePaymentScam), isTrue);
    });

    test('Detects QR code / UPI PIN phishing trap and blocks message', () {
      const msg = 'Scan this QR code to receive your security deposit refund or enter UPI PIN to accept money';
      final result = ConversationSafetyEngine.scanMessage(msg);

      expect(result.isSafe, isFalse);
      expect(result.maxRisk, equals(SafetyRiskLevel.critical));
      expect(result.warnings.any((w) => w.type == SafetyWarningType.qrCodePhishing), isTrue);
      expect(result.shouldBlockMessage, isTrue);
    });

    test('Detects external contact redirection to Telegram', () {
      const msg = 'I do not use this app often, message me on Telegram @room_agent_mumbai';
      final result = ConversationSafetyEngine.scanMessage(msg);

      expect(result.isSafe, isFalse);
      expect(result.warnings.any((w) => w.type == SafetyWarningType.externalRedirection), isTrue);
    });

    test('Detects known army officer courier scam', () {
      const msg = 'I am an Army officer posted in Delhi. I cannot meet in person, keys will be couriered to you once you pay.';
      final result = ConversationSafetyEngine.scanMessage(msg);

      expect(result.isSafe, isFalse);
      expect(result.warnings.any((w) => w.type == SafetyWarningType.impersonationScam), isTrue);
    });
  });
}
