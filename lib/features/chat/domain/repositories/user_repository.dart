import 'package:product_browser_app/features/chat/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity> getOrGenerateUsername();
}
