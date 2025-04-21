import 'package:flame/components.dart';
import '../obstacle.dart';
import 'player.dart';

class PlayerCollisionHandler {
  void handleCollision(Player player, PositionComponent other) {
    if (other is Obstacle && !player.gameRef.isGameOver) {
      print('💥 Player hit: ${other.runtimeType}');
      player.gameRef.gameOver();
    }
  }
}
