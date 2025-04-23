import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/* **************
* Guest login logging only (no score tracking)
* ************** */

class GuestProfileService {
  final _firestore = FirebaseFirestore.instance;

  Future<void> initializeGuestProfile(User? user) async {
    if (user == null || !user.isAnonymous) return;

    // Log guest entry once
    await _firestore.collection('players').doc(user.uid).set({
      'uid': user.uid,
      'displayName': user.displayName ?? 'Guest',
      'isGuest': true,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
