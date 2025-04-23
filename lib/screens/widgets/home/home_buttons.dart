import 'package:flutter/material.dart';
import '../../../services/auth/auth_service.dart';
import 'package:bb_pirates/screens/game_screen.dart';
import 'package:bb_pirates/screens/leaderboard_screen.dart';
import 'package:bb_pirates/screens/settings_screen.dart';
import 'dart:io';

class HomeMainButtons extends StatelessWidget {
  final AuthService authService;

  const HomeMainButtons({super.key, required this.authService});

  static const double _fontSize = 12;
  static const double _buttonWidth = 180;
  static const EdgeInsets _buttonPadding = EdgeInsets.symmetric(horizontal: 20, vertical: 10);

  @override
  Widget build(BuildContext context) {
    final userName = authService.userName;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildFixedWidthButton(
          context: context,
          label: 'PLAY',
          color: Colors.green,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => GameScreen(playerName: userName)),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildFixedWidthButton(
          context: context,
          label: 'LEADERBOARD',
          color: Colors.black54,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const LeaderboardScreen()),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildFixedWidthButton(
          context: context,
          label: 'SETTINGS',
          color: Colors.black54,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => SettingsScreen(authService: authService)),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildFixedWidthButton(
          context: context,
          label: 'EXIT',
          color: Colors.black54,
          onPressed: () => exit(0),
        ),
      ],
    );
  }

  Widget _buildFixedWidthButton({
    required BuildContext context,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: _buttonWidth,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: _buttonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: _fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
