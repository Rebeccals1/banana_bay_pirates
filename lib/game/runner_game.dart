import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:flutter/services.dart';

import 'player/player.dart';
import 'obstacle_manager.dart';
import 'background.dart';
import 'ground_manager.dart';
import 'score_manager.dart';

/// Main game class for Banana Bay Pirates.
/// Handles player, environment, obstacles, and game state.
class RunnerGame extends FlameGame
    with TapDetector, KeyboardHandler, HasCollisionDetection {
  final Function(int) onGameOver;

  late Player player;
  late ScoreComponent scoreComponent;
  late Obstacles obstacles;

  bool isPlaying = false;
  bool isGameOver = false;
  bool airObstaclesEnabled = true; // 🔹 Toggle for parrot spawning

  double rawScore = 0;
  int score = 0;
  double speed = 300;

  RunnerGame({required this.onGameOver});

  @override
  Future<void> onLoad() async {
    await initializeEnvironment();
    await initializePlayer();
    await initializeScoreUI();
    await initializeObstacles();

    isPlaying = true;
    isGameOver = false;

    return super.onLoad();
  }

  /// Adds background and ground layers to the game
  Future<void> initializeEnvironment() async {
    add(BackgroundComponent());
    add(GroundComponent());
  }

  /// Creates and adds the main player character
  Future<void> initializePlayer() async {
    player = Player();
    add(player);
  }

  /// Initializes the score UI display
  Future<void> initializeScoreUI() async {
    scoreComponent = ScoreComponent();
    add(scoreComponent);
  }

  /// Creates the obstacle system with optional air obstacles
  Future<void> initializeObstacles() async {
    obstacles = Obstacles(
      speed: speed,
      airObstaclesEnabled: airObstaclesEnabled,
    );
    add(obstacles);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!isPlaying || isGameOver) return;
    updateScore(dt);
    updateSpeed();

    // Keep obstacles updated with current speed
    obstacles.speed = speed;
  }

  /// Updates player score over time and based on speed
  void updateScore(double dt) {
    rawScore += dt * (60 + (score / 50));
    score = rawScore.toInt();
    scoreComponent.updateScore(score);
  }

  /// Increases speed dynamically based on score
  void updateSpeed() {
    speed = 300 + (score / 100);
  }

  @override
  void onTap() {
    if (isPlaying && !isGameOver) {
      player.jump();
    }
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent &&
        (keysPressed.contains(LogicalKeyboardKey.space) ||
            keysPressed.contains(LogicalKeyboardKey.arrowUp))) {
      if (isPlaying && !isGameOver) {
        player.jump();
      }
      return true;
    }
    return false;
  }

  /// Ends the game and notifies parent widget with score
  void gameOver() {
    if (isGameOver) return;

    isPlaying = false;
    isGameOver = true;

    Future.delayed(const Duration(milliseconds: 100), () {
      onGameOver(score);
    });
  }

  /// Resets the game for a fresh start
  void reset() {
    score = 0;
    speed = 300;
    rawScore = 0;
    isPlaying = true;
    isGameOver = false;

    // Remove all game components except Player and Score
    children.where((c) => c is! Player && c is! ScoreComponent).forEach((component) {
      component.removeFromParent();
    });

    player.reset();
    scoreComponent.updateScore(0);

    // Restart obstacles
    initializeObstacles();
  }
}
