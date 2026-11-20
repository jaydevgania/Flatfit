import 'lifestyle_topics.dart';

/// A single lifestyle question in the FlatFit questionnaire.
class Question {
  final String id;
  final LifestyleTopic topic;
  final String questionText;
  final String? questionTextHi;
  final List<String> options;
  final int displayOrder;

  const Question({
    required this.id,
    required this.topic,
    required this.questionText,
    this.questionTextHi,
    required this.options,
    required this.displayOrder,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      topic: LifestyleTopic.fromValue(json['topic'] as String),
      questionText: json['question_text'] as String,
      questionTextHi: json['question_text_hi'] as String?,
      options: (json['options'] as List<dynamic>).cast<String>(),
      displayOrder: json['display_order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topic': topic.value,
      'question_text': questionText,
      if (questionTextHi != null) 'question_text_hi': questionTextHi,
      'options': options,
      'display_order': displayOrder,
    };
  }
}
