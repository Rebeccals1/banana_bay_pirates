import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import '../actors/player.dart';

class Level extends World{
  final String levelName;
  final Player player;
  late TiledComponent level;

  // Constructor
  Level({required this.levelName, required this.player});

  // Important onLoad Method
  @override
  FutureOr<void> onLoad() async{
    // Initialize the level component
    level = await TiledComponent.load('$levelName.tmx',Vector2.all(16));
    // Add the level to the world
    add(level);
    // Access spawn points from the 'Spawnpoints' layer in the Tiled map
    final spawnPointLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');

    for(final spawnPoint in spawnPointLayer!.objects){
      switch(spawnPoint.class_){
        case 'Player':
          player.position = Vector2(spawnPoint.x, spawnPoint.y);
          add(player);
          break;
        default:
        // Handle other cases if necessary
          break;
      }
    }

    return super.onLoad();
  }


}