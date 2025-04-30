import 'package:flame/components.dart';
import '../obstacles/ground_obstacle_spawner.dart';
import '../obstacles/parrot_spawner.dart';
import 'player.dart';

class PlayerCollisionHandler {
  void handleCollision(Player player, PositionComponent other) {
    final isObstacle = other is GroundObstacle || other is Parrot;

    if (isObstacle && !player.gameRef.isGameOver) {
      player.gameRef.gameOver();
    }
  }
}
