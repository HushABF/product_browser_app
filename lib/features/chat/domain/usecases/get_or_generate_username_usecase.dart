import 'package:dartz/dartz.dart';
import 'package:product_browser_app/core/errors/failures.dart';
import 'package:product_browser_app/features/chat/domain/entities/user_entity.dart';
import 'package:product_browser_app/features/chat/domain/repositories/user_repository.dart';

class GetOrGenerateUsernameUsecase {
  final UserRepository userRepository;

  GetOrGenerateUsernameUsecase({required this.userRepository});

  Future<Either<Failure, UserEntity>> call() async {
    return await userRepository.getOrGenerateUsername();
  }
}
