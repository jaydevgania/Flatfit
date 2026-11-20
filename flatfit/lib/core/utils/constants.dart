/// Global app constants for FlatFit.
class AppConstants {
  const AppConstants._();

  static const String appName = 'FlatFit';
  static const String appTagline = 'Compatibility-first flatmate matching for India';

  // Major Indian target metro cities
  static const List<String> supportedCities = [
    'Bengaluru',
    'Mumbai',
    'Delhi NCR',
    'Hyderabad',
    'Pune',
    'Chennai',
    'Kolkata',
  ];

  // OTP Configuration
  static const int otpLength = 6;
  static const int otpResendCooldownSeconds = 30;

  // Question & Match Constants
  static const int minCompatibilityScore = 0;
  static const int maxCompatibilityScore = 100;
  static const int highCompatibilityThreshold = 75;
  static const int moderateCompatibilityThreshold = 50;

  // Pagination default sizes
  static const int defaultPageSize = 20;

  // Media upload limits
  static const int maxProfilePhotos = 6;
  static const int maxVoiceIntroDurationSeconds = 60;
  static const int maxListingPhotos = 12;

  // External URLs
  static const String privacyPolicyUrl = 'https://flatfit.in/privacy';
  static const String termsOfServiceUrl = 'https://flatfit.in/terms';
  static const String communityGuidelinesUrl = 'https://flatfit.in/community-guidelines';
  static const String supportEmail = 'support@flatfit.in';
}
