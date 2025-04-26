import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/cupertino.dart';
import 'runner_game.dart';

// ✅ FIXED — No mixin needed!
class BackgroundComponent extends ParallaxComponent<RunnerGame> {
  @override
  Future<void> onLoad() async {
    final layers = await Future.wait([
      game.loadParallaxImage('environment/background/sky.png'),
      game.loadParallaxImage('environment/background/clouds.png'),
      game.loadParallaxImage('environment/background/island_mountains.png'),
      game.loadParallaxImage('environment/midground/ocean.png'),
      game.loadParallaxImage('environment/midground/palm_trees.png'),
      game.loadParallaxImage(
        'environment/foreground/bushes.png',
        fill: LayerFill.none,
        alignment: Alignment.bottomLeft,
        repeat: ImageRepeat.repeatX,
      ),
    ]);

    parallax = Parallax(
      [
        ParallaxLayer(layers[0], velocityMultiplier: Vector2(1.0, 0)),
        ParallaxLayer(layers[1], velocityMultiplier: Vector2(1.2, 0)),
        ParallaxLayer(layers[2], velocityMultiplier: Vector2(1.4, 0)),
        ParallaxLayer(layers[3], velocityMultiplier: Vector2(1.6, 0)),
        ParallaxLayer(layers[4], velocityMultiplier: Vector2(1.8, 0)),
        ParallaxLayer(layers[5], velocityMultiplier: Vector2(2.0, 0)), // Bushes
      ],
      baseVelocity: Vector2(20, 0),
    );

    return super.onLoad();
  }
}

