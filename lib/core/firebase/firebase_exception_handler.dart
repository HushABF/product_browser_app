import 'package:firebase_core/firebase_core.dart';
import 'package:product_browser_app/core/errors/failures.dart';

class FirebaseExceptionHandler {
  static Failure handleFirebaseException(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
      case 'unauthenticated':
        return const FirebasePermissionDeniedFailure();

      case 'unavailable':
      case 'service-unavailable':
      case 'internal-error':
        return const FirebaseUnavailableFailure();

      case 'network-request-failed':
      case 'deadline-exceeded':
        return const FirebaseNetworkFailure();

      default:
        return FirebaseUnknownFailure(
          e.message ?? 'An unexpected Firebase error occurred.',
        );
    }
  }

  static Failure handleFirebaseAuthException(FirebaseException e) {
    return switch (e.code) {
      'email-already-in-use' => const EmailAlreadyInUseFailure(),
      'weak-password' => const WeakPasswordFailure(),
      'invalid-email' => const InvalidEmailFailure(),
      'invalid-credential' => const InvalidCredentialsFailure(),
      'user-disabled' => const UserDisabledFailure(),
      'too-many-requests' => const TooManyRequestsFailure(),
      'requires-recent-login' => const ReauthRequiredFailure(),
      'network-request-failed' => const FirebaseNetworkFailure(),
      _ => FirebaseUnknownFailure(e.message ?? 'Unknown auth error.'),
    };
  }
}
