/// Category of house living dispute.
enum DisputeCategory {
  dirtyDishes,
  unpaidBills,
  overnightGuests,
  noiseAndSleep,
  messyCommonAreas,
  acAndElectricity,
  fridgeAndGroceries,
  generalOther,
}

/// Tone preference for the mediated message rewrite.
enum MediatorTone {
  gentleFriendly,
  diplomaticBalanced,
  clearDirect,
}

/// Output of a conflict mediation request.
class MediatedMessageResult {
  final DisputeCategory category;
  final String rawInput;
  final Map<MediatorTone, String> rewrites;
  final String suggestedCompromiseRule;
  final List<String> deEscalationTips;

  const MediatedMessageResult({
    required this.category,
    required this.rawInput,
    required this.rewrites,
    required this.suggestedCompromiseRule,
    required this.deEscalationTips,
  });
}

/// Domain engine for de-escalating roommate disputes into constructive communication.
class ConflictMediatorEngine {
  /// Detects the likely dispute category from input text.
  static DisputeCategory detectCategory(String text) {
    final lower = text.toLowerCase();
    if (lower.contains('dish') || lower.contains('sink') || lower.contains('plate') || lower.contains('bartan')) {
      return DisputeCategory.dirtyDishes;
    }
    if (lower.contains('bill') || lower.contains('wifi') || lower.contains('rent') || lower.contains('pay') || lower.contains('money')) {
      return DisputeCategory.unpaidBills;
    }
    if (lower.contains('guest') || lower.contains('partner') || lower.contains('boyfriend') || lower.contains('girlfriend') || lower.contains('stay')) {
      return DisputeCategory.overnightGuests;
    }
    if (lower.contains('noise') || lower.contains('loud') || lower.contains('music') || lower.contains('sleep') || lower.contains('wake')) {
      return DisputeCategory.noiseAndSleep;
    }
    if (lower.contains('ac') || lower.contains('temperature') || lower.contains('electricity') || lower.contains('power')) {
      return DisputeCategory.acAndElectricity;
    }
    if (lower.contains('fridge') || lower.contains('milk') || lower.contains('food') || lower.contains('ate') || lower.contains('grocery')) {
      return DisputeCategory.fridgeAndGroceries;
    }
    if (lower.contains('mess') || lower.contains('hall') || lower.contains('living room') || lower.contains('clean')) {
      return DisputeCategory.messyCommonAreas;
    }
    return DisputeCategory.generalOther;
  }

  /// Transforms raw frustrated text into constructive, de-escalating communication.
  static MediatedMessageResult mediateMessage(String rawInput) {
    final category = detectCategory(rawInput);

    Map<MediatorTone, String> rewrites;
    String compromiseRule;
    List<String> tips;

    switch (category) {
      case DisputeCategory.dirtyDishes:
        rewrites = {
          MediatorTone.gentleFriendly:
              'Hey roomie! Hope your day is going well. Just wanted to gently check in about the dishes in the sink—could we wash them before dinner tonight so we both have counter space? Appreciate it lots!',
          MediatorTone.diplomaticBalanced:
              'Hey! Just a quick heads-up on the kitchen: the sink is currently quite full. Could you please take care of your dishes today? It helps keep pests away and keeps cooking smooth for both of us.',
          MediatorTone.clearDirect:
              'Hi, please make sure your dishes in the sink are cleared by tonight. Having unwashed plates left out makes it difficult to use the kitchen.',
        };
        compromiseRule = 'Proposed House Rule: The "Within 3 Hours" Dish Policy, or splitting ₹1,200/mo for a dedicated maid visit.';
        tips = [
          'Focus on the shared goal (clean kitchen to make dinner) rather than past mistakes.',
          'Avoid words like "always" or "never".',
        ];
        break;

      case DisputeCategory.unpaidBills:
        rewrites = {
          MediatorTone.gentleFriendly:
              'Hey! Just sending a soft reminder for this month\'s utility split (₹...). Whenever you get a free moment today, could you UPI it over? Thanks a ton!',
          MediatorTone.diplomaticBalanced:
              'Hey, hope work is going smoothly! The WiFi / electricity bill is due tomorrow. Could you please settle your share so we don\'t incur late fees or disconnection? UPI link is in our group.',
          MediatorTone.clearDirect:
              'Hi, the bill due date is approaching. Please transfer your share of the bill by this evening so I can complete the landlord / utility payment.',
        };
        compromiseRule = 'Proposed House Rule: Set a recurring Splitwise/FlatFit reminder on the 1st of every month.';
        tips = [
          'Attach the exact bill screenshot and UPI QR to remove friction.',
          'Acknowledge that people get busy at month-end.',
        ];
        break;

      case DisputeCategory.overnightGuests:
        rewrites = {
          MediatorTone.gentleFriendly:
              'Hey! Love having friends around, but wanted to check if we can give each other a quick heads-up on the group whenever guests are staying the night? Just helps plan around privacy and morning bathroom queues!',
          MediatorTone.diplomaticBalanced:
              'Hey, hope you\'re having a good week. Can we align on an advance notice rule for overnight visitors? A simple ping 12 hours before helps ensure everyone feels comfortable at home.',
          MediatorTone.clearDirect:
              'Hi, as agreed in our house guidelines, please give advance notice before having guests stay overnight, and let\'s agree on a reasonable limit per week.',
        };
        compromiseRule = 'Proposed House Rule: Ping house chat 12 hours prior to overnight guests; max 2 consecutive nights per week unless agreed.';
        tips = [
          'Emphasize shared bathroom access and privacy needs.',
          'Propose a fair reciprocal policy so it applies equally to all flatmates.',
        ];
        break;

      case DisputeCategory.noiseAndSleep:
        rewrites = {
          MediatorTone.gentleFriendly:
              'Hey! Super sorry to bother, but I have an early morning tomorrow and could hear things from the hall. Could we turn down the volume or switch to headphones? Thank you so much!',
          MediatorTone.diplomaticBalanced:
              'Hey roomie, could we please observe quiet hours from 11 PM tonight? I have a big work presentation in the morning and need to get some rest.',
          MediatorTone.clearDirect:
              'Hi, the sound is carrying into my room. Please keep the volume down and use headphones after 11 PM as per our house quiet hours.',
        };
        compromiseRule = 'Proposed House Rule: Quiet hours 11:00 PM – 7:30 AM on weekdays; headphones mandatory in common spaces after midnight.';
        tips = [
          'Mention your specific need (early meeting, sick, tired) to elicit empathy.',
          'Speak in the moment rather than letting frustration stew for days.',
        ];
        break;

      case DisputeCategory.acAndElectricity:
        rewrites = {
          MediatorTone.gentleFriendly:
              'Hey! Noticed the electricity bill was a bit high last cycle. Would you be open to keeping the AC at 24°C with a timer so we keep bills comfortable for both of us?',
          MediatorTone.diplomaticBalanced:
              'Hey, with summer electricity rates rising, let\'s agree on keeping the hall AC off when rooms are empty and using 24°C as our default setting.',
          MediatorTone.clearDirect:
              'Hi, please remember to turn off the AC and geyser before leaving the flat so our utility bill stays within our planned budget.',
        };
        compromiseRule = 'Proposed House Rule: 24°C eco-mode default; 2-hour sleep timer at night; auto-switch off when leaving the house.';
        tips = [
          'Frame AC conservation as a mutual money saver.',
        ];
        break;

      case DisputeCategory.fridgeAndGroceries:
        rewrites = {
          MediatorTone.gentleFriendly:
              'Hey! Just noticed some groceries in the fridge were used up. If you need anything from my shelf, just let me know beforehand and we can order replacements together on Blinkit!',
          MediatorTone.diplomaticBalanced:
              'Hey, can we designate specific shelves in the fridge for personal items vs. shared items (like milk, eggs, bread)? It\'ll prevent accidental mix-ups.',
          MediatorTone.clearDirect:
              'Hi, please do not use items labeled with my name in the fridge. If you\'d like to split groceries together, let\'s set up a shared cart.',
        };
        compromiseRule = 'Proposed House Rule: Top 2 shelves personal; door and crisper shared with automatic weekly Blinkit restock.';
        tips = [
          'Separate items physically using color-coded containers or shelf labels.',
        ];
        break;

      case DisputeCategory.messyCommonAreas:
      case DisputeCategory.generalOther:
        rewrites = {
          MediatorTone.gentleFriendly:
              'Hey roomie! Hope all is good with you. Could we do a quick 10-minute tidy up of the living room today? It feels so much nicer when the common area is clear!',
          MediatorTone.diplomaticBalanced:
              'Hey! Let\'s make sure personal bags, shoes, and items are kept in our bedrooms so the living room stays open and welcoming for both of us.',
          MediatorTone.clearDirect:
              'Hi, please clear your personal belongings from the living room sofa and dining table by this evening.',
        };
        compromiseRule = 'Proposed House Rule: Common areas kept free of personal belongings overnight; 15-minute Sunday group tidy-up.';
        tips = [
          'Frame it as enjoying the living space together rather than criticizing habits.',
        ];
        break;
    }

    return MediatedMessageResult(
      category: category,
      rawInput: rawInput,
      rewrites: rewrites,
      suggestedCompromiseRule: compromiseRule,
      deEscalationTips: tips,
    );
  }
}
