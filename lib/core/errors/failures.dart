import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class NetworkTimeoutFailure extends Failure {
  const NetworkTimeoutFailure()
    : super('Connection timed out. Please check your internet.');
}

class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure(super.message, {this.statusCode});

  factory ServerFailure.fromStatusCode(int? statusCode, dynamic response) {
    switch (statusCode) {
      case 404:
        return const ServerFailure(
          'Your request was not found, try later.',
          statusCode: 404,
        );

      case 500:
        return const ServerFailure(
          'Something went wrong on our end. Try again later.',
          statusCode: 500,
        );

      case 400:
      case 401:
      case 403:
        return ServerFailure(
          response['error'] ?? 'Unauthorized.',
          statusCode: statusCode,
        );
      default:
        return ServerFailure(
          'An unknown error occurred.',
          statusCode: statusCode,
        );
    }
  }

  @override
  List<Object?> get props => [message, statusCode];
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class FirebasePermissionDeniedFailure extends Failure {
  const FirebasePermissionDeniedFailure() : super('Permission denied.');
}

class FirebaseUnavailableFailure extends Failure {
  const FirebaseUnavailableFailure()
    : super('Service is currently unavailable.');
}

class FirebaseNetworkFailure extends Failure {
  const FirebaseNetworkFailure() : super('No internet connection.');
}

class FirebaseUnknownFailure extends Failure {
  const FirebaseUnknownFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

// Failure classes for Firebase Auth
class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure() : super('Incorrect email or password.');
}

class EmailAlreadyInUseFailure extends Failure {
  const EmailAlreadyInUseFailure()
    : super('An account with this email already exists.');
}

class WeakPasswordFailure extends Failure {
  const WeakPasswordFailure()
    : super('Password must be at least 6 characters.');
}

class InvalidEmailFailure extends Failure {
  const InvalidEmailFailure() : super('Please enter a valid email address.');
}

class UserDisabledFailure extends Failure {
  const UserDisabledFailure()
    : super('This account has been disabled. Contact support.');
}

class TooManyRequestsFailure extends Failure {
  const TooManyRequestsFailure()
    : super('Too many attempts. Please try again later.');
}

class ReauthRequiredFailure extends Failure {
  const ReauthRequiredFailure()
    : super('Please sign in again to update your profile.');
}
