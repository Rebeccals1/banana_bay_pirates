import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../runner_game.dart';

/// A single ground-based obstacle (e.g., crate, barrel).
class GroundObstacle extends SpriteComponent
    with HasGameReference<RunnerGame>, CollisionCallbacks {
  final double speed;

  GroundObstacle({
    required Sprite sprite,
    required Vector2 size,
    required Vector2 position,
    required this.speed,
  }) {
    this.sprite = sprite;
    this.size = size;
    this.position = position;
    anchor = Anchor.bottomLeft;
  }

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= speed * dt;
    if (position.x < -size.x) {
      removeFromParent();
    }
  }
}

/// Spawns ground obstacles with control over spacing randomness.
class GroundObstacleSpawner {
  static final _random = Random();

  static Future<void> spawn(
      RunnerGame game,
      double speed, {
        bool allowCloseSpacing = false,
      }) async {
    final obstacleImages = [
      'obstacles/crate1.png',
      'obstacles/crate2.png',
      'obstacles/metal_barrels.png',
      'obstacles/mine.png',
      'obstacles/wooden_barrel.png',
    ];

    final imagePath = obstacleImages[_random.nextInt(obstacleImages.length)];
    final width = 40 + _random.nextInt(40);
    final height = 40 + _random.nextInt(40);
    const shadowOffset = 45.0;

    // Adjust spacing range based on flag
    final minGap = allowCloseSpacing ? 20.0 : 50.0;
    final maxGap = allowCloseSpacing ? 80.0 : 150.0;
    final gap = _random.nextDouble() * (maxGap - minGap) + minGap;

    final sprite = await game.loadSprite(imagePath);
    final position = Vector2(
      game.size.x + gap,
      game.size.y * 0.8 + shadowOffset,
    );

    final obstacle = GroundObstacle(
      sprite: sprite,
      size: Vector2(width.toDouble(), height.toDouble()),
      position: position,
      speed: speed,
    );

    game.add(obstacle);
  }
}
