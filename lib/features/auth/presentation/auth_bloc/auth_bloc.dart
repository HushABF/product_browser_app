import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_browser_app/core/errors/failures.dart';
import 'package:product_browser_app/features/auth/domain/entities/app_user.dart';
import 'package:product_browser_app/features/auth/domain/usecases/login_use_case.dart';
import 'package:product_browser_app/features/auth/domain/usecases/logout_use_case.dart';
import 'package:product_browser_app/features/auth/domain/usecases/register_use_case.dart';
import 'package:product_browser_app/features/auth/domain/usecases/update_profile_use_case.dart';
import 'package:product_browser_app/features/auth/domain/usecases/watch_auth_state_use_case.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final WatchAuthStateUseCase _watchAuthState;
  final LoginUseCase _login;
  final RegisterUseCase _register;
  final LogoutUseCase _logout;
  final UpdateProfileUseCase _updateProfile;

  StreamSubscription<AppUser?>? _authSubscription;
  bool _isRegistering = false;

  AuthBloc({
    required WatchAuthStateUseCase watchAuthState,
    required LoginUseCase login,
    required RegisterUseCase register,
    required LogoutUseCase logout,
    required UpdateProfileUseCase updateProfile,
  }) : _watchAuthState = watchAuthState,
       _login = login,
       _register = register,
       _logout = logout,
       _updateProfile = updateProfile,
       super(AuthInitial()) {
    on<AuthStarted>(_onAuthStarted);
    on<UserChanged>(_onUserChanged);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<ProfileUpdateRequested>(_onProfileUpdateRequested);
  }

  void _onAuthStarted(AuthStarted event, Emitter<AuthState> emit) {
    _authSubscription = _watchAuthState.call().listen(
      (user) => add(UserChanged(user: user)),
    );
  }

  void _onUserChanged(UserChanged event, Emitter<AuthState> emit) {
    if (_isRegistering) {
      // wait until the stream delivers the user with displayName populated
      if (event.user != null && event.user!.username.isNotEmpty) {
        _isRegistering = false;
        emit(AuthAuthenticated(user: event.user!));
      }
      return; // skip stale emissions
    }

    if (event.user != null) {
      emit(AuthAuthenticated(user: event.user!));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _login.call(
      email: event.email,
      password: event.password,
    );
    result.fold(
      (failure) => emit(AuthFailure(failure: failure)),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    _isRegistering = true;
    emit(AuthLoading());
    final result = await _register.call(
      email: event.email,
      password: event.password,
      username: event.username,
    );
    result.fold((failure) {
      _isRegistering = false; // no stream confirmation coming on failure
      emit(AuthFailure(failure: failure));
    }, (user) => emit(AuthAuthenticated(user: user)));
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _logout.call();
    result.fold((failure) => emit(AuthFailure(failure: failure)), (_) {});
  }

  Future<void> _onProfileUpdateRequested(
    ProfileUpdateRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state is! AuthAuthenticated) return;
    final currentUser = (state as AuthAuthenticated).user;
    emit(AuthUpdating(user: currentUser));
    final result = await _updateProfile.call(
      username: event.username,
      photoUrl: event.photoUrl,
    );
    result.fold((failure) {
      emit(AuthFailure(failure: failure));
      emit(AuthAuthenticated(user: currentUser)); // restore
    }, (updatedUser) => emit(AuthAuthenticated(user: updatedUser)));
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
