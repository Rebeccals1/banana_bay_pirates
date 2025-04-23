// lib/screens/leaderboard_screen.dart
import 'package:flutter/material.dart';
import '../services/score/score_service.dart';
import '../models/score.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scoreService = ScoreService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple, Colors.purple],
          ),
        ),
        child: FutureBuilder<List<Score>>(
          future: scoreService.getTopScores(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error loading scores: ${snapshot.error}',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }

            final scores = snapshot.data ?? [];

            if (scores.isEmpty) {
              return const Center(
                child: Text(
                  'No scores yet. Be the first to play! 🏴‍☠️',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: scores.length,
              itemBuilder: (context, index) {
                final score = scores[index];
                final isTopThree = index < 3;

                return Card(
                  elevation: isTopThree ? 8 : 2,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  color: isTopThree
                      ? Colors.amber.withOpacity(0.85)
                      : Colors.white.withOpacity(0.9),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                      isTopThree ? Colors.blueAccent.shade700 : Colors.teal,
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      score.playerName,
                      style: TextStyle(
                        fontWeight:
                        isTopThree ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    trailing: Text(
                      '${score.score}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                        isTopThree ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}