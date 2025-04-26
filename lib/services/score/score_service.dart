import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/score.dart';

class ScoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;  // Initialize FirebaseAuth

  // Reference to 'scores' collection
  CollectionReference get _scoresRef => _firestore.collection('scores');

  // 🔹 Delete duplicate scores based on email
  Future<void> deleteDuplicateScoresWithEmail() async {
    // Query all documents in the scores collection
    QuerySnapshot snapshot = await _scoresRef.get();

    // Map to group documents by email
    Map<String, List<DocumentSnapshot>> emailScores = {};

    // Group documents by email, but only include documents where email is not null
    for (var doc in snapshot.docs) {
      String email = doc['email'];
      if (email.isNotEmpty) {  // Only process documents with a valid email
        if (!emailScores.containsKey(email)) {
          emailScores[email] = [];
        }
        emailScores[email]!.add(doc);
      }
    }

    // Loop through each group of scores with the same email
    emailScores.forEach((email, docs) {
      if (docs.length > 1) {
        // Sort the documents for the same email by 'timestamp' (or score if preferred)
        docs.sort((a, b) => (b['timestamp'] as int).compareTo(a['timestamp'] as int));

        // Keep the most recent document and delete the rest
        for (int i = 1; i < docs.length; i++) {
          _scoresRef.doc(docs[i].id).delete();
        }
      }
    });
  }

  // 🔹 Save score only if it's a new high score
  Future<void> saveScore(int score, String playerName) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print('Cannot save score: No authenticated user');
        return;
      }

      if (user.isAnonymous) {
        print('Guest users cannot submit scores.');
        return; // Skip write entirely
      }

      // Determine player name fallback
      String name = playerName;
      if (name.isEmpty) {
        if (user.displayName != null && user.displayName!.isNotEmpty) {
          name = user.displayName!;
        } else if (user.email != null) {
          name = user.email!.split('@')[0];
        } else {
          name = 'Player ${user.uid.substring(0, 5)}';
        }
      }

      final docRef = _scoresRef.doc(user.uid);
      final docSnapshot = await docRef.get();

      final existingScore = docSnapshot.exists
          ? (docSnapshot.data() as Map<String, dynamic>)['score'] ?? 0
          : 0;

      if (score > existingScore) {
        print('New high score! Updating score to $score');
        await docRef.set({
          'playerName': name,
          'score': score,
          'userId': user.uid,
          'email': user.email ?? '',
          'isGuest': false,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        });
      } else {
        print('Score $score is not higher than existing score $existingScore');
      }
    } catch (e) {
      print('Error saving score: $e');
    }
  }

  // 🔹 Get top scores (sorted descending)
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

  // 🔹 Get the best score of the currently signed-in user
  Future<int> getUserBestScore() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return 0;

      final doc = await _scoresRef.doc(user.uid).get();
      if (!doc.exists) return 0;

      return (doc.data() as Map<String, dynamic>)['score'] ?? 0;
    } catch (e) {
      print('Error getting user best score: $e');
      return 0;
    }
  }

  // 🔹 Get the current user's score data (for display, etc.)
  Future<Score?> getCurrentUserScore() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final doc = await _scoresRef.doc(user.uid).get();
      if (!doc.exists) return null;

      return Score.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    } catch (e) {
      print('Error fetching current user score: $e');
      return null;
    }
  }
}
