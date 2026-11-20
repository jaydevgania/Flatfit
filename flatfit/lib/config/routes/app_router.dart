import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flatfit/config/routes/route_names.dart';
import 'package:flatfit/features/auth/domain/auth_state.dart';
import 'package:flatfit/features/auth/presentation/providers/auth_provider.dart';
import 'package:flatfit/features/auth/presentation/screens/splash_screen.dart';
import 'package:flatfit/features/auth/presentation/screens/welcome_screen.dart';
import 'package:flatfit/features/auth/presentation/screens/phone_auth_screen.dart';
import 'package:flatfit/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:flatfit/features/auth/presentation/screens/consent_screen.dart';
import 'package:flatfit/core/widgets/bottom_nav_bar.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// Top-level [GoRouter] provider.
///
/// Redirects unauthenticated users to the welcome flow and authenticated
/// users away from the auth screens.
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteNames.splashPath,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggedIn = authState is Authenticated;
      final isOnAuthPage = state.matchedLocation == RouteNames.welcomePath ||
          state.matchedLocation == RouteNames.phoneAuthPath ||
          state.matchedLocation == RouteNames.otpVerificationPath ||
          state.matchedLocation == RouteNames.consentPath;
      final isSplash = state.matchedLocation == RouteNames.splashPath;

      // While loading, stay on splash.
      if (authState is AuthLoading) return null;

      // Logged-in user hitting auth pages → redirect to home.
      if (isLoggedIn && (isOnAuthPage || isSplash)) {
        return RouteNames.homePath;
      }

      // Not logged-in user hitting protected pages → welcome.
      if (!isLoggedIn && !isOnAuthPage && !isSplash) {
        return RouteNames.welcomePath;
      }

      return null; // no redirect
    },
    routes: [
      // ── Auth routes (no shell) ────────────────────────────────────────
      GoRoute(
        path: RouteNames.splashPath,
        name: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.welcomePath,
        name: RouteNames.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: RouteNames.phoneAuthPath,
        name: RouteNames.phoneAuth,
        builder: (context, state) => const PhoneAuthScreen(),
      ),
      GoRoute(
        path: RouteNames.otpVerificationPath,
        name: RouteNames.otpVerification,
        builder: (context, state) {
          final phone = state.extra as String? ?? '';
          return OtpVerificationScreen(phoneNumber: phone);
        },
      ),
      GoRoute(
        path: RouteNames.consentPath,
        name: RouteNames.consent,
        builder: (context, state) => const ConsentScreen(),
      ),

      // ── Main shell with bottom nav ────────────────────────────────────
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => BottomNavShell(child: child),
        routes: [
          GoRoute(
            path: RouteNames.homePath,
            name: RouteNames.home,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: _PlaceholderScreen(title: 'Home'),
            ),
          ),
          GoRoute(
            path: RouteNames.discoverPath,
            name: RouteNames.discover,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: _PlaceholderScreen(title: 'Discover'),
            ),
          ),
          GoRoute(
            path: RouteNames.matchesPath,
            name: RouteNames.matches,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: _PlaceholderScreen(title: 'Matches'),
            ),
          ),
          GoRoute(
            path: RouteNames.chatPath,
            name: RouteNames.chat,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: _PlaceholderScreen(title: 'Chat'),
            ),
          ),
          GoRoute(
            path: RouteNames.profilePath,
            name: RouteNames.profile,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: _PlaceholderScreen(title: 'Profile'),
            ),
          ),
        ],
      ),

      // ── Standalone routes (outside shell) ─────────────────────────────
      GoRoute(
        path: RouteNames.onboardingPath,
        name: RouteNames.onboarding,
        builder: (context, state) =>
            const _PlaceholderScreen(title: 'Onboarding'),
      ),
      GoRoute(
        path: RouteNames.settingsPath,
        name: RouteNames.settings,
        builder: (context, state) =>
            const _PlaceholderScreen(title: 'Settings'),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.error}'),
      ),
    ),
  );
});

/// Temporary placeholder while feature screens are built by other workers.
class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          '$title\n(coming soon)',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
