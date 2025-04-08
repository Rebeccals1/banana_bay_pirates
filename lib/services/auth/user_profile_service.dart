// lib/services/auth/user_profile_service.dart
import 'package:firebase_auth/firebase_auth.dart';

/* **************
* Pirate name & display name logic
* ************** */

class UserProfileService {
  Future<void> updateProfile({String? displayName, String? photoURL}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (displayName != null) await user.updateDisplayName(displayName);
      if (photoURL != null) await user.updatePhotoURL(photoURL);
    }
  }

  String getDisplayName(User? user) {
    if (user == null) return '';
    if (user.displayName?.isNotEmpty ?? false) return user.displayName!;
    if (user.email?.isNotEmpty ?? false) return user.email!.split('@')[0];
    if (user.isAnonymous) return 'Guest ${user.uid.substring(0, 5)}';
    return 'Player';
  }

  Future<void> assignRandomPirateName(User? user) async {
    if (user == null || !user.isAnonymous) return;
    final name = _generatePirateName();
    await user.updateDisplayName(name);
  }

  String _generatePirateName() {
    final prefixes = ['Captain', 'Pegleg', 'Scurvy', 'Stormy', 'Mad'];
    final suffixes = ['Jack', 'Ruby', 'Bones', 'Ray', 'Barnacle'];
    prefixes.shuffle();
    suffixes.shuffle();
    return '${prefixes.first} ${suffixes.first}';
  }
}