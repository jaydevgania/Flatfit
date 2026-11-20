/// Centralised route-name constants.
///
/// Every route path in the app is defined here so they can be referenced
/// type-safely from [AppRouter] and from navigation call-sites.
class RouteNames {
  const RouteNames._();

  // ── Auth ───────────────────────────────────────────────────────────────
  static const String splash = 'splash';
  static const String welcome = 'welcome';
  static const String phoneAuth = 'phone-auth';
  static const String otpVerification = 'otp-verification';
  static const String consent = 'consent';

  // ── Onboarding ────────────────────────────────────────────────────────
  static const String onboarding = 'onboarding';

  // ── Main / Home ───────────────────────────────────────────────────────
  static const String home = 'home';
  static const String discover = 'discover';
  static const String matches = 'matches';
  static const String chat = 'chat';
  static const String profile = 'profile';

  // ── Listings ──────────────────────────────────────────────────────────
  static const String listings = 'listings';
  static const String listingDetail = 'listing-detail';
  static const String createListing = 'create-listing';

  // ── Living Together ───────────────────────────────────────────────────
  static const String flat = 'flat';
  static const String expenses = 'expenses';
  static const String chores = 'chores';

  // ── Settings ──────────────────────────────────────────────────────────
  static const String settings = 'settings';

  // ── Paths ─────────────────────────────────────────────────────────────
  static const String splashPath = '/';
  static const String welcomePath = '/welcome';
  static const String phoneAuthPath = '/phone-auth';
  static const String otpVerificationPath = '/otp-verification';
  static const String consentPath = '/consent';
  static const String onboardingPath = '/onboarding';
  static const String homePath = '/home';
  static const String discoverPath = '/discover';
  static const String matchesPath = '/matches';
  static const String chatPath = '/chat';
  static const String profilePath = '/profile';
  static const String listingsPath = '/listings';
  static const String listingDetailPath = '/listings/:id';
  static const String createListingPath = '/listings/create';
  static const String flatPath = '/flat';
  static const String expensesPath = '/flat/expenses';
  static const String choresPath = '/flat/chores';
  static const String settingsPath = '/settings';
}
