import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/question_model.dart';
import '../domain/lifestyle_topics.dart';

/// Raw Supabase queries for questionnaire data, with seed questions.
class QuestionnaireDataSource {
  final SupabaseClient _client;

  QuestionnaireDataSource(this._client);

  /// Fetch all questions ordered by display_order.
  Future<List<Map<String, dynamic>>> fetchQuestions() async {
    final response = await _client
        .from('questions')
        .select()
        .order('display_order', ascending: true);
    return List<Map<String, dynamic>>.from(response);
  }

  /// Fetch a user's saved answers.
  Future<List<Map<String, dynamic>>> fetchUserAnswers(String userId) async {
    final response = await _client
        .from('user_answers')
        .select()
        .eq('user_id', userId);
    return List<Map<String, dynamic>>.from(response);
  }

  /// Upsert (insert or update) a single answer.
  Future<Map<String, dynamic>> upsertAnswer(
      Map<String, dynamic> data) async {
    final response = await _client
        .from('user_answers')
        .upsert(
          data,
          onConflict: 'user_id,question_id',
        )
        .select()
        .single();
    return response;
  }

  /// Upsert multiple answers at once.
  Future<void> upsertAnswers(List<Map<String, dynamic>> answers) async {
    await _client.from('user_answers').upsert(
      answers,
      onConflict: 'user_id,question_id',
    );
  }

  /// Delete all answers for a user (to retake the quiz).
  Future<void> deleteAllAnswers(String userId) async {
    await _client.from('user_answers').delete().eq('user_id', userId);
  }

  /// Get current user ID.
  String? get currentUserId => _client.auth.currentUser?.id;

  // ---------------------------------------------------------------------------
  // DEFAULT SEED QUESTIONS
  // Used as fallback when the questions table is empty, and also
  // referenced by questionnaire_repository to provide offline questions.
  // ---------------------------------------------------------------------------

  static final List<Question> defaultQuestions = [
    Question(
      id: 'q1',
      topic: LifestyleTopic.sleep,
      questionText: 'What time do you usually sleep?',
      options: ['Before 10 PM', '10 PM - 12 AM', 'After midnight', 'Irregular'],
      displayOrder: 1,
    ),
    Question(
      id: 'q2',
      topic: LifestyleTopic.sleep,
      questionText: 'What time do you wake up?',
      options: ['Before 7 AM', '7-9 AM', 'After 9 AM', 'Depends on the day'],
      displayOrder: 2,
    ),
    Question(
      id: 'q3',
      topic: LifestyleTopic.cleanliness,
      questionText: 'How clean do you keep common areas?',
      options: [
        'Spotless always',
        'Clean enough',
        "I'll clean on weekends",
        'Pretty relaxed about it',
      ],
      displayOrder: 3,
    ),
    Question(
      id: 'q4',
      topic: LifestyleTopic.cleanliness,
      questionText: 'How do you feel about dishes in the sink?',
      options: [
        'Wash immediately',
        'Within a few hours is fine',
        'End of day',
        "Doesn't bother me",
      ],
      displayOrder: 4,
    ),
    Question(
      id: 'q5',
      topic: LifestyleTopic.food,
      questionText: 'Your food preference?',
      options: ['Pure Vegetarian', 'Eggetarian', 'Non-Veg', 'Jain', 'Vegan'],
      displayOrder: 5,
    ),
    Question(
      id: 'q6',
      topic: LifestyleTopic.food,
      questionText: 'Do you cook at home?',
      options: [
        'Daily',
        'A few times a week',
        'Rarely',
        'Never, zomato is life',
      ],
      displayOrder: 6,
    ),
    Question(
      id: 'q7',
      topic: LifestyleTopic.cooking,
      questionText: 'Kitchen sharing rules?',
      options: [
        'Separate shelves please',
        'Share everything',
        "I don't care",
        'I have a cook',
      ],
      displayOrder: 7,
    ),
    Question(
      id: 'q8',
      topic: LifestyleTopic.smoking,
      questionText: 'Your smoking habit?',
      options: [
        'Non-smoker, prefer no smoking at home',
        'Social smoker',
        'Regular smoker',
        "Don't mind either way",
      ],
      displayOrder: 8,
    ),
    Question(
      id: 'q9',
      topic: LifestyleTopic.drinking,
      questionText: 'Drinking at home?',
      options: [
        'Never',
        'Occasionally on weekends',
        'Frequently',
        "Don't mind",
      ],
      displayOrder: 9,
    ),
    Question(
      id: 'q10',
      topic: LifestyleTopic.guests,
      questionText: 'How often do you have guests over?',
      options: ['Rarely', 'Once a week', 'Often', 'My place is the adda'],
      displayOrder: 10,
    ),
    Question(
      id: 'q11',
      topic: LifestyleTopic.guests,
      questionText: 'Partner staying overnight?',
      options: ['Totally fine', 'Occasionally OK', 'Prefer not', 'Strict no'],
      displayOrder: 11,
    ),
    Question(
      id: 'q12',
      topic: LifestyleTopic.noise,
      questionText: 'Noise levels at home?',
      options: [
        'Library quiet',
        'Keep it reasonable',
        'Music playing is fine',
        'The louder the better',
      ],
      displayOrder: 12,
    ),
    Question(
      id: 'q13',
      topic: LifestyleTopic.pets,
      questionText: 'Pets at home?',
      options: [
        'Love them, have one',
        "Love them, don't have one",
        'OK with it',
        'Prefer no pets',
      ],
      displayOrder: 13,
    ),
    Question(
      id: 'q14',
      topic: LifestyleTopic.wfh,
      questionText: 'Do you work from home?',
      options: [
        'Full time WFH',
        'Hybrid',
        'Office every day',
        'Student schedule',
      ],
      displayOrder: 14,
    ),
    Question(
      id: 'q15',
      topic: LifestyleTopic.bills,
      questionText: 'How should we split bills?',
      options: [
        'Exactly equal',
        'Based on usage',
        'Keep it simple, round off',
        'One person handles, settle monthly',
      ],
      displayOrder: 15,
    ),
    Question(
      id: 'q16',
      topic: LifestyleTopic.rentPunctuality,
      questionText: 'Rent payment style?',
      options: [
        'Always on time, auto-pay',
        'Usually on time',
        'Sometimes late by a few days',
        'Flexible about dates',
      ],
      displayOrder: 16,
    ),
    Question(
      id: 'q17',
      topic: LifestyleTopic.introvertExtrovert,
      questionText: 'Social energy?',
      options: [
        'Introvert, I need my space',
        'Ambivert',
        "Extrovert, let's hang out!",
        'Depends on my mood',
      ],
      displayOrder: 17,
    ),
    Question(
      id: 'q18',
      topic: LifestyleTopic.conflict,
      questionText: "When there's a disagreement?",
      options: [
        'Talk it out immediately',
        'Give it time, then discuss',
        'Message about it',
        'Avoid confrontation',
      ],
      displayOrder: 18,
    ),
    Question(
      id: 'q19',
      topic: LifestyleTopic.parties,
      questionText: 'Parties at home?',
      options: [
        'Never',
        'Rare celebrations OK',
        'Monthly game nights',
        'Every weekend!',
      ],
      displayOrder: 19,
    ),
    Question(
      id: 'q20',
      topic: LifestyleTopic.weekend,
      questionText: 'Typical weekend?',
      options: [
        'Out and about',
        'Mix of home and out',
        'Mostly at home',
        'Varies a lot',
      ],
      displayOrder: 20,
    ),
  ];
}
