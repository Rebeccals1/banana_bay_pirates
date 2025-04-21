import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'runner_game.dart';

class Obstacle extends SpriteComponent
    with CollisionCallbacks, HasGameRef<RunnerGame> {
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
  late TimerComponent obstacleSpawner;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _loadRandomSprite();
    _initializePosition();
    _addHitbox();

    print('🚧 Obstacle at $position, size: $size');
  }

  Future<void> _loadRandomSprite() async {
    final imagePath = obstacleImages[random.nextInt(obstacleImages.length)];
    sprite = await gameRef.loadSprite(imagePath);

    final width = 32 + random.nextInt(40);   // 32–72px
    final height = 40 + random.nextInt(40);  // 40–80px
    size = Vector2(width.toDouble(), height.toDouble());
  }

  void _initializePosition() {
    const shadowOffset = 45.0; // Adjust if shadow makes sprite look like it's floating
    position = Vector2(gameRef.size.x + 50, gameRef.size.y * 0.8 + shadowOffset);
  }

  void _addHitbox() {
    add(RectangleHitbox()..debugMode = true);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= speed * dt;

    if (position.x < -size.x) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    if (sprite == null) {
      final paint = Paint()..color = const Color(0xFFFF0000); // Red fallback
      canvas.drawRect(size.toRect(), paint);
    }
    super.render(canvas);
  }
}
