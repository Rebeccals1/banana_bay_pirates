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
import 'ground_component.dart';
import 'score_component.dart';

class RunnerGame extends FlameGame with TapDetector, KeyboardHandler, HasCollisionDetection {
  final Function(int) onGameOver;

  late Player player;
  late ScoreComponent scoreComponent;

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
    await initializeEnvironment();
    await initializePlayer();
    await initializeScoreUI();

    isPlaying = true;
    isGameOver = false;

    return super.onLoad();
  }

  Future<void> initializeEnvironment() async {
    add(BackgroundComponent());
    add(GroundComponent());
    // Add platforms here if applicable
  }

  Future<void> initializePlayer() async {
    player = Player();
    add(player);
  }

  Future<void> initializeScoreUI() async {
    scoreComponent = ScoreComponent();
    add(scoreComponent);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!isPlaying || isGameOver) return;

    updateScore(dt);
    updateSpeed();
    handleObstacleSpawning(dt);
  }

  void updateScore(double dt) {
    rawScore += dt * (60 + (score / 50));
    score = rawScore.toInt();
    scoreComponent.updateScore(score);
  }

  void updateSpeed() {
    speed = 300 + (score / 100);
  }

  void handleObstacleSpawning(double dt) {
    spawnTimer += dt;
    if (spawnTimer >= spawnInterval) {
      spawnTimer = 0;

      final minSpawn = 1.2;
      final maxSpawn = 2.6;

      // Clamp higher score = shorter spawn interval
      final scale = (speed / 300).clamp(1.0, 2.0);
      spawnInterval = (minSpawn + random.nextDouble() * (maxSpawn - minSpawn)) / scale;

      add(Obstacle(speed: speed));
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

  void gameOver() {
    if (isGameOver) return;

    isPlaying = false;
    isGameOver = true;

    print('Game over called with score: $score');

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

    children.whereType<Obstacle>().forEach((obstacle) {
      obstacle.removeFromParent();
    });

    player.reset();
    scoreComponent.updateScore(0);
  }
}


