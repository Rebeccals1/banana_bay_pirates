// lib/widgets/animated_logo_header.dart
import 'package:flutter/material.dart';

class AnimatedLogoHeader extends StatefulWidget {
  const AnimatedLogoHeader({super.key});

  @override
  State<AnimatedLogoHeader> createState() => _AnimatedLogoHeaderState();
}

class _AnimatedLogoHeaderState extends State<AnimatedLogoHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Column(
        children: [
          Image.asset(
            'assets/images/pirate_logo.png',
            height: 200,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}