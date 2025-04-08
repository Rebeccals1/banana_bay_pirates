import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'runner_game.dart';
import 'obstacle.dart';

class Player extends SpriteAnimationComponent with CollisionCallbacks, HasGameRef<RunnerGame> {
  // Player properties
  final double gravity = 1000;
  final double jumpForce = -500;
  double velocityY = 0;
  bool isOnGround = true;
  Vector2 startPosition = Vector2.zero();

  Player() : super(size: Vector2(80, 80), anchor: Anchor.bottomCenter);

  @override
  Future<void> onLoad() async {
    // Set initial position
    position = Vector2(game.size.x * 0.2, game.size.y * 0.8);
    startPosition = position.clone();

    // Add hitbox for collision detection
    add(RectangleHitbox(
      size: Vector2(40, 60),
      position: Vector2(12, 4),
      anchor: Anchor.bottomCenter,
    ));

    add(RectangleHitbox()..debugMode = true);

    // Load player animation
    try {
      final spriteSheet = await game.images.load('player/player_spritesheet.png');
      animation = SpriteAnimation.fromFrameData(
        spriteSheet,
        SpriteAnimationData.sequenced(
          amount: 8,
          textureSize: Vector2(80, 80),
          stepTime: 0.1,
        ),
      );
    } catch (e) {
      print('Error loading player animation: $e');
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (game.isGameOver) return;

    // Apply gravity
    velocityY += gravity * dt;
    position.y += velocityY * dt;

    // Check if player is on ground
    if (position.y >= game.size.y * 0.8) {
      position.y = game.size.y * 0.8;
      velocityY = 0;
      isOnGround = true;
    }
  }

  void jump() {
    if (isOnGround) {
      velocityY = jumpForce;
      isOnGround = false;
    }
  }

  void reset() {
    position = startPosition.clone();
    velocityY = 0;
    isOnGround = true;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Obstacle && !game.isGameOver) {
      print('Collision with: ${other.runtimeType}');
      game.gameOver();
    }
  }

  // Fallback render method if sprite loading fails
  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (animation == null) {
      // Draw a simple rectangle as fallback
      final paint = Paint()..color = Colors.red;
      canvas.drawRect(
        Rect.fromLTWH(0, 0, width, height),
        paint,
      );
    }
  }
}

