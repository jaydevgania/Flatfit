import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/llm_client.dart';

/// Wraps any [LlmClient] to sanitize all user/system messages through [PrivacyFilter]
/// before dispatching to external network endpoints.
class PrivacyFilteringLlmClient implements LlmClient {
  final LlmClient _innerClient;

  PrivacyFilteringLlmClient(this._innerClient);

  @override
  LlmProvider get provider => _innerClient.provider;

  @override
  Future<LlmResponse> generateText({
    required List<LlmMessage> messages,
    LlmModelConfig? config,
  }) async {
    int totalRedacted = 0;
    final sanitizedMessages = <LlmMessage>[];

    for (final msg in messages) {
      final filterRes = PrivacyFilter.sanitize(msg.content);
      totalRedacted += filterRes.redactedCount;
      sanitizedMessages.add(LlmMessage(
        role: msg.role,
        content: filterRes.sanitizedText,
      ));
    }

    final rawResponse = await _innerClient.generateText(
      messages: sanitizedMessages,
      config: config,
    );

    return LlmResponse(
      text: rawResponse.text,
      provider: rawResponse.provider,
      promptTokens: rawResponse.promptTokens,
      completionTokens: rawResponse.completionTokens,
      wasSanitized: totalRedacted > 0,
      redactedPiiCount: totalRedacted,
    );
  }

  @override
  Stream<String> streamText({
    required List<LlmMessage> messages,
    LlmModelConfig? config,
  }) {
    final sanitizedMessages = messages.map((m) {
      return LlmMessage(
        role: m.role,
        content: PrivacyFilter.sanitize(m.content).sanitizedText,
      );
    }).toList();

    return _innerClient.streamText(
      messages: sanitizedMessages,
      config: config,
    );
  }
}

/// Mock client providing deterministic responses for offline usage, tests, and mock mode.
class MockLlmClient implements LlmClient {
  final LlmProvider _provider;

  MockLlmClient({LlmProvider provider = LlmProvider.mock}) : _provider = provider;

  @override
  LlmProvider get provider => _provider;

  @override
  Future<LlmResponse> generateText({
    required List<LlmMessage> messages,
    LlmModelConfig? config,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final prompt = messages.last.content.toLowerCase();

    String reply;
    if (prompt.contains('coach') || prompt.contains('bio')) {
      reply = '''
### AI Profile Coach Recommendations:
1. **Bio Polish**: "Tech consultant by day, amateur sourdough baker by weekend. Clean, respectful of quiet hours (11 PM - 7 AM), loves chai and calm Sunday reads."
2. **Photo Arrangement**: Put your clear smiling outdoor portrait in Slot 1. Move the group hangout photo to Slot 3.
3. **Trust Signals**: Connect your LinkedIn or corporate email to boost your profile trust score by +25%.
''';
    } else if (prompt.contains('conflict') || prompt.contains('dispute') || prompt.contains('mediator')) {
      reply = '''
### Kind & De-escalating Suggestion:
"Hey roomie! Hope your day is going well. Just wanted to gently check in about the kitchen sink—could we wash our plates before tonight so we both have room for dinner? Appreciate you!"
''';
    } else if (prompt.contains('interview') || prompt.contains('questions')) {
      reply = '''
### FlatFit Match Compatibility Summary:
- **Shared Rhythms**: Both early risers who value quiet weeknights.
- **Dietary Harmony**: Both comfortable with vegetarian kitchen rules.
- **Potential Friction**: Differs on overnight guest frequency (weekly vs monthly). Suggest discussing guest advance-notice expectations.
''';
    } else {
      reply = 'I am your FlatFit AI assistant, helping you find and live peacefully with your ideal flatmates.';
    }

    return LlmResponse(
      text: reply,
      provider: _provider,
      promptTokens: 120,
      completionTokens: 85,
    );
  }

  @override
  Stream<String> streamText({
    required List<LlmMessage> messages,
    LlmModelConfig? config,
  }) async* {
    final response = await generateText(messages: messages, config: config);
    final words = response.text.split(' ');
    for (final word in words) {
      await Future<void>.delayed(const Duration(milliseconds: 30));
      yield '$word ';
    }
  }
}

/// Google Gemini LLM Client implementation.
class GeminiLlmClient implements LlmClient {
  final String apiKey;
  final String endpoint;

  GeminiLlmClient({
    required this.apiKey,
    this.endpoint = 'https://generativelanguage.googleapis.com/v1beta/models',
  });

  @override
  LlmProvider get provider => LlmProvider.gemini;

  @override
  Future<LlmResponse> generateText({
    required List<LlmMessage> messages,
    LlmModelConfig? config,
  }) async {
    final model = config?.modelName ?? 'gemini-1.5-flash';
    final url = Uri.parse('$endpoint/$model:generateContent?key=$apiKey');

    final contents = messages.map((m) {
      return {
        'role': m.role == LlmRole.user ? 'user' : 'model',
        'parts': [
          {'text': m.content}
        ],
      };
    }).toList();

    try {
      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': contents,
          'generationConfig': {
            'temperature': config?.temperature ?? 0.7,
            'maxOutputTokens': config?.maxTokens ?? 1024,
            'topP': config?.topP ?? 0.95,
          },
        }),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'] as String? ?? '';
        final usage = data['usageMetadata'] as Map<String, dynamic>?;
        return LlmResponse(
          text: text,
          provider: LlmProvider.gemini,
          promptTokens: usage?['promptTokenCount'] as int? ?? 0,
          completionTokens: usage?['candidatesTokenCount'] as int? ?? 0,
        );
      }
    } catch (_) {
      // Fallback gracefully to mock response if offline / unauthorized
    }

    final fallback = MockLlmClient(provider: LlmProvider.gemini);
    return fallback.generateText(messages: messages, config: config);
  }

  @override
  Stream<String> streamText({
    required List<LlmMessage> messages,
    LlmModelConfig? config,
  }) async* {
    final response = await generateText(messages: messages, config: config);
    yield response.text;
  }
}

/// Anthropic Claude LLM Client implementation.
class ClaudeLlmClient implements LlmClient {
  final String apiKey;
  final String endpoint;

  ClaudeLlmClient({
    required this.apiKey,
    this.endpoint = 'https://api.anthropic.com/v1/messages',
  });

  @override
  LlmProvider get provider => LlmProvider.claude;

  @override
  Future<LlmResponse> generateText({
    required List<LlmMessage> messages,
    LlmModelConfig? config,
  }) async {
    final model = config?.modelName ?? 'claude-3-haiku-20240307';
    final userMessages = messages.where((m) => m.role != LlmRole.system).map((m) {
      return {
        'role': m.role == LlmRole.user ? 'user' : 'assistant',
        'content': m.content,
      };
    }).toList();

    final systemMessage = messages.firstWhere(
      (m) => m.role == LlmRole.system,
      orElse: () => const LlmMessage(role: LlmRole.system, content: 'You are FlatFit AI.'),
    );

    try {
      final res = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': apiKey,
          'anthropic-version': '2023-06-01',
        },
        body: jsonEncode({
          'model': model,
          'max_tokens': config?.maxTokens ?? 1024,
          'temperature': config?.temperature ?? 0.7,
          'system': systemMessage.content,
          'messages': userMessages,
        }),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final text = data['content']?[0]?['text'] as String? ?? '';
        final usage = data['usage'] as Map<String, dynamic>?;
        return LlmResponse(
          text: text,
          provider: LlmProvider.claude,
          promptTokens: usage?['input_tokens'] as int? ?? 0,
          completionTokens: usage?['output_tokens'] as int? ?? 0,
        );
      }
    } catch (_) {
      // Fallback gracefully
    }

    final fallback = MockLlmClient(provider: LlmProvider.claude);
    return fallback.generateText(messages: messages, config: config);
  }

  @override
  Stream<String> streamText({
    required List<LlmMessage> messages,
    LlmModelConfig? config,
  }) async* {
    final response = await generateText(messages: messages, config: config);
    yield response.text;
  }
}
