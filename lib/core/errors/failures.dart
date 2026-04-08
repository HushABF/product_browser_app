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
    if (statusCode == 404) {
      return const ServerFailure(
        'Your request was not found, try later.',
        statusCode: 404,
      );
    } else if (statusCode == 500) {
      return const ServerFailure(
        'There is a problem with the server, try later.',
        statusCode: 500,
      );
    } else if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      return ServerFailure(
        response['error'] ?? 'Unauthorized.',
        statusCode: statusCode,
      );
    } else {
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
