// lib/services/auth/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_auth_helper.dart';
import 'user_profile_service.dart';
import 'guest_profile_service.dart';

/* **************
* Main interface
* ************** */

class AuthService {
  final _authHelper = FirebaseAuthHelper();
  final _profileService = UserProfileService();
  final _guestService = GuestProfileService();

  User? get currentUser => _authHelper.currentUser;
  Stream<User?> get authStateChanges => _authHelper.authStateChanges;
  bool get isLoggedIn => _authHelper.isLoggedIn;
  bool get isAnonymous => _authHelper.isAnonymous;
  String get userName => _profileService.getDisplayName(currentUser);

  Future<UserCredential> signInWithEmailAndPassword(String email, String password) =>
      _authHelper.signInWithEmailAndPassword(email, password);

  Future<UserCredential> createUserWithEmailAndPassword(String email, String password) =>
      _authHelper.createUserWithEmailAndPassword(email, password);

  Future<UserCredential> signInWithGoogle() => _authHelper.signInWithGoogle();

  Future<UserCredential> signInAnonymously() async {
    final credential = await _authHelper.signInAnonymously();
    await _profileService.assignRandomPirateName(credential.user);
    await _guestService.initializeGuestProfile(credential.user);
    return credential;
  }

  Future<void> updateGuestScore(int score) =>
      _guestService.updateGuestScore(score);

  Future<void> updateProfile({String? displayName, String? photoURL}) =>
      _profileService.updateProfile(displayName: displayName, photoURL: photoURL);

  Future<UserCredential> linkWithCredential(AuthCredential credential) =>
      _authHelper.linkWithCredential(credential);

  Future<void> sendPasswordResetEmail(String email) =>
      _authHelper.sendPasswordResetEmail(email);

  Future<void> signOut() => _authHelper.signOut();
}