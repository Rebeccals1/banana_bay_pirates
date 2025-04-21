import 'package:flutter/material.dart';

void showGameOverModal({
  required BuildContext context,
  required String playerName,
  required int score,
  required VoidCallback onReplay,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      title: const Text('Game Over'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Player: $playerName'),
          const SizedBox(height: 8),
          Text('Your score: $score'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close dialog
            Navigator.of(context).pop(); // Pop game screen
          },
          child: const Text('Back to Menu'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close dialog
            onReplay();
          },
          child: const Text('Play Again'),
        ),
      ],
    ),
  );
}
