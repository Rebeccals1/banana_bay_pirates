import 'dart:async';
import 'dart:ui';
import 'package:banana_bay_pirates/actors/player.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'level/levels.dart';

class BananaBayPirates extends FlameGame with HasKeyboardHandlerComponents, DragCallbacks {

  @override
  Color backgroundColor() => const Color(0x002ba4a7);
  late final CameraComponent cam;
  Player player = Player(character: 'anne');
  late JoystickComponent joystick;
  bool showJoystick = true;

  // Important onLoad Method
  @override
  FutureOr<void> onLoad() async{
    // Load all images into cache
    await images.loadAllImages();
    // Initiate world and player position variable
    @override
    final world = Level(
      levelName: 'level-01',
      player: player,
    );
    // Initialize the camera AFTER loading assets
    cam = CameraComponent.withFixedResolution(world: world, width: 1024, height: 768);
    cam.viewfinder.anchor = Anchor.topLeft;
    // cam and world added to game
    addAll([cam, world]);
    // Check for mobile joytick
    if(showJoystick){
      addJoystick();
    }
    return super.onLoad();
  }

  // Update joystick
  @override
  void update(double dt){
    if(showJoystick) {
      updateJoystick();
    }
    super.update(dt);
  }

  // Add mobile joytick
  void addJoystick() {
      joystick = JoystickComponent(
          knob: SpriteComponent(
              sprite: Sprite(
                  images.fromCache('hud/knob.png')
              ),
          ),
        knobRadius: 16,
        background: SpriteComponent(
          sprite: Sprite(
            images.fromCache('hud/joystick.png'),
          ),
        ),
        margin: const EdgeInsets.only(left: 64, bottom: 64),
      );
      add(joystick);
  }

  void updateJoystick() {
    switch(joystick.direction){
      case JoystickDirection.idle:
      case JoystickDirection.up:
      case JoystickDirection.down:
        player.playerDirection = PlayerDirection.none;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.playerDirection = PlayerDirection.right;
        break;
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.playerDirection = PlayerDirection.left;
        break;

    }
  }

}