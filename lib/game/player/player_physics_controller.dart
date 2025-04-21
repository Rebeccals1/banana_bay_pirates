import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'player.dart';

class PlayerPhysicsController {
  final double gravity = 1000;
  final double jumpForce = -500;
  double velocityY = 0;
  bool isOnGround = true;
  late Vector2 startPosition;

  void setStartPosition(Player player) {
    final game = player.gameRef;
    player.position = Vector2(game.size.x * 0.2, game.size.y * 0.8 + 40);
    startPosition = player.position.clone();
  }

  void addHitbox(Player player) {
    player
      ..add(RectangleHitbox(
        size: Vector2(40, 60),
        position: Vector2(12, 4),
        anchor: Anchor.bottomCenter,
      ))
      ..add(RectangleHitbox()..debugMode = true);
  }

  void apply(Player player, double dt) {
    velocityY += gravity * dt;
    player.position.y += velocityY * dt;

    final groundY = player.gameRef.size.y * 0.8;
    if (player.position.y >= groundY) {
      player.position.y = groundY;
      velocityY = 0;
      isOnGround = true;
    } else {
      isOnGround = false;
    }
  }

  bool jump() {
    if (isOnGround) {
      velocityY = jumpForce;
      isOnGround = false;
      return true;
    }
    return false;
  }

  void reset(Player player) {
    player.position = startPosition.clone();
    velocityY = 0;
    isOnGround = true;
  }
}
