import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Banana Bay Pirate',
      style: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        fontFamily: 'greatvibes',
        color: Colors.white,
        shadows: [
          Shadow(
            blurRadius: 10.0,
            color: Colors.black45,
            offset: Offset(5.0, 5.0),
          ),
        ],
      ),
    );
  }
}
