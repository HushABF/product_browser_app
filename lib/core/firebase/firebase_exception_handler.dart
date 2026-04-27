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
}
