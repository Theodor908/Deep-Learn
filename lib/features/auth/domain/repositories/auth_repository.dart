import '../entities/app_user.dart';

abstract class AuthRepository {
  Stream<AppUser?> get authStateChanges;
  Future<AppUser?> get currentUser;
  Future<AppUser> signInWithEmail(String email, String password);
  Future<AppUser> signInWithGoogle();
  Future<AppUser> register({
    required String username,
    required String email,
    required String password,
  });
  Future<void> sendEmailVerification();
  Future<void> signOut();
  Future<void> updatePassword(String newPassword);
  Future<void> updateProfile({String? displayName, String? photoUrl});
  Future<void> updateFcmToken(String token);
}
