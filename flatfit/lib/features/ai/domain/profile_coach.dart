/// Tone options for bio re-writing.
enum BioTone {
  warmFriendly,
  professional,
  chillCasual,
  crispConcise,
}

/// Importance priority of a coaching recommendation.
enum TipPriority {
  critical,
  high,
  medium,
  tip,
}

/// A specific actionable coaching tip for the user's profile.
class ProfileCoachingTip {
  final String title;
  final String description;
  final TipPriority priority;
  final String icon; // Icon identifier or name
  final String actionLabel;

  const ProfileCoachingTip({
    required this.title,
    required this.description,
    required this.priority,
    required this.icon,
    required this.actionLabel,
  });
}

/// Suggested photo order recommendation.
class PhotoOrderAdvice {
  final int slotIndex;
  final String suggestedContentType;
  final String rationale;
  final bool isSatisfied;

  const PhotoOrderAdvice({
    required this.slotIndex,
    required this.suggestedContentType,
    required this.rationale,
    this.isSatisfied = false,
  });
}

/// Complete report returned by the AI Profile Coach.
class ProfileCoachResult {
  final int overallScore; // 0 - 100
  final int bioClarityScore; // 0 - 100
  final int photoQualityScore; // 0 - 100
  final int trustPotentialScore; // 0 - 100
  final List<ProfileCoachingTip> tips;
  final List<PhotoOrderAdvice> photoAdvice;
  final Map<BioTone, String> bioRewrites;

  const ProfileCoachResult({
    required this.overallScore,
    required this.bioClarityScore,
    required this.photoQualityScore,
    required this.trustPotentialScore,
    required this.tips,
    required this.photoAdvice,
    required this.bioRewrites,
  });
}

/// Pure domain engine for Profile Coaching analysis and recommendations.
class ProfileCoachEngine {
  /// Evaluates an existing profile and provides actionable improvements.
  static ProfileCoachResult analyzeProfile({
    required String bio,
    required int photoCount,
    required bool hasVoiceIntro,
    required bool hasKycVerified,
    required bool hasWorkEmailVerified,
    String? occupation,
    String? city,
  }) {
    final tips = <ProfileCoachingTip>[];
    final words = bio.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;

    // 1. Bio analysis
    int bioScore = 20;
    if (words >= 30) bioScore += 30;
    if (words >= 60) bioScore += 25;
    if (bio.toLowerCase().contains('clean') || bio.toLowerCase().contains('habit')) bioScore += 10;
    if (bio.toLowerCase().contains('wfh') || bio.toLowerCase().contains('work')) bioScore += 15;
    if (bioScore > 100) bioScore = 100;

    if (words < 25) {
      tips.add(const ProfileCoachingTip(
        title: 'Expand your bio (under 25 words)',
        description: 'Profiles with 50+ words receive 3.2x more genuine flatmate matches.',
        priority: TipPriority.critical,
        icon: 'text_snippet',
        actionLabel: 'Use AI Bio Rewrite',
      ));
    }

    if (!bio.toLowerCase().contains('sleep') && !bio.toLowerCase().contains('routine')) {
      tips.add(const ProfileCoachingTip(
        title: 'Mention sleep & work schedule',
        description: 'Night owl or early bird? Mentioning your schedule sets clear expectations.',
        priority: TipPriority.high,
        icon: 'bedtime',
        actionLabel: 'Add Routine Details',
      ));
    }

    // 2. Photo analysis
    int photoScore = 15;
    if (photoCount >= 1) photoScore += 25;
    if (photoCount >= 3) photoScore += 35;
    if (photoCount >= 4) photoScore += 25;
    if (photoScore > 100) photoScore = 100;

    if (photoCount < 3) {
      tips.add(const ProfileCoachingTip(
        title: 'Add at least 3 photos',
        description: 'Users with 3+ photos have an 82% higher match acceptance rate.',
        priority: TipPriority.critical,
        icon: 'add_photo_alternate',
        actionLabel: 'Upload Photos',
      ));
    }

    // 3. Trust potential
    int trustScore = 20;
    if (hasKycVerified) {
      trustScore += 40;
    } else {
      tips.add(const ProfileCoachingTip(
        title: 'Complete Government KYC Verification',
        description: 'Get the verified green tick. Verified profiles receive 4.5x more requests.',
        priority: TipPriority.critical,
        icon: 'verified_user',
        actionLabel: 'Verify ID Now',
      ));
    }

    if (hasWorkEmailVerified) {
      trustScore += 25;
    } else {
      tips.add(const ProfileCoachingTip(
        title: 'Verify Work or College Email',
        description: 'Demonstrates authentic affiliation with your company or institution.',
        priority: TipPriority.high,
        icon: 'badge',
        actionLabel: 'Link Work Email',
      ));
    }

    if (hasVoiceIntro) {
      trustScore += 15;
    } else {
      tips.add(const ProfileCoachingTip(
        title: 'Record a 15-second Voice Intro',
        description: 'Voice notes break the ice instantly and convey warmth and authenticity.',
        priority: TipPriority.medium,
        icon: 'mic',
        actionLabel: 'Record Voice Note',
      ));
    }
    if (trustScore > 100) trustScore = 100;

    final overall = ((bioScore * 0.35) + (photoScore * 0.35) + (trustScore * 0.30)).round();

    // Photo slot ordering advice
    final photoAdvice = [
      PhotoOrderAdvice(
        slotIndex: 1,
        suggestedContentType: 'Clear Smiling Solo Portrait',
        rationale: 'Good daylight, looking directly at camera, no sunglasses or group confusion.',
        isSatisfied: photoCount >= 1,
      ),
      PhotoOrderAdvice(
        slotIndex: 2,
        suggestedContentType: 'Full-length Lifestyle Shot',
        rationale: 'Natural setting showcasing your everyday vibe and personal style.',
        isSatisfied: photoCount >= 2,
      ),
      PhotoOrderAdvice(
        slotIndex: 3,
        suggestedContentType: 'Hobby / Passion Activity',
        rationale: 'Cooking, reading, gym, hiking, music—great conversation starter!',
        isSatisfied: photoCount >= 3,
      ),
      PhotoOrderAdvice(
        slotIndex: 4,
        suggestedContentType: 'Cozy Room / Pet / Plant Space',
        rationale: 'Demonstrates cleanliness and appreciation for comfortable living spaces.',
        isSatisfied: photoCount >= 4,
      ),
      PhotoOrderAdvice(
        slotIndex: 5,
        suggestedContentType: 'Social / Outing Photo',
        rationale: 'Shows you enjoy community while respecting personal space.',
        isSatisfied: photoCount >= 5,
      ),
    ];

    // Generate bio rewrites
    final role = occupation ?? 'working professional';
    final loc = city ?? 'Mumbai';

    final bioRewrites = {
      BioTone.warmFriendly:
          'Hey there! I am a $role living in $loc. Passionate about cozy chai evenings, board game nights, and quiet weekend reads. Very respectful of personal space and house boundaries, and always up for an occasional shared dinner or weekend explore. Looking for a neat, friendly home!',
      BioTone.professional:
          'Working as a $role in $loc. Regular work hours (typically 9 AM - 7 PM), non-smoker, and values a tidy, organized living space. Punctual with rent, bills, and common area upkeep. Seeking like-minded flatmates who appreciate cleanliness and quiet weeknights.',
      BioTone.chillCasual:
          'Easy-going $role based in $loc. Into fitness, great music, and exploring street cafes on weekends. Low drama, tidy in shared spaces, and happy to share laughs over pizza. Looking for flatmates who keep things positive and balanced.',
      BioTone.crispConcise:
          '• $role in $loc | Hybrid work\n• Sleep: 11 PM - 7 AM | Non-smoker\n• Clean common areas: Daily / Wash dishes immediately\n• Weekend: Cafes, chill runs, downtime\n• Seeking: Responsible, respectful flatmate',
    };

    return ProfileCoachResult(
      overallScore: overall,
      bioClarityScore: bioScore,
      photoQualityScore: photoScore,
      trustPotentialScore: trustScore,
      tips: tips,
      photoAdvice: photoAdvice,
      bioRewrites: bioRewrites,
    );
  }
}
