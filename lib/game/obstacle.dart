import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'runner_game.dart';

class Obstacle extends SpriteComponent with CollisionCallbacks, HasGameRef<RunnerGame> {
  final double speed;
  final Random random = Random();

  static final List<String> obstacleImages = [
    'obstacles/crate1.png',
    'obstacles/crate2.png',
    'obstacles/metal_barrels.png',
    'obstacles/mine.png',
    'obstacles/wooden_barrel.png',
  ];

  Obstacle({required this.speed}) : super(anchor: Anchor.bottomLeft);

  @override
  Future<void> onLoad() async {
    // Pick a random image
    final imagePath = obstacleImages[random.nextInt(obstacleImages.length)];

    // Load sprite from individual image
    sprite = await gameRef.loadSprite(imagePath);

    size = Vector2(64, 64); // or customize depending on the image
    position = Vector2(gameRef.size.x + 50, gameRef.size.y * 0.8);

    add(RectangleHitbox()..debugMode = true);

    print('🚧 Obstacle at ${position}, size: $size');

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= speed * dt;

    if (position.x < -size.x) {
      removeFromParent();
    }
  }

  // Render a fallback colored box when an image fails to load
  @override
  void render(Canvas canvas) {
    if (sprite == null) {
      final paint = Paint()..color = Colors.red;
      canvas.drawRect(size.toRect(), paint);
    }
    super.render(canvas);
  }

}
