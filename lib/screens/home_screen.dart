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
      body: OrientationBuilder(
        builder: (context, orientation) {
          final isPortrait = orientation == Orientation.portrait;
          final backgroundImage = isPortrait
              ? 'assets/images/home_bg_portrait.png'
              : 'assets/images/home_bg_landscape.png';

          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(backgroundImage),
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
            child: SafeArea(
              child: SizedBox.expand(
                child: isPortrait
                    ? HomePortraitLayout(authService: _authService)
                    : HomeLandscapeLayout(authService: _authService),
              ),
            ),
          );
        },
      ),
    );
  }
}
