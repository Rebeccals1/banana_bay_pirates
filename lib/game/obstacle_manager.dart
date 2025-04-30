import 'package:flame/components.dart';
import 'obstacles/ground_obstacle_spawner.dart';
import 'obstacles/parrot_spawner.dart';
import 'runner_game.dart';

/// ObstacleManager serves as the central controller for all obstacle logic:
/// - ground & air spawn timing
/// - obstacle speed
/// - random proximity logic
/// - air obstacle toggling
class Obstacles extends Component with HasGameReference<RunnerGame> {
  double speed;
  double groundSpawnInterval;
  double airSpawnInterval;
  bool airObstaclesEnabled;
  bool allowCloseGroundObstacles;
  double parrotSpeedMultiplier;

  late final Timer _groundSpawnTimer;
  late final Timer _airSpawnTimer;

  Obstacles({
    required this.speed,
    this.groundSpawnInterval = 1.3,
    this.airSpawnInterval = 10.0,
    this.airObstaclesEnabled = true,
    this.allowCloseGroundObstacles = true,
    this.parrotSpeedMultiplier = 2.0,
  });

  @override
  void onMount() {
    super.onMount();

    _groundSpawnTimer = Timer(groundSpawnInterval, onTick: _spawnGroundObstacle, repeat: true);
    _groundSpawnTimer.start();

    _airSpawnTimer = Timer(airSpawnInterval, onTick: _spawnAirObstacle, repeat: true);
    if (airObstaclesEnabled) {
      _airSpawnTimer.start();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _groundSpawnTimer.update(dt);
    if (airObstaclesEnabled) {
      _airSpawnTimer.update(dt);
    }
  }

  /// Spawns a ground obstacle, optionally allowing tighter groupings
  void _spawnGroundObstacle() {
    GroundObstacleSpawner.spawn(
      game,
      speed,
      allowCloseSpacing: allowCloseGroundObstacles,
    );
  }

  /// Spawns a parrot with an optional speed multiplier
  void _spawnAirObstacle() {
    AirObstacleSpawner.spawn(
      game,
      baseSpeed: speed * parrotSpeedMultiplier,
    );
  }
}
