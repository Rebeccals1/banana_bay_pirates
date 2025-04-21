import 'package:flutter/material.dart';

class GameHUD extends StatelessWidget {
  final String playerName;
  final VoidCallback onPause;

  const GameHUD({
    super.key,
    required this.playerName,
    required this.onPause,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              playerName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.pause, color: Colors.white),
              onPressed: onPause,
              tooltip: 'Pause Game',
            ),
          ],
        ),
      ),
    );
  }
}
