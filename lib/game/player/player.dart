import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'runner_game.dart';
import 'obstacle.dart';

class Player extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<RunnerGame> {
  // Physics
  final double gravity = 1000;
  final double jumpForce = -500;
  double velocityY = 0;

  // State
  bool isOnGround = true;
  Vector2 startPosition = Vector2.zero();

  Player() : super(size: Vector2(80, 80), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    _setStartPosition();
    _addHitbox();
    await _loadAnimation();
    return super.onLoad();
  }

  void _setStartPosition() {
    position = Vector2(game.size.x * 0.2, game.size.y * 0.8 + 40); // 40 = half the height
    startPosition = position.clone();
  }

  void _addHitbox() {
    add(RectangleHitbox(
      size: Vector2(40, 60),
      position: Vector2(12, 4),
      anchor: Anchor.bottomCenter,
    ));
    add(RectangleHitbox()..debugMode = true); // Optional visual aid
  }

  Future<void> _loadAnimation() async {
    try {
      final spriteSheet =
      await game.images.load('player/player_spritesheet.png');
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
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (game.isGameOver) return;

    _applyGravity(dt);
    _checkIfOnGround();
  }

  void _applyGravity(double dt) {
    velocityY += gravity * dt;
    position.y += velocityY * dt;
  }

  void _checkIfOnGround() {
    final groundY = game.size.y * 0.8;
    if (position.y >= groundY) {
      position.y = groundY;
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
      print('💥 Player hit obstacle: ${other.runtimeType}');
      game.gameOver();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (animation == null) _renderFallback(canvas);
  }

  void _renderFallback(Canvas canvas) {
    final paint = Paint()..color = Colors.red;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, width, height),
      paint,
    );
  }
}
