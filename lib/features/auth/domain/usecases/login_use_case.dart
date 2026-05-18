import 'package:dartz/dartz.dart';
import 'package:product_browser_app/core/errors/failures.dart';
import 'package:product_browser_app/features/auth/domain/entities/app_user.dart';
import 'package:product_browser_app/features/auth/domain/repo/auth_repository.dart';

class LoginUseCase {
  final AuthRepository authRepository;

  LoginUseCase({required this.authRepository});

  Future<Either<Failure, AppUser>> call({
    required String email,
    required String password,
  }) {
    if (email.isEmpty || password.isEmpty) {
      return Future.value(Left(ValidationFailure()));
    }
    return authRepository.loginWithEmailAndPassword(email, password);
  }
}
