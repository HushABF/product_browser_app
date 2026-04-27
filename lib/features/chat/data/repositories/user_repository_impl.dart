import 'package:dartz/dartz.dart';
import 'package:product_browser_app/core/errors/failures.dart';
import 'package:product_browser_app/features/chat/domain/entities/user_entity.dart';
import 'package:product_browser_app/features/chat/domain/repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class UserRepositoryImpl implements UserRepository {
  final SharedPreferences sharedPref;
  static const _key = 'guest_username';

  UserRepositoryImpl({required this.sharedPref});
  @override
  Future<Either<Failure, UserEntity>> getOrGenerateUsername() async {
    try {
      final existingUser = sharedPref.get(_key);
      if (existingUser != null) {
        return Right(UserEntity(userName: existingUser as String));
      }
      final String username = 'User_${const Uuid().v4().substring(0, 8)}';
      await sharedPref.setString(_key, username);
      return Right(UserEntity(userName: username));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
