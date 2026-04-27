import 'package:dartz/dartz.dart';
import 'package:product_browser_app/core/errors/failures.dart';
import 'package:product_browser_app/features/chat/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<Either<Failure,UserEntity>> getOrGenerateUsername();
}
