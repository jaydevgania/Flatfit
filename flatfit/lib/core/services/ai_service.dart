import 'package:flatfit/core/models/result.dart';

class CompatibilityInsight {
  final int overallScore;
  final String summary;
  final List<String> compatibilityPros;
  final List<String> potentialFrictions;
  final List<String> suggestedIcebreakers;

  const CompatibilityInsight({
    required this.overallScore,
    required this.summary,
    required this.compatibilityPros,
    required this.potentialFrictions,
    required this.suggestedIcebreakers,
  });
}

/// Provider-agnostic interface for AI/LLM operations (bio generation, match explanations).
abstract class AiService {
  Future<Result<String>> generateBio({
    required String occupation,
    required List<String> hobbies,
    required String livingStyle,
    required String city,
  });

  Future<Result<CompatibilityInsight>> getCompatibilityInsights({
    required Map<String, dynamic> userAnswersA,
    required Map<String, dynamic> userAnswersB,
  });

  Future<Result<String>> generateFlatAgreementClause({
    required String topic,
    required String customRequirement,
  });
}

class MockAiService implements AiService {
  @override
  Future<Result<String>> generateBio({
    required String occupation,
    required List<String> hobbies,
    required String livingStyle,
    required String city,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final bio = 'Hey! I am a $occupation in $city. In my downtime I love ${hobbies.join(', ')}. '
        'Looking for clean, friendly flatmates who respect personal space and good conversations!';
    return Result.success(bio);
  }

  @override
  Future<Result<CompatibilityInsight>> getCompatibilityInsights({
    required Map<String, dynamic> userAnswersA,
    required Map<String, dynamic> userAnswersB,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return Result.success(CompatibilityInsight(
      overallScore: 88,
      summary: 'You both share similar sleeping schedules, food habits, and guest preferences.',
      compatibilityPros: [
        'Both night owls who study/work late quietly',
        'Vegetarian kitchen preferences align seamlessly',
        'Both prefer weekends for chill home gatherings rather than loud parties',
      ],
      potentialFrictions: [
        'Slightly different standards on daily kitchen cleaning frequency',
      ],
      suggestedIcebreakers: [
        'Ask about their favourite local cafe in the locality',
        'Chat about how they prefer splitting grocery runs',
      ],
    ));
  }

  @override
  Future<Result<String>> generateFlatAgreementClause({
    required String topic,
    required String customRequirement,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Result.success(
      'Clause ($topic): All flatmates agree that $customRequirement shall be observed in good faith.',
    );
  }
}
