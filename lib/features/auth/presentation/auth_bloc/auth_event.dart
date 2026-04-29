part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

final class AuthStarted extends AuthEvent {}

final class UserChanged extends AuthEvent {
  final AppUser? user;

  const UserChanged({this.user});

  @override
  List<Object?> get props => [user];
}

final class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

final class RegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String username;

  const RegisterRequested({
    required this.email,
    required this.password,
    required this.username,
  });

  @override
  List<Object?> get props => [email, password, username];
}

final class LogoutRequested extends AuthEvent {}

final class ProfileUpdateRequested extends AuthEvent {
  final String? username;
  final String? photoUrl;

  const ProfileUpdateRequested({
    required this.username,
    required this.photoUrl,
  });

  @override
  List<Object?> get props => [username, photoUrl];
}
