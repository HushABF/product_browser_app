import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:product_browser_app/core/errors/failures.dart';
import 'package:product_browser_app/core/firebase/firebase_exception_handler.dart';
import 'package:product_browser_app/features/auth/data/user_model.dart';
import 'package:product_browser_app/features/auth/domain/entities/app_user.dart';
import 'package:product_browser_app/features/auth/domain/repo/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth;

  AuthRepositoryImpl({required FirebaseAuth auth}) : _auth = auth;

  @override
  Stream<AppUser?> authStateChanges() {
    return _auth.authStateChanges().map(
      (user) => user == null ? null : UserModel.fromFirebase(user),
    );
  }

  @override
  Future<Either<Failure, AppUser>> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(UserModel.fromFirebase(credential.user!));
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseExceptionHandler.handleFirebaseAuthException(e));
    } catch (e) {
      return Left(FirebaseUnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await _auth.signOut();
      return Right(unit);
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseExceptionHandler.handleFirebaseAuthException(e));
    } catch (e) {
      return Left(FirebaseUnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppUser>> registerWithEmailAndPassword(
    String email,
    String password,
    String username,
  ) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user!.updateDisplayName(username);
      await credential.user!.reload();
      return Right(UserModel.fromFirebase(_auth.currentUser!));
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseExceptionHandler.handleFirebaseAuthException(e));
    } catch (e) {
      return Left(FirebaseUnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppUser>> updateProfile({
   required String? username,
   required String? photoUrl,
  }) async {
    try {
      User currentUser = _auth.currentUser!;

      if (username != null) {
        await currentUser.updateDisplayName(username);
      }
      if (photoUrl != null) {
        await currentUser.updatePhotoURL(photoUrl);
      }
      await currentUser.reload();

      return Right(UserModel.fromFirebase(_auth.currentUser!));
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseExceptionHandler.handleFirebaseAuthException(e));
    } catch (e) {
      return Left(FirebaseUnknownFailure(e.toString()));
    }
  }
}
