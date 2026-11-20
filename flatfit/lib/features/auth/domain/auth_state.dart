import 'package:flatfit/features/auth/domain/auth_models.dart';

/// Sealed hierarchy representing current authentication state.
sealed class AuthState {
  const AuthState();
}

/// Initial or background checking state (e.g. app launch splash)
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// In-progress asynchronous state (sending OTP, verifying, signing out)
class AuthLoading extends AuthState {
  final String? message;
  const AuthLoading([this.message]);
}

/// User is authenticated and active session exists
class Authenticated extends AuthState {
  final FlatFitUser user;
  const Authenticated(this.user);
}

/// No active session exists
class Unauthenticated extends AuthState {
  const Unauthenticated();
}

/// An error occurred during an auth action
class AuthError extends AuthState {
  final String message;
  final Exception? exception;

  const AuthError(this.message, [this.exception]);
}
