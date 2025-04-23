import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_auth_helper.dart';
import 'user_profile_service.dart';
import 'guest_profile_service.dart';

/* **************
 * Main Auth Interface
 * ************** */
class AuthService {
  final _authHelper = FirebaseAuthHelper();
  final _profileService = UserProfileService();
  final _guestService = GuestProfileService();

  /// The currently signed-in user
  User? get currentUser => _authHelper.currentUser;

  /// Stream of auth state changes
  Stream<User?> get authStateChanges => _authHelper.authStateChanges;

  /// Whether the user is logged in
  bool get isLoggedIn => _authHelper.isLoggedIn;

  /// Whether the user is anonymous (guest)
  bool get isAnonymous => _authHelper.isAnonymous;

  /// Whether the user is playing as a guest
  bool get isGuest => currentUser?.isAnonymous ?? false;

  /// The user's display name (pirate name or real name)
  String get userName => _profileService.getDisplayName(currentUser);

  /// Email + Password sign-in
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) =>
      _authHelper.signInWithEmailAndPassword(email, password);

  /// Create user with email + password
  Future<UserCredential> createUserWithEmailAndPassword(String email, String password) =>
      _authHelper.createUserWithEmailAndPassword(email, password);

  /// Sign in using Google
  Future<UserCredential> signInWithGoogle() => _authHelper.signInWithGoogle();

  /// Anonymous sign-in (guest)
  Future<UserCredential> signInAnonymously() async {
    final credential = await _authHelper.signInAnonymously();

    // Assign a random pirate name and initialize guest profile
    await _profileService.assignRandomPirateName(credential.user);
    await _guestService.initializeGuestProfile(credential.user);

    return credential;
  }

  /// Update display name or profile photo
  Future<void> updateProfile({String? displayName, String? photoURL}) =>
      _profileService.updateProfile(displayName: displayName, photoURL: photoURL);

  /// Link an anonymous account with Google or email/password
  Future<UserCredential> linkWithCredential(AuthCredential credential) =>
      _authHelper.linkWithCredential(credential);

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) =>
      _authHelper.sendPasswordResetEmail(email);

  /// Sign out
  Future<void> signOut() => _authHelper.signOut();

  /// Delete the user's account and related Firestore data
  Future<void> deleteAccountAndData() async {
    final user = currentUser;
    if (user == null) return;

    try {
      // Delete player profile if it exists
      final playerDoc = FirebaseFirestore.instance.collection('players').doc(user.uid);
      if ((await playerDoc.get()).exists) {
        await playerDoc.delete();
      }

      // Delete score document if it exists
      final scoreDoc = FirebaseFirestore.instance.collection('scores').doc(user.uid);
      if ((await scoreDoc.get()).exists) {
        await scoreDoc.delete();
      }

      // Delete the Firebase Auth account
      await user.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        throw Exception("Please log in again to confirm account deletion.");
      } else {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }
}
