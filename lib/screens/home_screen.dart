import 'package:flutter/material.dart';
import '../services/auth/auth_service.dart';
import 'package:bb_pirates/screens/widgets/home/home_portrait.dart';
import 'package:bb_pirates/screens/widgets/home/home_landscape.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
          final backgroundImage = isPortrait
              ? 'assets/images/home_bg_portrait.png'
              : 'assets/images/home_bg_landscape.png';

          return SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: Stack(
              children: [
                // Full-screen background
                Positioned.fill(
                  child: Image.asset(
                    backgroundImage,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                ),

                // Foreground layout wrapped in SafeArea
                SafeArea(
                  child: Center( // 👈 ensures it's centered regardless of screen size
                    child: isPortrait
                        ? HomePortraitLayout(authService: _authService)
                        : HomeLandscapeLayout(authService: _authService),
                  ),
                ),

              ],
            ),
          );
        },
      ),
    );
  }
}
