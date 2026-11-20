import 'importance_level.dart';

/// A user's answer to a questionnaire question, including importance.
class UserAnswer {
  final String? id;
  final String userId;
  final String questionId;
  final String answer;
  final ImportanceLevel importance;

  const UserAnswer({
    this.id,
    required this.userId,
    required this.questionId,
    required this.answer,
    this.importance = ImportanceLevel.niceToHave,
  });

  factory UserAnswer.fromJson(Map<String, dynamic> json) {
    return UserAnswer(
      id: json['id'] as String?,
      userId: json['user_id'] as String,
      questionId: json['question_id'] as String,
      answer: json['answer'] as String,
      importance: ImportanceLevel.fromValue(
          json['importance'] as String? ?? 'nice_to_have'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'question_id': questionId,
      'answer': answer,
      'importance': importance.value,
    };
  }

  UserAnswer copyWith({
    String? id,
    String? userId,
    String? questionId,
    String? answer,
    ImportanceLevel? importance,
  }) {
    return UserAnswer(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      questionId: questionId ?? this.questionId,
      answer: answer ?? this.answer,
      importance: importance ?? this.importance,
    );
  }
}
