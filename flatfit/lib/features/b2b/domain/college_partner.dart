/// College partner account entity for universities and higher ed institutions.
class CollegeAccount {
  final String id;
  final String institutionName;
  final String contactEmail;
  final String? contactPhone;
  final String campusCity;
  final int studentCount;
  final int maxStudents;
  final List<String> allowedDomains; // e.g. ['@iitb.ac.in', '@nmims.edu']
  final bool isActive;
  final DateTime createdAt;

  const CollegeAccount({
    required this.id,
    required this.institutionName,
    required this.contactEmail,
    this.contactPhone,
    this.campusCity = 'Mumbai',
    this.studentCount = 0,
    this.maxStudents = 1000,
    this.allowedDomains = const [],
    this.isActive = true,
    required this.createdAt,
  });

  bool isStudentEmail(String email) {
    final lower = email.trim().toLowerCase();
    return allowedDomains.any((d) => lower.endsWith(d.toLowerCase()));
  }
}

/// Seed list of partner universities.
class MockCollegeData {
  static final List<CollegeAccount> accounts = [
    CollegeAccount(
      id: 'col_iitb',
      institutionName: 'IIT Bombay (Powai)',
      contactEmail: 'housing-liaison@iitb.ac.in',
      campusCity: 'Mumbai',
      studentCount: 820,
      maxStudents: 2000,
      allowedDomains: ['@iitb.ac.in'],
      createdAt: DateTime.now().subtract(const Duration(days: 240)),
    ),
    CollegeAccount(
      id: 'col_nmims',
      institutionName: 'NMIMS University (Vile Parle)',
      contactEmail: 'student-affairs@nmims.edu',
      campusCity: 'Mumbai',
      studentCount: 540,
      maxStudents: 1500,
      allowedDomains: ['@nmims.edu'],
      createdAt: DateTime.now().subtract(const Duration(days: 150)),
    ),
  ];
}
