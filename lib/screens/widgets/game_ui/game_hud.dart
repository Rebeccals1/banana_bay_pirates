import 'package:flutter/material.dart';

class GameHUD extends StatelessWidget {
  final String playerName;
  final VoidCallback onPause;
  final VoidCallback onExit;

  const GameHUD({
    super.key,
    required this.playerName,
    required this.onPause,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _infoBox(),
        _circleIcon(icon: Icons.pause, onTap: onPause, rightOffset: 80),
        _circleIcon(icon: Icons.close, onTap: onExit, rightOffset: 20),
      ],
    );
  }

  Widget _infoBox() {
    return Positioned(
      top: 40,
      left: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          'Player: $playerName',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _circleIcon({required IconData icon, required VoidCallback onTap, required double rightOffset}) {
    return Positioned(
      top: 40,
      right: rightOffset,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
      ),
    );
  }
}
