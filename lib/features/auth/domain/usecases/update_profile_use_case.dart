import 'package:dartz/dartz.dart';
import 'package:product_browser_app/core/errors/failures.dart';
import 'package:product_browser_app/features/auth/domain/entities/app_user.dart';
import 'package:product_browser_app/features/auth/domain/repo/auth_repository.dart';

class UpdateProfileUseCase {
  final AuthRepository authRepository;

  UpdateProfileUseCase({required this.authRepository});

  Future<Either<Failure, AppUser>> call({
    required String? username,
    required String? photoUrl,
  }) {
    return authRepository.updateProfile(username: username, photoUrl: photoUrl);
  }
}
