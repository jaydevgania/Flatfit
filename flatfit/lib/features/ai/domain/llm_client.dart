import 'dart:async';

/// Supported LLM providers for FlatFit AI services.
enum LlmProvider {
  gemini,
  claude,
  mock,
}

/// Message role for chat-based LLM interactions.
enum LlmRole {
  system,
  user,
  assistant,
}

/// A single message in an LLM conversation.
class LlmMessage {
  final LlmRole role;
  final String content;

  const LlmMessage({
    required this.role,
    required this.content,
  });

  Map<String, dynamic> toJson() => {
        'role': role.name,
        'content': content,
      };

  factory LlmMessage.fromJson(Map<String, dynamic> json) => LlmMessage(
        role: LlmRole.values.firstWhere(
          (r) => r.name == json['role'],
          orElse: () => LlmRole.user,
        ),
        content: json['content'] as String? ?? '',
      );
}

/// Configuration parameters for LLM text generation.
class LlmModelConfig {
  final double temperature;
  final int maxTokens;
  final double topP;
  final String? modelName;

  const LlmModelConfig({
    this.temperature = 0.7,
    this.maxTokens = 1024,
    this.topP = 0.95,
    this.modelName,
  });
}

/// Result returned from an LLM call.
class LlmResponse {
  final String text;
  final LlmProvider provider;
  final int promptTokens;
  final int completionTokens;
  final bool wasSanitized;
  final int redactedPiiCount;

  const LlmResponse({
    required this.text,
    required this.provider,
    this.promptTokens = 0,
    this.completionTokens = 0,
    this.wasSanitized = false,
    this.redactedPiiCount = 0,
  });
}

/// Strict privacy filter to protect user PII before sending prompts to external LLMs.
///
/// Strips Indian phone numbers, Aadhaar, PAN, UPI IDs, bank details, and passwords.
class PrivacyFilter {
  static final RegExp _phoneRegex = RegExp(
    r'(?:\+91[\-\s]?)?[6-9]\d{9}',
  );

  static final RegExp _aadhaarRegex = RegExp(
    r'\b[2-9]{1}\d{3}[\s\-]?[0-9]{4}[\s\-]?[0-9]{4}\b',
  );

  static final RegExp _panRegex = RegExp(
    r'\b[A-Z]{5}[0-9]{4}[A-Z]{1}\b',
    caseSensitive: false,
  );

  static final RegExp _upiRegex = RegExp(
    r'[\w\.\-]+@(okhdfcbank|okaxis|oksbi|okicici|paytm|ybl|upi|ibl|axl|barodampay)',
    caseSensitive: false,
  );

  static final RegExp _emailRegex = RegExp(
    r'[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+',
  );

  static final RegExp _otpPasswordRegex = RegExp(
    r'\b(?:otp|pass(?:word)?|pin)\s*[:=]\s*([a-zA-Z0-9!@#$%^&*]{4,12})\b',
    caseSensitive: false,
  );

  static final RegExp _bankIfscRegex = RegExp(
    r'\b[A-Z]{4}0[A-Z0-9]{6}\b',
    caseSensitive: false,
  );

  /// Sanitize text by redacting sensitive PII patterns.
  static PrivacyFilterResult sanitize(String input) {
    var text = input;
    var count = 0;
    final redactedItems = <String>[];

    // Mask Aadhaar
    if (_aadhaarRegex.hasMatch(text)) {
      count += _aadhaarRegex.allMatches(text).length;
      redactedItems.add('Aadhaar Number');
      text = text.replaceAll(_aadhaarRegex, '[AADHAAR_REDACTED]');
    }

    // Mask PAN
    if (_panRegex.hasMatch(text)) {
      count += _panRegex.allMatches(text).length;
      redactedItems.add('PAN Card');
      text = text.replaceAll(_panRegex, '[PAN_REDACTED]');
    }

    // Mask Phone
    if (_phoneRegex.hasMatch(text)) {
      count += _phoneRegex.allMatches(text).length;
      redactedItems.add('Phone Number');
      text = text.replaceAll(_phoneRegex, '[PHONE_REDACTED]');
    }

    // Mask UPI ID
    if (_upiRegex.hasMatch(text)) {
      count += _upiRegex.allMatches(text).length;
      redactedItems.add('UPI ID');
      text = text.replaceAll(_upiRegex, '[UPI_REDACTED]');
    }

    // Mask IFSC
    if (_bankIfscRegex.hasMatch(text)) {
      count += _bankIfscRegex.allMatches(text).length;
      redactedItems.add('Bank IFSC');
      text = text.replaceAll(_bankIfscRegex, '[IFSC_REDACTED]');
    }

    // Mask Email
    if (_emailRegex.hasMatch(text)) {
      count += _emailRegex.allMatches(text).length;
      redactedItems.add('Email Address');
      text = text.replaceAll(_emailRegex, '[EMAIL_REDACTED]');
    }

    // Mask OTP / Passwords
    if (_otpPasswordRegex.hasMatch(text)) {
      count += _otpPasswordRegex.allMatches(text).length;
      redactedItems.add('Credentials/OTP');
      text = text.replaceAllMapped(_otpPasswordRegex, (match) {
        return '${match.group(0)!.split(RegExp(r'[:=]'))[0]}: [CREDENTIAL_REDACTED]';
      });
    }

    return PrivacyFilterResult(
      sanitizedText: text,
      redactedCount: count,
      redactedCategories: redactedItems,
    );
  }
}

/// Output of a privacy filter run.
class PrivacyFilterResult {
  final String sanitizedText;
  final int redactedCount;
  final List<String> redactedCategories;

  const PrivacyFilterResult({
    required this.sanitizedText,
    required this.redactedCount,
    required this.redactedCategories,
  });

  bool get hasRedactions => redactedCount > 0;
}

/// Provider-agnostic LLM client contract.
abstract class LlmClient {
  LlmProvider get provider;

  /// Send prompt messages and return a single aggregated response.
  Future<LlmResponse> generateText({
    required List<LlmMessage> messages,
    LlmModelConfig? config,
  });

  /// Stream tokens as they are generated.
  Stream<String> streamText({
    required List<LlmMessage> messages,
    LlmModelConfig? config,
  });
}
