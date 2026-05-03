import 'package:firebase_auth/firebase_auth.dart';
import 'package:product_browser_app/features/auth/domain/entities/app_user.dart';

class UserModel extends AppUser {
  const UserModel({
    required super.id,
    required super.email,
    required super.username,
    super.photoUrl,
  });

  factory UserModel.fromFirebase(User firebaseUser) => UserModel(
    id: firebaseUser.uid,
    email: firebaseUser.email ?? '',
    username: firebaseUser.displayName ?? '',
    photoUrl: firebaseUser.photoURL,
  );
}
