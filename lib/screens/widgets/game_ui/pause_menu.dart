import 'package:flutter/material.dart';
import 'package:flame/game.dart';

class PauseMenu extends StatelessWidget {
  final Game game;

  const PauseMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          game.overlays.remove('PauseOverlay');
          game.resumeEngine();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.75),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            '⏸️ Game Paused\nTap to Resume',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
