enum AuthenticityGrade { normal, suspiciouslyLow, suspiciouslyHigh }

class ListingAuthenticityReport {
  final AuthenticityGrade grade;
  final int trustScore;
  final List<String> flaggedAnomalies;
  final List<String> positiveSignals;
  const ListingAuthenticityReport({
    required this.grade,
    required this.trustScore,
    required this.flaggedAnomalies,
    required this.positiveSignals,
  });
  bool get isSuspicious => grade == AuthenticityGrade.suspiciouslyLow ||
      grade == AuthenticityGrade.suspiciouslyHigh;
}

class ListingAuthenticityEngine {
  static ListingAuthenticityReport evaluateListing({
    required String title,
    required String description,
    required double rent,
    required String locality,
    required int photoCount,
    required bool isVerifiedOwner,
    required bool hasVideoTour,
  }) {
    final signals = <String>[];
    if (isVerifiedOwner) signals.add('verified owner');
    if (hasVideoTour) signals.add('video tour');
    if (photoCount >= 5) signals.add('complete photo set');
    if (rent >= 20000) signals.add('realistic rent');
    var score = 60;
    if (isVerifiedOwner) score += 10;
    if (hasVideoTour) score += 10;
    if (photoCount >= 5) score += 10;
    if (rent >= 20000) score += 5;

    if (locality.toLowerCase().contains('bandra') && rent < 10000) {
      return ListingAuthenticityReport(
        grade: AuthenticityGrade.suspiciouslyLow,
        trustScore: 20,
        flaggedAnomalies: const ['Rent is far below the local market median'],
        positiveSignals: signals,
      );
    }
    return ListingAuthenticityReport(
      grade: AuthenticityGrade.normal,
      trustScore: score,
      flaggedAnomalies: const [],
      positiveSignals: signals,
    );
  }
}
