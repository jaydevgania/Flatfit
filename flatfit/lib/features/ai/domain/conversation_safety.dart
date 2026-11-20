/// Risk severity level of a message scan.
enum SafetyRiskLevel {
  safe,
  low,
  medium,
  high,
  critical,
}

/// Category of safety warning detected.
enum SafetyWarningType {
  advancePaymentScam,
  externalRedirection,
  impersonationScam,
  qrCodePhishing,
  urgentPressure,
  personalDataHarassment,
}

/// Individual safety warning details.
class SafetyWarning {
  final SafetyWarningType type;
  final SafetyRiskLevel riskLevel;
  final String title;
  final String description;
  final List<String> detectedKeywords;
  final String safetyTip;
  final bool shouldAlertSender;
  final bool shouldAlertReceiver;

  const SafetyWarning({
    required this.type,
    required this.riskLevel,
    required this.title,
    required this.description,
    required this.detectedKeywords,
    required this.safetyTip,
    this.shouldAlertSender = false,
    this.shouldAlertReceiver = true,
  });
}

/// Comprehensive safety scan result for a message.
class SafetyScanResult {
  final String messageText;
  final SafetyRiskLevel maxRisk;
  final List<SafetyWarning> warnings;
  final bool isSafe;
  final bool shouldBlockMessage;

  const SafetyScanResult({
    required this.messageText,
    required this.maxRisk,
    required this.warnings,
    required this.isSafe,
    required this.shouldBlockMessage,
  });

  factory SafetyScanResult.safe(String text) => SafetyScanResult(
        messageText: text,
        maxRisk: SafetyRiskLevel.safe,
        warnings: const [],
        isSafe: true,
        shouldBlockMessage: false,
      );
}

/// Pure domain rules engine for scanning chat conversations and preventing fraud.
class ConversationSafetyEngine {
  // Advance payment patterns
  static final List<RegExp> _advancePaymentPatterns = [
    RegExp(r'\b(?:advance|token|booking\s+amount|gate\s+pass|visiting\s+fee|key\s+deposit)\b', caseSensitive: false),
    RegExp(r'\b(?:pay|send|gpay|phonepe|paytm)\s+(?:me\s+)?(?:rs\.?|inr|₹)?\s*\d{3,5}\s*(?:first|before|advance|token)\b', caseSensitive: false),
    RegExp(r'\b(?:pay\s+before\s+(?:seeing|visit|inspection|viewing))\b', caseSensitive: false),
    RegExp(r'\b(?:refundable\s+token|security\s+deposit\s+online\s+first)\b', caseSensitive: false),
  ];

  // External contact bypass
  static final List<RegExp> _externalRedirectionPatterns = [
    RegExp(r'\b(?:telegram|tg|insta|instagram)\s*(?:id|handle|username)?\s*[:@]\s*[\w_.]+', caseSensitive: false),
    RegExp(r'\b(?:message|chat|talk)\s+(?:on\s+)?(?:whatsapp|telegram|signal)\s+(?:only|directly)\b', caseSensitive: false),
    RegExp(r'\b(?:don\'?t\s+use\s+this\s+app|leave\s+this\s+app|contact\s+me\s+outside)\b', caseSensitive: false),
  ];

  // Scam keywords & Impersonation
  static final List<RegExp> _impersonationPatterns = [
    RegExp(r'\b(?:army\s+officer|defence\s+officer|crpf|military\s+posting|military\s+transfer)\b', caseSensitive: false),
    RegExp(r'\b(?:keys\s+will\s+be\s+couriered|courier\s+the\s+key|parcel\s+keys)\b', caseSensitive: false),
    RegExp(r'\b(?:customs\s+clearance|airport\s+authority|posted\s+in\s+delhi)\b', caseSensitive: false),
    RegExp(r'\b(?:can\'?t\s+meet\s+in\s+person|currently\s+out\s+of\s+country)\b', caseSensitive: false),
  ];

  // QR Code / UPI phishing
  static final List<RegExp> _qrPhishingPatterns = [
    RegExp(r'\b(?:scan\s+(?:this\s+)?qr(?:\s+code)?\s+to\s+receive)\b', caseSensitive: false),
    RegExp(r'\b(?:enter\s+(?:upi\s+)?pin\s+to\s+credit|accept\s+money)\b', caseSensitive: false),
    RegExp(r'\b(?:approve\s+collect\s+request\s+to\s+get\s+refund)\b', caseSensitive: false),
  ];

  // Urgency tactics
  static final List<RegExp> _urgencyPatterns = [
    RegExp(r'\b(?:transfer\s+within\s+\d+\s+(?:minutes|hours)|or\s+i\s+will\s+give\s+it\s+to\s+someone\s+else)\b', caseSensitive: false),
    RegExp(r'\b(?:another\s+person\s+is\s+standing\s+here\s+with\s+cash)\b', caseSensitive: false),
  ];

  /// Scans message content for fraudulent or predatory patterns.
  static SafetyScanResult scanMessage(String text) {
    if (text.trim().isEmpty) {
      return SafetyScanResult.safe(text);
    }

    final warnings = <SafetyWarning>[];
    SafetyRiskLevel highestRisk = SafetyRiskLevel.safe;

    // Check Advance Payment Scams
    final advanceMatches = <String>[];
    for (final pattern in _advancePaymentPatterns) {
      for (final match in pattern.allMatches(text)) {
        advanceMatches.add(match.group(0)!);
      }
    }
    if (advanceMatches.isNotEmpty) {
      highestRisk = SafetyRiskLevel.critical;
      warnings.add(SafetyWarning(
        type: SafetyWarningType.advancePaymentScam,
        riskLevel: SafetyRiskLevel.critical,
        title: 'Advance Payment Scam Alert',
        description: 'The other party asked for upfront money, a gate pass, or a token before seeing the flat.',
        detectedKeywords: advanceMatches,
        safetyTip: 'NEVER pay any token, deposit, or gate fee before visiting the flat in person and verifying identity.',
        shouldAlertSender: true,
        shouldAlertReceiver: true,
      ));
    }

    // Check QR Phishing
    final qrMatches = <String>[];
    for (final pattern in _qrPhishingPatterns) {
      for (final match in pattern.allMatches(text)) {
        qrMatches.add(match.group(0)!);
      }
    }
    if (qrMatches.isNotEmpty) {
      highestRisk = SafetyRiskLevel.critical;
      warnings.add(SafetyWarning(
        type: SafetyWarningType.qrCodePhishing,
        riskLevel: SafetyRiskLevel.critical,
        title: 'UPI Phishing Trap Detected',
        description: 'Mention of scanning a QR code or entering a UPI PIN to "receive" funds.',
        detectedKeywords: qrMatches,
        safetyTip: 'Remember: You NEVER need to enter a UPI PIN or scan a QR code to receive money.',
        shouldAlertReceiver: true,
      ));
    }

    // Check Impersonation / Fake Landlord
    final impMatches = <String>[];
    for (final pattern in _impersonationPatterns) {
      for (final match in pattern.allMatches(text)) {
        impMatches.add(match.group(0)!);
      }
    }
    if (impMatches.isNotEmpty) {
      if (highestRisk.index < SafetyRiskLevel.high.index) {
        highestRisk = SafetyRiskLevel.high;
      }
      warnings.add(SafetyWarning(
        type: SafetyWarningType.impersonationScam,
        riskLevel: SafetyRiskLevel.high,
        title: 'Known Impersonation Script',
        description: 'Patterns often associated with "Army Officer" or "Overseas Landlord" courier scams.',
        detectedKeywords: impMatches,
        safetyTip: 'Authentic flatmates meet locally or over live video. Never accept couriered keys.',
        shouldAlertReceiver: true,
      ));
    }

    // Check External Redirection
    final extMatches = <String>[];
    for (final pattern in _externalRedirectionPatterns) {
      for (final match in pattern.allMatches(text)) {
        extMatches.add(match.group(0)!);
      }
    }
    if (extMatches.isNotEmpty) {
      if (highestRisk.index < SafetyRiskLevel.medium.index) {
        highestRisk = SafetyRiskLevel.medium;
      }
      warnings.add(SafetyWarning(
        type: SafetyWarningType.externalRedirection,
        riskLevel: SafetyRiskLevel.medium,
        title: 'Off-Platform Redirection',
        description: 'Sender is encouraging moving the chat to Telegram or outside FlatFit.',
        detectedKeywords: extMatches,
        safetyTip: 'Stay in FlatFit chat until you have verified each other\'s background and verified profile badge.',
        shouldAlertReceiver: true,
      ));
    }

    // Check Urgency tactics
    final urgMatches = <String>[];
    for (final pattern in _urgencyPatterns) {
      for (final match in pattern.allMatches(text)) {
        urgMatches.add(match.group(0)!);
      }
    }
    if (urgMatches.isNotEmpty) {
      if (highestRisk.index < SafetyRiskLevel.low.index) {
        highestRisk = SafetyRiskLevel.low;
      }
      warnings.add(SafetyWarning(
        type: SafetyWarningType.urgentPressure,
        riskLevel: SafetyRiskLevel.low,
        title: 'Artificial Urgency Detected',
        description: 'High-pressure countdown tactics are commonly used to prevent rational due diligence.',
        detectedKeywords: urgMatches,
        safetyTip: 'Take your time. Do not let artificial urgency rush your financial decisions.',
      ));
    }

    final isBlocked = highestRisk == SafetyRiskLevel.critical && qrMatches.isNotEmpty;

    return SafetyScanResult(
      messageText: text,
      maxRisk: highestRisk,
      warnings: warnings,
      isSafe: warnings.isEmpty,
      shouldBlockMessage: isBlocked,
    );
  }
}
