import 'package:dartz/dartz.dart';
import 'package:product_browser_app/core/errors/failures.dart';
import 'package:product_browser_app/features/auth/domain/entities/app_user.dart';

abstract class AuthRepository {
  Stream<AppUser?> userChanges();
  Future<Either<Failure, AppUser>> registerWithEmailAndPassword(
    String email,
    String password,
    String username,
  );
  Future<Either<Failure, AppUser>> loginWithEmailAndPassword(
    String email,
    String password,
  );
  Future<Either<Failure, Unit>> logout();
  Future<Either<Failure, AppUser>> updateProfile({
    required String? username,
    required String? photoUrl,
  });
}
