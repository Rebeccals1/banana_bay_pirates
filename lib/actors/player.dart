import 'dart:async';
import 'package:banana_bay_pirates/utils/utils.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import '../../banana_bay_pirates.dart';
import '../level/collision_block.dart';

enum PlayerState {
  idle, running
}

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<BananaBayPirates>, KeyboardHandler {

  String character;
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  final double stepTime = 0.2;
  Vector2 textureSize = Vector2(80, 80);
  double horizontalMovement = 0;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
  List<CollisionBlock> collisionBlocks = [];

  // Constructor
  Player({position,
    this.character = 'anne'
  }) : super(position: position);

  // Important onLoad Method (Loads one time)
  @override
  FutureOr<void> onLoad() async{
    _loadAllAnimations();
    debugMode = true;
    return super.onLoad();
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) || keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) || keysPressed.contains(LogicalKeyboardKey.arrowRight);
    // ternary if statement, -1 or 1 for true, 0 for false
    horizontalMovement += isLeftKeyPressed ? -1 : 0;
    horizontalMovement += isRightKeyPressed ? 1 : 0;

    return super.onKeyEvent(event, keysPressed);
  }


  // Important update Method (updates based on fps)
  @override
  void update(double dt) {
    _updatePlayerMovement(dt);
    _updatePlayerState(dt);
    _checkHorizontalCollisions();
    super.update(dt);
  }

  // Animation Methods
  // *********************
  Future<void> _loadAllAnimations() async {
    idleAnimation = _getSpriteAnimation(4, 'idle', Vector2(64, 80));
    runningAnimation = _getSpriteAnimation(8, 'run', Vector2(80, 80));
    // List all animations
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation
    };
    // Set current animation
    current = PlayerState.idle;
  }

  SpriteAnimation _getSpriteAnimation(int amount, String state, Vector2 size){
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('actors/players/$character/$state/$state-sheet.png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: size, // Use provided size
      ),
    );
  }

  void _updatePlayerState(double dt) {
    PlayerState playerState = PlayerState.idle;
    if(velocity.x < 0 && scale.x > 0){
      flipHorizontallyAroundCenter();
    }else if(velocity.x > 0 && scale.x < 0){
      flipHorizontallyAroundCenter();
    }

    // Check if moving, set running
    if (velocity.x > 0 || velocity.x < 0) playerState = PlayerState.running;

    current = playerState;
  }

  // Update Method
  // *********************
  void _updatePlayerMovement(double dt) {
    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }

  void _checkHorizontalCollisions() {
    for(final block in collisionBlocks){
      // handle collision
      if(!block.isPlatform){
        // 'this' being player
        if(checkCollision(this, block)) {

        }
      }
    }
  }

}

