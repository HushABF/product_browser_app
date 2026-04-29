import 'package:product_browser_app/features/auth/domain/entities/app_user.dart';
import 'package:product_browser_app/features/auth/domain/repo/auth_repository.dart';

class WatchAuthStateUseCase {
  final AuthRepository authRepository;

  WatchAuthStateUseCase({required this.authRepository});

  Stream<AppUser?> call() {
    return authRepository.authStateChanges();
  }
}
