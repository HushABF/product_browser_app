import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:product_browser_app/core/errors/failures.dart';
import 'package:product_browser_app/features/auth/domain/entities/app_user.dart';
import 'package:product_browser_app/features/auth/domain/repo/auth_repository.dart';
import 'package:product_browser_app/features/auth/domain/usecases/login_use_case.dart';

class MockAuthRepo extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepo mockAuthRepo;
  late LoginUseCase loginUseCase;

  setUp(() {
    mockAuthRepo = MockAuthRepo();
    loginUseCase = LoginUseCase(authRepository: mockAuthRepo);
  });
  test('return Right(AppUser) on successful login', () async {
    const testUser = AppUser(
      id: '1',
      email: 'ahmedtest@gmail.com',
      username: 'ahmedtest',
    );

    when(
      () => mockAuthRepo.loginWithEmailAndPassword(any(), any()),
    ).thenAnswer((_) async => Right(testUser));

    final result = await loginUseCase.call(
      email: 'ahmedtest@gmail.com',
      password: 'password',
    );

    verify(
      () => mockAuthRepo.loginWithEmailAndPassword(
        'ahmedtest@gmail.com',
        'password',
      ),
    ).called(1);

    expect(result, Right(testUser));
  });

  test('return Left when AuthRepo fails', () async {
    when(
      () => mockAuthRepo.loginWithEmailAndPassword(any(), any()),
    ).thenAnswer((_) async => Left(InvalidCredentialsFailure()));

    final result = await loginUseCase.call(
      email: 'ahmedtest@gmail.com',
      password: 'wrong-password',
    );

    verify(
      () => mockAuthRepo.loginWithEmailAndPassword(
        'ahmedtest@gmail.com',
        'wrong-password',
      ),
    ).called(1);

    expect(result, isA<Left>());
  });

  test('return Left with VaildationError when input is empty', () async {
    final result = await loginUseCase.call(email: '', password: '');

    verifyNever(() => mockAuthRepo.loginWithEmailAndPassword(any(), any()));

    expect(result, Left(ValidationFailure()));
  });
}
