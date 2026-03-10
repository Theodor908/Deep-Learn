import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDatasource _datasource;

  AuthRepositoryImpl(this._datasource);

  @override
  Stream<AppUser?> get authStateChanges {
    return _datasource.authStateChanges.asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      final profile = await _datasource.getUserProfile(firebaseUser.uid);
      if (profile != null) return profile.toEntity();

      // Profile might not exist yet, return minimal user from FirebaseAuth
      return AppUser(
        uid: firebaseUser.uid,
        username: _extractUsername(firebaseUser.email),
        email: firebaseUser.email ?? '',
        displayName: firebaseUser.displayName ?? 'User',
        photoUrl: firebaseUser.photoURL,
        createdAt: DateTime.now(),
      );
    });
  }

  @override
  Future<AppUser?> get currentUser async {
    final firebaseUser = _datasource.currentFirebaseUser;
    if (firebaseUser == null) return null;
    final profile = await _datasource.getUserProfile(firebaseUser.uid);
    if (profile != null) return profile.toEntity();

    // Fallback
    return AppUser(
      uid: firebaseUser.uid,
      username: _extractUsername(firebaseUser.email),
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName ?? 'User',
      photoUrl: firebaseUser.photoURL,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<AppUser> signInWithEmail(String email, String password) async {
    try {
      final credential = await _datasource.signInWithEmail(email, password);
      final user = credential.user!;
      final profile = await _datasource.getUserProfile(user.uid);
      if (profile != null) return profile.toEntity();

      // Fallback
      return AppUser(
        uid: user.uid,
        username: _extractUsername(user.email),
        email: user.email ?? email,
        displayName: user.displayName ?? _extractUsername(user.email),
        photoUrl: user.photoURL,
        createdAt: DateTime.now(),
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseAuthError(e.code));
    }
  }

  @override
  Future<AppUser> signInWithGoogle() async {
    try {
      final credential = await _datasource.signInWithGoogle();
      final user = credential.user!;

      var profile = await _datasource.getUserProfile(user.uid);
      if (profile == null) {
        // Use part before @ as username
        final username = _extractUsername(user.email);

        profile = UserModel(
          uid: user.uid,
          username: username,
          email: user.email!,
          displayName: user.displayName ?? username,
          photoUrl: user.photoURL,
          createdAt: DateTime.now(),
        );
        await _datasource.saveUserProfile(profile);
      }

      return profile.toEntity();
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseAuthError(e.code));
    }
  }

  @override
  Future<AppUser> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _datasource.createUser(email, password);
      final user = credential.user!;

      final profile = UserModel(
        uid: user.uid,
        username: username,
        email: email,
        displayName: username,
        createdAt: DateTime.now(),
      );


      await _datasource.saveUserProfile(profile);


      try {
        await _datasource.sendEmailVerification();
      } catch (_) {
      }

      return profile.toEntity();
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseAuthError(e.code));
    }
  }

  @override
  Future<void> sendEmailVerification() => _datasource.sendEmailVerification();

  @override
  Future<void> signOut() => _datasource.signOut();

  @override
  Future<void> updatePassword(String newPassword) async {
    try {
      await _datasource.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseAuthError(e.code));
    }
  }

  @override
  Future<void> updateProfile({String? displayName, String? photoUrl}) async {
    final user = _datasource.currentFirebaseUser;
    if (user == null) return;
    final profile = await _datasource.getUserProfile(user.uid);
    if (profile == null) return;

    final updated = profile.copyWith(
      displayName: displayName ?? profile.displayName,
      photoUrl: photoUrl ?? profile.photoUrl,
    );
    await _datasource.saveUserProfile(updated);
  }

  @override
  Future<void> updateFcmToken(String token) async {
    final user = _datasource.currentFirebaseUser;
    if (user == null) return;
    try {
      await _datasource.updateFcmToken(user.uid, token);
    } catch (_) {
    }
  }

  /// e.g. "john.doe@gmail.com" → "john.doe"
  String _extractUsername(String? email) {
    if (email == null || !email.contains('@')) {
      return 'user';
    }
    return email.split('@').first.toLowerCase();
  }

  String _mapFirebaseAuthError(String code) {
    return switch (code) {
      'user-not-found' => 'No account found with this email.',
      'wrong-password' => 'Incorrect password. Please try again.',
      'invalid-credential' => 'Invalid email or password.',
      'email-already-in-use' => 'An account already exists with this email.',
      'weak-password' => 'Password is too weak. Use at least 8 characters.',
      'invalid-email' => 'Please enter a valid email address.',
      'user-disabled' => 'This account has been disabled.',
      'too-many-requests' =>
        'Too many attempts. Please wait a moment and try again.',
      'operation-not-allowed' =>
        'This sign-in method is not enabled. Please contact support.',
      'network-request-failed' =>
        'Network error. Please check your connection.',
      'requires-recent-login' =>
        'Please sign in again to perform this action.',
      'account-exists-with-different-credential' =>
        'An account already exists with a different sign-in method.',
      _ => 'Authentication failed. Please try again.',
    };
  }
}
