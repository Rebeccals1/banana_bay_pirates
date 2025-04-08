// lib/models/score.dart
class Score {
  final String id;
  final String playerName;
  final int score;
  final DateTime timestamp;
  final bool isGuest;

  Score({
    required this.id,
    required this.playerName,
    required this.score,
    required this.timestamp,
    this.isGuest = false,
  });

  factory Score.fromMap(String id, Map<String, dynamic> map) {
    return Score(
      id: id,
      playerName: map['playerName'] ?? 'Anonymous',
      score: map['score'] ?? 0,
      isGuest: map['isGuest'] ?? false,
      timestamp: (map['timestamp'] != null)
          ? DateTime.fromMillisecondsSinceEpoch(map['timestamp'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'playerName': playerName,
      'score': score,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'isGuest': isGuest,
    };
  }
}