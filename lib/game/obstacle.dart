import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'runner_game.dart';

class Obstacle extends SpriteComponent
    with CollisionCallbacks, HasGameRef<RunnerGame> {
  final double speed;
  final Random random = Random();
  final double minObstacleSpacing = 50;
  final double maxObstacleSpacing = 150;

  static final List<String> obstacleImages = [
    'obstacles/crate1.png',
    'obstacles/crate2.png',
    'obstacles/metal_barrels.png',
    'obstacles/mine.png',
    'obstacles/wooden_barrel.png',
  ];

  SpriteAnimationComponent? _parrot;
  double _parrotTime = 0; // Time tracker for sine wave

  Obstacle({required this.speed}) : super(anchor: Anchor.bottomLeft);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _loadRandomSprite();
    _initializePosition();
    _addHitbox();

    // Always spawn parrot for now (can make conditional later)
    await _spawnParrot();

    print('🚧 Obstacle at $position, size: $size');
  }

  Future<void> _loadRandomSprite() async {
    final imagePath = obstacleImages[random.nextInt(obstacleImages.length)];
    sprite = await gameRef.loadSprite(imagePath);

    final width = 40 + random.nextInt(40);
    final height = 40 + random.nextInt(40);
    size = Vector2(width.toDouble(), height.toDouble());
  }

  void _initializePosition() {
    const shadowOffset = 45.0;
    double gap = random.nextDouble() * (maxObstacleSpacing - minObstacleSpacing) + minObstacleSpacing;
    position = Vector2(gameRef.size.x + gap, gameRef.size.y * 0.8 + shadowOffset);
  }

  void _addHitbox() {
    add(RectangleHitbox()..debugMode = false);
  }

  Future<void> _spawnParrot() async {
    final image = await gameRef.images.load('obstacles/parrot_flying.png');

    final animation = SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: 6,
        stepTime: 0.12,
        textureSize: Vector2(64, 64),
      ),
    );

    _parrot = SpriteAnimationComponent()
      ..animation = animation
      ..size = Vector2(64, 64)
      ..position = Vector2(gameRef.size.x + 100, gameRef.size.y * 0.4)
      ..anchor = Anchor.center;

    gameRef.add(_parrot!); // Add directly to game, not as a child of obstacle
    print('Parrot spawned at ${_parrot!.position}');
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= speed * dt;

    if (_parrot != null) {
      _parrotTime += dt;
      _parrot!.position.x -= speed * dt * 1.1;
      _parrot!.position.y = gameRef.size.y * 0.4 + 20 * sin(_parrotTime * 3);
    }

    if (position.x < -size.x) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    if (sprite == null) {
      final paint = Paint()..color = const Color(0xFFFF0000);
      canvas.drawRect(size.toRect(), paint);
    }
    super.render(canvas);
  }
}
