import 'package:flame/components.dart';
import 'player.dart';

class PlayerAnimationController {
  late SpriteAnimation runAnimation;
  late SpriteAnimation jumpAnimation;
  late SpriteAnimation fallAnimation;

  Future<void> loadAnimations(Player player) async {
    final spriteSheetRun = await player.gameRef.images.load('player/player_run.png');
    final spriteSheetJump = await player.gameRef.images.load('player/player_jump.png');
    final spriteSheetFall = await player.gameRef.images.load('player/player_fall.png');

    runAnimation = SpriteAnimation.fromFrameData(
      spriteSheetRun,
      SpriteAnimationData.sequenced(
        amount: 6,
        textureSize: Vector2(80, 80),
        stepTime: 0.1,
        loop: true,
      ),
    );

    jumpAnimation = SpriteAnimation.fromFrameData(
      spriteSheetJump,
      SpriteAnimationData.sequenced(
        amount: 1,
        textureSize: Vector2(70, 80),
        stepTime: 0.1,
        loop: false,
      ),
    );

    fallAnimation = SpriteAnimation.fromFrameData(
      spriteSheetFall,
      SpriteAnimationData.sequenced(
        amount: 1,
        textureSize: Vector2(70, 80),
        stepTime: 0.1,
        loop: false,
      ),
    );
  }

  void update(Player player, double velocityY, bool isOnGround) {
    if (!isOnGround) {
      player.animation = velocityY < 0 ? jumpAnimation : fallAnimation;
    } else {
      player.animation = runAnimation;
    }
  }

  void setJump() {
    // optional: trigger once or sound effect
  }
}
