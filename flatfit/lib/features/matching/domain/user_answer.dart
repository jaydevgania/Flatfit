import 'package:flutter/foundation.dart';

/// Importance tier of a questionnaire answer.
enum AnswerImportance {
  dealBreaker('deal_breaker', 3.0),
  important('important', 2.0),
  niceToHave('nice_to_have', 1.0);

  final String value;
  final double weight;
  const AnswerImportance(this.value, this.weight);

  static AnswerImportance fromString(String val) {
    switch (val.toLowerCase()) {
      case 'deal_breaker':
      case 'dealbreaker':
        return AnswerImportance.dealBreaker;
      case 'important':
        return AnswerImportance.important;
      case 'nice_to_have':
      case 'nicetohave':
      default:
        return AnswerImportance.niceToHave;
    }
  }
}

/// Standardized questionnaire topics.
enum QuestionTopic {
  sleep,
  cleanliness,
  food,
  cooking,
  smoking,
  drinking,
  guests,
  noise,
  pets,
  wfh,
  bills,
  rentPunctuality,
  introvertExtrovert,
  conflict;

  static QuestionTopic fromString(String val) {
    final normalized = val.toLowerCase().replaceAll('-', '_');
    for (final t in QuestionTopic.values) {
      if (t.name.toLowerCase() == normalized ||
          _snakeCase(t.name) == normalized) {
        return t;
      }
    }
    return QuestionTopic.cleanliness;
  }

  static String _snakeCase(String text) {
    return text.replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '_${match.group(0)!.toLowerCase()}',
    );
  }
}

/// A user's answer to a single compatibility question.
@immutable
class UserAnswer {
  final String id;
  final String userId;
  final String questionId;
  final String topic;
  final String answer;
  final AnswerImportance importance;
  final int? optionIndex; // 0-based index if ordinal scale

  const UserAnswer({
    this.id = '',
    required this.userId,
    required this.questionId,
    required this.topic,
    required this.answer,
    this.importance = AnswerImportance.niceToHave,
    this.optionIndex,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'question_id': questionId,
    'topic': topic,
    'answer': answer,
    'importance': importance.value,
    'option_index': optionIndex,
  };

  factory UserAnswer.fromJson(Map<String, dynamic> json) {
    return UserAnswer(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      questionId: json['question_id'] as String? ?? '',
      topic: json['topic'] as String? ?? '',
      answer: json['answer'] as String? ?? '',
      importance: AnswerImportance.fromString(
        json['importance'] as String? ?? 'nice_to_have',
      ),
      optionIndex: json['option_index'] as int?,
    );
  }
}
