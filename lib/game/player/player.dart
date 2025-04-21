import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../runner_game.dart';
import '../obstacle.dart';
import 'player_physics_controller.dart';
import 'player_animation_controller.dart';
import 'player_collision_handler.dart';

class Player extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<RunnerGame> {
  final _physics = PlayerPhysicsController();
  final _animator = PlayerAnimationController();
  final _collisions = PlayerCollisionHandler();

  Player() : super(size: Vector2(80, 80), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    _physics.setStartPosition(this);
    _physics.addHitbox(this);
    await _animator.loadAnimations(this);
    animation = _animator.runAnimation;
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (gameRef.isGameOver) return;

    _physics.apply(this, dt);
    _animator.update(this, _physics.velocityY, _physics.isOnGround);
  }

  void jump() {
    if (_physics.jump()) {
      _animator.setJump();
    }
  }

  void reset() {
    _physics.reset(this);
    animation = _animator.runAnimation;
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    _collisions.handleCollision(this, other);
  }
}
