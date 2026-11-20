/// Ambassador program category.
enum AmbassadorType {
  college,
  corporate,
}

/// An ambassador profile representing a campus or corporate champion.
class AmbassadorProfile {
  final String id;
  final String name;
  final AmbassadorType type;
  final String institution; // e.g. "IIT Bombay", "NMIMS", "Google BKC"
  final String ambassadorCode;
  final int totalReferrals;
  final double commissionEarned;
  final List<String> perksUnlocked;
  final bool isActive;

  const AmbassadorProfile({
    required this.id,
    required this.name,
    required this.type,
    required this.institution,
    required this.ambassadorCode,
    required this.totalReferrals,
    required this.commissionEarned,
    required this.perksUnlocked,
    this.isActive = true,
  });
}

/// Mock ambassador institutions & leaderboard data.
class MockAmbassadorData {
  static const List<String> targetColleges = [
    'IIT Bombay (Powai)',
    'NMIMS School of Business (Vile Parle)',
    'St. Xavier\'s College (Fort)',
    'SP Jain Institute (Andheri)',
    'HR College of Commerce & Economics (Churchgate)',
    'TISS (Tata Institute of Social Sciences)',
  ];

  static const List<String> targetCorporates = [
    'Google (BKC)',
    'Amazon Web Services (BKC)',
    'McKinsey & Company (Lower Parel)',
    'Deloitte (Hiranandani Powai)',
    'Morgan Stanley (Mindspace Malad)',
    'Tata Consultancy Services (Andheri)',
  ];

  static final List<AmbassadorProfile> leaderboard = [
    const AmbassadorProfile(
      id: 'amb_1',
      name: 'Aditya Kulkarni',
      type: AmbassadorType.college,
      institution: 'IIT Bombay',
      ambassadorCode: 'IITB-ADITYA',
      totalReferrals: 42,
      commissionEarned: 10500.0,
      perksUnlocked: ['Campus Hero Badge', 'Free Annual FlatFit Plus', 'Letter of Recommendation'],
    ),
    const AmbassadorProfile(
      id: 'amb_2',
      name: 'Sneha Kapoor',
      type: AmbassadorType.corporate,
      institution: 'Google BKC',
      ambassadorCode: 'GOOG-SNEHA',
      totalReferrals: 31,
      commissionEarned: 7750.0,
      perksUnlocked: ['Corporate Champion Badge', 'Exclusive Mixer Host Pass'],
    ),
  ];
}
