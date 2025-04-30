import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'runner_game.dart';

/// The scrolling ground layer of the game.
/// Dynamically adjusts scroll speed based on game.score.
class GroundComponent extends Component with HasGameReference<RunnerGame> {
  late Sprite groundSprite;
  final List<SpriteComponent> groundTiles = [];

  late double tileWidth;
  late double groundHeight;
  late double groundTop;

  bool _isInitialized = false;

  @override
  Future<void> onLoad() async {
    // Load the ground texture
    groundSprite = await Sprite.load('environment/ground/dunes_mid.png');
    tileWidth = groundSprite.srcSize.x;
    _isInitialized = true;
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);
    if (!_isInitialized) return;

    // Remove any existing tiles before resizing
    for (final tile in groundTiles) {
      tile.removeFromParent();
    }
    groundTiles.clear();

    // Calculate new layout
    groundTop = canvasSize.y * 0.8;
    groundHeight = canvasSize.y - groundTop;

    final tilesNeeded = (canvasSize.x / tileWidth).ceil() + 2;

    double currentX = 0;
    for (int i = 0; i < tilesNeeded; i++) {
      final tile = SpriteComponent(
        sprite: groundSprite,
        position: Vector2(currentX, groundTop),
        size: Vector2(tileWidth, groundHeight),
      );

      tile.add(RectangleHitbox()..debugMode = false);

      groundTiles.add(tile);
      add(tile);
      currentX += tileWidth;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    final double currentScrollSpeed = game.speed; // Dynamic scroll speed

    for (final tile in groundTiles) {
      tile.position.x -= currentScrollSpeed * dt;

      // Recycle off-screen tiles
      if (tile.position.x + tileWidth <= 0) {
        final rightmostX = groundTiles
            .map((t) => t.position.x)
            .reduce((a, b) => a > b ? a : b);

        tile.position.x = rightmostX + tileWidth - 20;
      }
    }
  }
}
