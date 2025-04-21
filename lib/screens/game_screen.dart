import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../game/runner_game.dart';
import '../screens/widgets/game_ui/game_hud.dart';
import '../screens/widgets/game_ui/pause_menu.dart';
import '../screens/widgets/game_ui/game_over_modal.dart';
import '../screens/widgets/game_ui/exit_confirmation_modal.dart';
import '../services/score/score_service.dart';

class GameScreen extends StatefulWidget {
  final String playerName;

  const GameScreen({super.key, required this.playerName});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late RunnerGame _game;
  final ScoreService _scoreService = ScoreService();
  bool _gameOver = false;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    _game = RunnerGame(
      onGameOver: (score) async {
        await _scoreService.saveScore(score, widget.playerName);
        if (!mounted) return;

        setState(() => _gameOver = true);
        showGameOverModal(
          context: context,
          playerName: widget.playerName,
          score: score,
          onReplay: _resetGame,
        );
      },
    );
  }

  void _resetGame() {
    setState(() {
      _gameOver = false;
      _initializeGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_gameOver,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final shouldExit = await showExitConfirmationModal(context);
        if (shouldExit == true && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            GameWidget(
              game: _game,
              overlayBuilderMap: {
                'PauseOverlay': (_, __) => PauseMenu(game: _game),
              },
            ),
            GameHUD(
              playerName: widget.playerName,
              onPause: () {
                _game.pauseEngine();
                _game.overlays.add('PauseOverlay');
              },
              onExit: () async {
                final shouldExit = await showExitConfirmationModal(context);
                if (shouldExit == true && context.mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
