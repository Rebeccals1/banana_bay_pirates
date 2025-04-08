import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'runner_game.dart';

class ScoreComponent extends PositionComponent with HasGameRef<RunnerGame> {
  int score = 0;
  late TextPaint textPaint;

  ScoreComponent() : super(anchor: Anchor.topCenter);

  @override
  Future<void> onLoad() async {
    // Set up text renderer
    textPaint = TextPaint(
      style: const TextStyle(
        fontSize: 24,
        color: Colors.white,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
            blurRadius: 4,
            color: Colors.black,
            offset: Offset(2, 2),
          ),
        ],
      ),
    );

    // Position at top center of screen
    position = Vector2(game.size.x / 2, 40);

    return super.onLoad();
  }

  void updateScore(int newScore) {
    if (newScore != score) {
      print('Score updated: $newScore');
      score = newScore;
    }
  }

  @override
  void render(Canvas canvas) {
    // Render score text with more visible styling
    textPaint = TextPaint(
      style: const TextStyle(
        fontSize: 30, // Increased font size
        color: Colors.white,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
            blurRadius: 4,
            color: Colors.black,
            offset: Offset(2, 2),
          ),
        ],
      ),
    );

    textPaint.render(
      canvas,
      'Score: $score',
      Vector2.zero(),
      anchor: Anchor.topCenter,
    );
  }
}

