import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../runner_game.dart';

/// A flying obstacle (parrot) that moves left while fluttering vertically.
class Parrot extends SpriteAnimationComponent
    with HasGameReference<RunnerGame>, CollisionCallbacks {
  final double speed;
  double _time = 0; // Time tracker for sine wave motion

  Parrot({
    required SpriteAnimation animation,
    required this.speed,
  }) : super(
    animation: animation,
    size: Vector2(128, 128),
    anchor: Anchor.center,
  );

  @override
  Future<void> onLoad() async {
    final rand = Random();

    // Random Y position between 15% and 65% of screen height
    final minY = game.size.y * 0.15;
    final maxY = game.size.y * 0.65;
    final startY = minY + rand.nextDouble() * (maxY - minY);

    position = Vector2(game.size.x + size.x, startY);

    // Add a smaller relative hitbox for more accurate collision
    add(
      RectangleHitbox(
        // Set the size of the hitbox to 40% width and 25% height of the parent
        size: Vector2(size.x * 0.4, size.y * 0.25),

        // Position the hitbox at 30% from the left and 75% from the top of the parent
        position: Vector2(size.x * 0.1, size.y * 0.5),
      )..debugMode = false, // Enable visual debugging to see the hitbox outline
    );

  }

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;

    // Flutter using sine wave
    position.x -= speed * dt;
    position.y += 20 * sin(_time * 3) * dt;

    // Remove when off screen
    if (position.x < -size.x) {
      removeFromParent();
    }
  }
}

/// Static helper for spawning parrots via ObstacleManager or directly.
class AirObstacleSpawner {
  static Future<void> spawn(
      RunnerGame game, {
        required double baseSpeed,
      }) async {
    final image = await game.images.load('obstacles/parrot_flying.png');

    final animation = SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: 6,
        stepTime: 0.12,
        textureSize: Vector2(128, 128),
      ),
    );

    final parrot = Parrot(animation: animation, speed: baseSpeed);
    game.add(parrot);
  }
}
