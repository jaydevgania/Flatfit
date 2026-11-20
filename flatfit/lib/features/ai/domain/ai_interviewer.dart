/// Topic category for interviewer questions.
enum InterviewTopic {
  dailyRhythm,
  cleanlinessAndDishes,
  guestsAndSocial,
  foodAndKitchen,
  houseRulesAndBills,
}

/// A structured question in the AI Interviewer flow.
class InterviewQuestion {
  final String id;
  final InterviewTopic topic;
  final String promptText;
  final List<String> options;

  const InterviewQuestion({
    required this.id,
    required this.topic,
    required this.promptText,
    required this.options,
  });
}

/// A user's response to an interviewer question.
class InterviewAnswer {
  final String questionId;
  final String selectedOption;
  final String? customNote;

  const InterviewAnswer({
    required this.questionId,
    required this.selectedOption,
    this.customNote,
  });
}

/// Output summary created by the AI interviewer comparing two candidates.
class InterviewSummary {
  final int synergyScore; // 0 - 100
  final List<String> sharedStrengths;
  final List<String> frictionPoints;
  final List<String> suggestedIcebreakers;
  final String summaryVerdict;

  const InterviewSummary({
    required this.synergyScore,
    required this.sharedStrengths,
    required this.frictionPoints,
    required this.suggestedIcebreakers,
    required this.summaryVerdict,
  });
}

/// Pure domain interviewer engine.
class AiInterviewerEngine {
  /// Default set of 5 high-impact questions to quickly assess flatmate compatibility.
  static const List<InterviewQuestion> defaultQuestions = [
    InterviewQuestion(
      id: 'q1_rhythm',
      topic: InterviewTopic.dailyRhythm,
      promptText: 'What is your typical weekday sleep and wake routine?',
      options: [
        'Early Bird (Sleep by 10:30 PM, up by 6:30 AM)',
        'Balanced Rhythm (Sleep around midnight, up 7:30 - 8:30 AM)',
        'Night Owl (Late night work/gaming, up after 9:30 AM)',
        'Variable / Rotational shifts',
      ],
    ),
    InterviewQuestion(
      id: 'q2_cleanliness',
      topic: InterviewTopic.cleanlinessAndDishes,
      promptText: 'How do you handle dirty dishes and common area tidiness?',
      options: [
        'Immediate wash after eating, counter kept spotless',
        'Wash within a few hours or before end of day',
        'Daily maid handles everything once a day',
        'Relaxed—can wait till the weekend',
      ],
    ),
    InterviewQuestion(
      id: 'q3_guests',
      topic: InterviewTopic.guestsAndSocial,
      promptText: 'What is your comfort level with visitors and overnight guests?',
      options: [
        'Rare guests only, prefer a quiet sanctuary',
        'Occasional friends / weekend dinners with advance notice',
        'Partners / close friends welcome anytime',
        'Love having the flat be the social hub / adda',
      ],
    ),
    InterviewQuestion(
      id: 'q4_kitchen',
      topic: InterviewTopic.foodAndKitchen,
      promptText: 'How do you prefer sharing kitchen space and cooking?',
      options: [
        'Pure Veg kitchen only, no non-veg cookware',
        'Separate cookware / shelves for veg & non-veg',
        'Cook together, share groceries & kitchen supplies',
        'Mostly Swiggy/Zomato, minimal cooking needed',
      ],
    ),
    InterviewQuestion(
      id: 'q5_bills',
      topic: InterviewTopic.houseRulesAndBills,
      promptText: 'How do you approach rent punctuality and utility bill splits?',
      options: [
        'Strict auto-pay 1st of month, splitwise updated real-time',
        'Pay by 5th of month, settle utilities monthly',
        'Flexible on dates as long as settled within the week',
        'Prefer an all-inclusive rent structure',
      ],
    ),
  ];

  /// Compares responses from User A and User B to build a constructive, balanced summary.
  static InterviewSummary generateSummary({
    required Map<String, String> userAAnswers,
    required Map<String, String> userBAnswers,
  }) {
    final shared = <String>[];
    final friction = <String>[];
    final icebreakers = <String>[];
    int score = 70; // baseline

    // Evaluate Rhythm
    final rA = userAAnswers['q1_rhythm'] ?? '';
    final rB = userBAnswers['q1_rhythm'] ?? '';
    if (rA == rB && rA.isNotEmpty) {
      shared.add('Identical daily rhythm: Both share the same sleep/wake cycle.');
      score += 8;
    } else if ((rA.contains('Early') && rB.contains('Night')) ||
        (rA.contains('Night') && rB.contains('Early'))) {
      friction.add('Different schedules: One early riser vs. one night owl. Agree on quiet hours (e.g. 11 PM to 7 AM).');
      score -= 10;
      icebreakers.add('Hey, I noticed our sleep schedules differ slightly! How do you usually handle noise in the mornings?');
    } else {
      shared.add('Compatible weekday routines with slight morning flexibility.');
      score += 4;
    }

    // Evaluate Cleanliness
    final cA = userAAnswers['q2_cleanliness'] ?? '';
    final cB = userBAnswers['q2_cleanliness'] ?? '';
    if (cA == cB && cA.isNotEmpty) {
      shared.add('Aligned dish etiquette: Both follow similar cleanliness habits.');
      score += 8;
    } else if (cA.contains('Relaxed') || cB.contains('Relaxed')) {
      friction.add('Dish expectations: One prefers immediate clearing while the other is relaxed. Hiring a daily maid solves this.');
      score -= 6;
      icebreakers.add('Are you open to having a daily maid handle the dishes and kitchen counters?');
    }

    // Evaluate Guests
    final gA = userAAnswers['q3_guests'] ?? '';
    final gB = userBAnswers['q3_guests'] ?? '';
    if (gA == gB && gA.isNotEmpty) {
      shared.add('Shared social vibe: Both want the same balance of quiet time vs. friends over.');
      score += 7;
    } else if ((gA.contains('sanctuary') && gB.contains('adda')) ||
        (gA.contains('adda') && gB.contains('sanctuary'))) {
      friction.add('Social boundaries: One prefers a quiet sanctuary while the other enjoys an active social hub.');
      score -= 12;
      icebreakers.add('I love hosting occasional friends on weekends. Would advance notice in the house group work for you?');
    }

    // Evaluate Kitchen
    final kA = userAAnswers['q4_kitchen'] ?? '';
    final kB = userBAnswers['q4_kitchen'] ?? '';
    if (kA == kB && kA.isNotEmpty) {
      shared.add('Smooth kitchen synergy: Perfectly aligned dietary and kitchen sharing styles.');
      score += 7;
    } else if ((kA.contains('Pure Veg') && kB.contains('together')) ||
        (kB.contains('Pure Veg') && kA.contains('together'))) {
      friction.add('Food boundaries: A pure veg household expectation requires dedicated storage.');
      score -= 10;
    }

    if (icebreakers.isEmpty) {
      icebreakers.add('Hey! Saw our FlatFit interview summary—looks like we have super similar routines. Are you available for a quick chai / call?');
      icebreakers.add('Loved your bio! Which localities in Mumbai are you currently shortlisting?');
    }

    if (score > 98) score = 98;
    if (score < 45) score = 45;

    final verdict = score >= 80
        ? 'High Synergy Match: Your lifestyles complement each other well!'
        : score >= 65
            ? 'Solid Match with minor differences: Easily resolved with simple house norms.'
            : 'Moderate Synergy: Ensure you talk through quiet hours and visitor boundaries.';

    return InterviewSummary(
      synergyScore: score,
      sharedStrengths: shared,
      frictionPoints: friction,
      suggestedIcebreakers: icebreakers,
      summaryVerdict: verdict,
    );
  }
}
