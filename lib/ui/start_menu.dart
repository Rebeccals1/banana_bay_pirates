import 'package:flutter/material.dart';

class StartMenu extends StatelessWidget {
  final VoidCallback onStart;

  const StartMenu({required this.onStart, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background
        Container(
          color: Colors.black.withValues(alpha: 0.7), // Semi-transparent background
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Banana Bay Pirates',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onStart, // Calls the function to start the game
                child: const Text('Start Game'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
