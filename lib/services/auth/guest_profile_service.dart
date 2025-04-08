import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/* **************
* Guest Firestore score tracking
* ************** */

class GuestProfileService {
  final _firestore = FirebaseFirestore.instance;

  Future<void> initializeGuestProfile(User? user) async {
    if (user == null || !user.isAnonymous) return;

    await _firestore.collection('players').doc(user.uid).set({
      'uid': user.uid,
      'displayName': user.displayName ?? 'Guest',
      'isGuest': true,
      'score': 0,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> updateGuestScore(int newScore) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.isAnonymous) {
      await _firestore.collection('players').doc(user.uid).update({
        'score': newScore,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    }
  }
}
