import 'dart:async';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import '../../banana_bay_pirates.dart';

enum PlayerState {
  idle, running
}

enum PlayerDirection {
  left, right, none
}

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<BananaBayPirates>, KeyboardHandler {

  String character;
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  final double stepTime = 0.2;
  Vector2 textureSize = Vector2(80, 80);
  PlayerDirection playerDirection = PlayerDirection.none;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
  bool isFacingRight = true;

  // Constructor
  Player({position,
    this.character = 'anne'
  }) : super(position: position);

  // Important onLoad Method (Loads one time)
  @override
  FutureOr<void> onLoad() async{
    _loadAllAnimations();
    return super.onLoad();
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) || keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) || keysPressed.contains(LogicalKeyboardKey.arrowRight);

    print("Keys Pressed: $keysPressed");

    if (isLeftKeyPressed && isRightKeyPressed) {
      playerDirection = PlayerDirection.none;
    } else if (isLeftKeyPressed) {
      playerDirection = PlayerDirection.left;
    } else if (isRightKeyPressed) {
      playerDirection = PlayerDirection.right;
    } else {
      playerDirection = PlayerDirection.none;
    }

    return super.onKeyEvent(event, keysPressed);
  }


  // Important update Method (updates based on fps)
  @override
  void update(double dt) {
    _updatePlayerMovement(dt);
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

  // Update Method
  // *********************
  void _updatePlayerMovement(double dt) {
    double dirX = 0.0;
    switch(playerDirection){
      case PlayerDirection.left:
        if(isFacingRight){
          flipHorizontallyAroundCenter();
          isFacingRight = false;
        }
        current = PlayerState.running;
        dirX -= moveSpeed;
        break;
      case PlayerDirection.right:
        if(!isFacingRight){
          flipHorizontallyAroundCenter();
          isFacingRight = true;
        }
        current = PlayerState.running;
        dirX += moveSpeed;
        break;
      case PlayerDirection.none:
        current = PlayerState.idle;
        break;
    }

    velocity = Vector2(dirX, 0.0);
    position.x += velocity.x * dt;
  }



}

