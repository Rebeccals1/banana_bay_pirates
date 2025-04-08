import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/score.dart';

class ScoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collection reference
  CollectionReference get _scoresRef => _firestore.collection('scores');

  // Get current user
  User? get _currentUser => _auth.currentUser;

  // Save score to Firestore
  Future<void> saveScore(int score, String playerName) async {
    try {
      final user = _currentUser;
      if (user == null) {
        print('Cannot save score: No authenticated user');
        return;
      }

      // Use provided player name or fallback to user's display name or email
      String name = playerName;
      if (name.isEmpty) {
        if (user.displayName != null && user.displayName!.isNotEmpty) {
          name = user.displayName!;
        } else if (user.email != null) {
          name = user.email!.split('@')[0]; // Use email username part
        } else {
          name = 'Player ${user.uid.substring(0, 5)}';
        }
      }

      print('Saving score $score for player $name (${user.uid})');

      await _scoresRef.add({
        'playerName': name,
        'score': score,
        'userId': user.uid,
        'email': user.email,
        'isGuest': user.isAnonymous, // <-- new field
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      print('Error saving score: $e');
    }
  }

  // Get top scores
  Future<List<Score>> getTopScores({int limit = 10}) async {
    try {
      final querySnapshot = await _scoresRef
          .orderBy('score', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => Score.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting top scores: $e');
      return [];
    }
  }

  // Get user's best score
  Future<int> getUserBestScore() async {
    try {
      final user = _currentUser;
      if (user == null) return 0;

      final querySnapshot = await _scoresRef
          .where('userId', isEqualTo: user.uid)
          .orderBy('score', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) return 0;

      return (querySnapshot.docs.first.data() as Map<String, dynamic>)['score'] ?? 0;
    } catch (e) {
      print('Error getting user best score: $e');
      return 0;
    }
  }

  // Get user's scores
  Future<List<Score>> getUserScores({int limit = 10}) async {
    try {
      final user = _currentUser;
      if (user == null) return [];

      final querySnapshot = await _scoresRef
          .where('userId', isEqualTo: user.uid)
          .orderBy('score', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => Score.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting user scores: $e');
      return [];
    }
  }
}

