import 'package:product_browser_app/features/chat/domain/entities/user_entity.dart';
import 'package:product_browser_app/features/chat/domain/repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class UserRepositoryImpl implements UserRepository {
  final SharedPreferences sharedPref;
  static const _key = 'guest_username';

  UserRepositoryImpl({required this.sharedPref});
  @override
  Future<UserEntity> getOrGenerateUsername() async {
    final existingUser = sharedPref.get(_key);
    if (existingUser != null) {
      return UserEntity(userName: existingUser as String);
    }
    final String username = 'User_${const Uuid().v4().substring(0, 8)}';
    await sharedPref.setString(_key, username);
    return UserEntity(userName: username);
  }
}
