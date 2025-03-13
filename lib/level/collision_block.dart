import 'package:flame/components.dart';

class CollisionBlock extends PositionComponent{
  bool isPlatform;
  // Take variables from constructor and
  // pass it to our Extends class PositionComponent
  CollisionBlock({position, size, this.isPlatform = false}) : super(position: position, size: size){
    debugMode = true;
  }
}