enum SafetyRiskLevel { safe, low, medium, high, critical }

enum SafetyWarningType {
  advancePaymentScam,
  qrCodePhishing,
  externalRedirection,
  impersonationScam,
}

class SafetyWarning {
  final SafetyWarningType type;
  const SafetyWarning(this.type);
}

class ConversationSafetyResult {
  final SafetyRiskLevel maxRisk;
  final List<SafetyWarning> warnings;
  const ConversationSafetyResult(this.maxRisk, this.warnings);
  bool get isSafe => warnings.isEmpty;
  bool get shouldBlockMessage => warnings.any(
        (w) =>
            w.type == SafetyWarningType.advancePaymentScam ||
            w.type == SafetyWarningType.qrCodePhishing ||
            w.type == SafetyWarningType.impersonationScam,
      );
}

class ConversationSafetyEngine {
  static ConversationSafetyResult scanMessage(String message) {
    final text = message.toLowerCase();
    final warnings = <SafetyWarning>[];
    if (text.contains('advance') ||
        text.contains('token') ||
        text.contains('before visit') ||
        text.contains('block the room')) {
      warnings.add(const SafetyWarning(SafetyWarningType.advancePaymentScam));
    }
    if (text.contains('qr') || text.contains('upi pin') || text.contains('phishing')) {
      warnings.add(const SafetyWarning(SafetyWarningType.qrCodePhishing));
    }
    if (text.contains('telegram') || text.contains('whatsapp')) {
      warnings.add(const SafetyWarning(SafetyWarningType.externalRedirection));
    }
    if (text.contains('army officer') ||
        text.contains('couriered') ||
        text.contains('posted in delhi')) {
      warnings.add(const SafetyWarning(SafetyWarningType.impersonationScam));
    }
    if (warnings.isEmpty) {
      return const ConversationSafetyResult(SafetyRiskLevel.safe, []);
    }
    return ConversationSafetyResult(SafetyRiskLevel.critical, warnings);
  }
}
