import 'package:product_browser_app/core/errors/failures.dart';

class FailureToMessage {
  static String messageFor(Failure failure) {
    return switch (failure) {
      InvalidCredentialsFailure() => 'Wrong email or password.',
      EmailAlreadyInUseFailure() => 'An account with this email already exists.',
      WeakPasswordFailure() => 'Password is too weak. Use at least 6 characters.',
      InvalidEmailFailure() => 'Enter a valid email address.',
      UserDisabledFailure() => 'This account has been disabled. Contact support.',
      TooManyRequestsFailure() => 'Too many attempts. Please try again later.',
      ReauthRequiredFailure() => 'Session expired. Please sign in again.',
      _ => 'Something went wrong. Please try again.',
    };
  }
}