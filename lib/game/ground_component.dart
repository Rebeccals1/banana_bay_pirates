import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'runner_game.dart';

class GroundComponent extends Component with HasGameRef<RunnerGame> {
  late final Sprite groundSprite;
  final List<SpriteComponent> groundTiles = [];
  final double scrollSpeed = 300;

  late double tileWidth;
  late double groundHeight;
  late double groundTop;

  @override
  Future<void> onLoad() async {
    groundTop = game.size.y * 0.8;
    groundHeight = game.size.y - groundTop;

    // Load the ground sprite
    groundSprite = await Sprite.load('environment/ground/dunes_mid.png');
    tileWidth = groundSprite.srcSize.x;

    // Calculate how many tiles are needed
    final tilesNeeded = (game.size.x / tileWidth).ceil() + 2;

    double currentX = 0;
    for (int i = 0; i < tilesNeeded; i++) {
      final tile = SpriteComponent(
        sprite: groundSprite,
        position: Vector2(currentX, groundTop),
        size: Vector2(tileWidth, groundHeight),
      );

      // ✅ Add a hitbox to each tile (so the player can collide with them)
      tile.add(RectangleHitbox()..debugMode = true);

      groundTiles.add(tile);
      add(tile);
      currentX += tileWidth;
    }

    print('🟫 Ground added with ${groundTiles.length} tiles');
  }

  @override
  void update(double dt) {
    super.update(dt);

    for (final tile in groundTiles) {
      tile.position.x -= scrollSpeed * dt;

      // If the tile moves off-screen, reposition it to the right
      if (tile.position.x + tileWidth <= 0) {
        final rightmostX = groundTiles
            .map((t) => t.position.x)
            .reduce((a, b) => a > b ? a : b);

        tile.position.x = rightmostX + tileWidth;
      }
    }
  }
}
