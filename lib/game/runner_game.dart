import 'dart:math';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flame/input.dart';
import 'player.dart';
import 'obstacle.dart';
import 'background.dart';
import 'ground.dart';
import 'score_component.dart';


class RunnerGame extends FlameGame with TapDetector, KeyboardHandler, HasCollisionDetection {
  final Function(int) onGameOver;

  // Game components
  late Player player;
  late ScoreComponent scoreComponent;

  // Game state
  bool isPlaying = false;
  bool isGameOver = false;
  double rawScore = 0;
  int score = 0;
  double speed = 300;
  double spawnTimer = 0;
  double spawnInterval = 1.5;
  final Random random = Random();

  RunnerGame({required this.onGameOver});

  @override
  Future<void> onLoad() async {
    // Add background and ground
    add(BackgroundComponent());
    add(GroundComponent());

    // Add player
    player = Player();
    add(player);

    // Add score display
    scoreComponent = ScoreComponent();
    add(scoreComponent);

    // Start the game
    isPlaying = true;
    isGameOver = false;

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!isPlaying || isGameOver) return;

    // Increase score over time
    // 60 is ~1 pps, and 100 is ~1.6+ pps
    rawScore += dt * (60 + (score / 50)); // Points per second - multiplier slowly increase with score
    score = rawScore.toInt();
    scoreComponent.updateScore(score);

    // Increase game speed over time
    speed = 300 + (score / 100);

    // Spawn obstacles
    spawnTimer += dt;
    if (spawnTimer >= spawnInterval) {
      spawnTimer = 0;
      spawnInterval = 0.5 + random.nextDouble() * 1.5; // Random interval between 0.5 and 2 seconds

      // Create and add a new obstacle
      final obstacle = Obstacle(speed: speed);
      add(obstacle);
    }
  }

  @override
  void onTap() {
    if (isPlaying && !isGameOver) {
      player.jump();
    }
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent) {
      if (keysPressed.contains(LogicalKeyboardKey.space) ||
          keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
        if (isPlaying && !isGameOver) {
          player.jump();
        }
        return true;
      }
    }
    return false;
  }

  void gameOver() {
    if (isGameOver) return; // Prevent multiple game over calls

    isPlaying = false;
    isGameOver = true;

    print('Game over called with score: $score');

    // Delay the callback slightly to ensure the game state is updated
    Future.delayed(const Duration(milliseconds: 100), () {
      onGameOver(score);
    });
  }

  void reset() {
    score = 0;
    speed = 300;
    spawnTimer = 0;
    spawnInterval = 1.5;
    isPlaying = true;
    isGameOver = false;

    // Remove all obstacles
    children.whereType<Obstacle>().forEach((obstacle) {
      obstacle.removeFromParent();
    });

    // Reset player position
    player.reset();

    // Reset score display
    scoreComponent.updateScore(0);
  }
}

