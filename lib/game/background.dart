import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'runner_game.dart';

class BackgroundComponent extends ParallaxComponent<RunnerGame> {
  @override
  Future<void> onLoad() async {
    // Load parallax background layers
    parallax = await Parallax.load(
      [
        ParallaxImageData('environment/background/sky.png'),
        ParallaxImageData('environment/midground/ocean.png'),
        ParallaxImageData('environment/foreground/palm_trees.png'),
      ],
      baseVelocity: Vector2(20, 0),
      velocityMultiplierDelta: Vector2(1.5, 0),
    );

    add(RectangleHitbox()..debugMode = true);

    return super.onLoad();
  }
}

