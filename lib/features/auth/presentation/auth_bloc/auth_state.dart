part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthAuthenticated extends AuthState {
  final AppUser user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object> get props => [user];
}

final class AuthUnauthenticated extends AuthState {}

final class AuthUpdating extends AuthState {
  final AppUser user;

  const AuthUpdating({required this.user});

  @override
  List<Object> get props => [user];
}

final class AuthUpdatingFailure extends AuthState {
  final AppUser user;
  final Failure failure;

  const AuthUpdatingFailure({required this.user, required this.failure});

  @override
  List<Object> get props => [user, failure];
}

final class AuthFailure extends AuthState {
  final Failure failure;

  const AuthFailure({required this.failure});

  @override
  List<Object> get props => [failure];
}
