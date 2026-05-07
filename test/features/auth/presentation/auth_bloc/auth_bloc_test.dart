import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:product_browser_app/core/errors/failures.dart';
import 'package:product_browser_app/features/auth/domain/entities/app_user.dart';
import 'package:product_browser_app/features/auth/domain/usecases/login_use_case.dart';
import 'package:product_browser_app/features/auth/domain/usecases/logout_use_case.dart';
import 'package:product_browser_app/features/auth/domain/usecases/register_use_case.dart';
import 'package:product_browser_app/features/auth/domain/usecases/update_profile_use_case.dart';
import 'package:product_browser_app/features/auth/domain/usecases/watch_auth_state_use_case.dart';
import 'package:product_browser_app/features/auth/presentation/auth_bloc/auth_bloc.dart';

class MockWatchAuthStateUseCase extends Mock implements WatchAuthStateUseCase {}

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockRegisterUseCase extends Mock implements RegisterUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockUpdateProfileUseCase extends Mock implements UpdateProfileUseCase {}

void main() {
  late MockWatchAuthStateUseCase mockWatchAuthState;
  late MockLoginUseCase mockLogin;
  late MockRegisterUseCase mockRegister;
  late MockLogoutUseCase mockLogout;
  late MockUpdateProfileUseCase mockUpdateProfile;

  late AuthBloc authBloc;

  final AppUser testUser = AppUser(
    id: '1',
    email: 'ahmed@gmail.com',
    username: 'ahmed',
  );

  setUp(() {
    mockWatchAuthState = MockWatchAuthStateUseCase();
    mockLogin = MockLoginUseCase();
    mockRegister = MockRegisterUseCase();
    mockLogout = MockLogoutUseCase();
    mockUpdateProfile = MockUpdateProfileUseCase();

    when(() => mockWatchAuthState.call()).thenAnswer((_) => Stream.value(null));

    authBloc = AuthBloc(
      watchAuthState: mockWatchAuthState,
      login: mockLogin,
      register: mockRegister,
      logout: mockLogout,
      updateProfile: mockUpdateProfile,
    );
  });



  blocTest<AuthBloc, AuthState>(
    'LoginSubmitted emits [AuthLoading, AuthAuthenticated] on success',
    setUp: () {
      when(
        () => mockLogin.call(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => Right(testUser));
    },
    build: () => authBloc,
    act: (bloc) => bloc.add(
      LoginRequested(email: 'ahmed@gmail.com', password: 'password'),
    ),
    expect: () => [isA<AuthLoading>(), isA<AuthAuthenticated>()],
    // this skips the state that comes from AuthStarted inside bloc constructor
    skip: 1,
  );

  blocTest<AuthBloc, AuthState>(
    'LoginSubmitted emits [AuthLoading, AuthError] on wrong credentials',
    setUp: () {
      when(
        () => mockLogin.call(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => Left(InvalidCredentialsFailure()));
    },
    build: () => authBloc,
    act: (bloc) => bloc.add(
      LoginRequested(email: 'ahmed@gmail.com', password: 'wrong-password'),
    ),
    expect: () => [isA<AuthLoading>(), isA<AuthFailure>()],
    // this skips the state that comes from AuthStarted inside bloc constructor
    skip: 1,
  );
}
