import 'dart:async';
import 'package:banana_bay_pirates/level/collision_block.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import '../actors/player.dart';

class Level extends World{
  final String levelName;
  final Player player;
  late TiledComponent level;
  List<CollisionBlock> collisionBlocks = [];

  // Constructor
  Level({required this.levelName, required this.player});

  // Important onLoad Method
  @override
  FutureOr<void> onLoad() async{
    // Initialize the level component and add to world
    level = await TiledComponent.load('$levelName.tmx',Vector2.all(16));
    add(level);
    // Access spawn points from the 'Spawnpoints' layer in the Tiled map
    final spawnPointLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');
    if(spawnPointLayer != null){
      for(final spawnPoint in spawnPointLayer!.objects){
        switch(spawnPoint.class_){
          case 'Player':
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            add(player);
            break;
          default:
            break;
        }
      }
    }

    // Get the Collision layer
    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');
    if(collisionsLayer != null){
      for(final collision in collisionsLayer.objects){
          switch(collision.class_){
            case 'Platform':
              final platform = CollisionBlock(
                  position: Vector2(collision.x,collision.y),
                      size: Vector2(collision.width, collision.height),
                isPlatform: true,
              );
              collisionBlocks.add(platform);
              add(platform);
              break;
            default:
              final block = CollisionBlock(
                position: Vector2(collision.x,collision.y),
                size: Vector2(collision.width, collision.height),
              );
              collisionBlocks.add(block);
              add(block);
          }
      }
    }
    player.collisionBlocks = collisionBlocks;
    return super.onLoad();
  }


}