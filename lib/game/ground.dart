import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'runner_game.dart';

class GroundComponent extends PositionComponent with HasGameRef<RunnerGame> {
  late final Sprite groundSprite;
  final List<Rect> groundTiles = [];
  final double scrollSpeed = 300;

  @override
  Future<void> onLoad() async {
    // Set component size to match game width and ground height
    size = Vector2(game.size.x, 20);
    position = Vector2(0, game.size.y * 0.8);

    try {
      // Load ground sprite
      groundSprite = await Sprite.load('dunes_mid.png');

      // Create initial ground tiles
      final tileWidth = 512.0;
      final tilesNeeded = (game.size.x / tileWidth).ceil() + 1;

      for (int i = 0; i < tilesNeeded; i++) {
        groundTiles.add(Rect.fromLTWH(
          i * tileWidth,
          0,
          tileWidth,
          20,
        ));
      }
    } catch (e) {
      print('Error loading ground sprite: $e');
    }

    add(RectangleHitbox()..debugMode = true);
    print('🟫 Ground added at $position with size $size');

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Scroll ground tiles
    for (int i = 0; i < groundTiles.length; i++) {
      final tile = groundTiles[i];
      final newX = tile.left - scrollSpeed * dt;

      // If tile is off-screen to the left, move it to the right
      if (newX <= -tile.width) {
        final rightmostX = groundTiles
            .map((t) => t.right)
            .reduce((value, element) => value > element ? value : element);

        groundTiles[i] = Rect.fromLTWH(
          rightmostX,
          tile.top,
          tile.width,
          tile.height,
        );
      } else {
        groundTiles[i] = Rect.fromLTWH(
          newX,
          tile.top,
          tile.width,
          tile.height,
        );
      }
    }
  }

  @override
  void render(Canvas canvas) {
    // Draw ground tiles
    if (groundSprite != null) {
      for (final tile in groundTiles) {
        groundSprite.renderRect(canvas, tile);
      }
    } else {
      // Fallback if sprite loading fails
      final paint = Paint()..color = Colors.brown;
      canvas.drawRect(
        Rect.fromLTWH(0, 0, game.size.x, 20),
        paint,
      );
    }
  }
}

