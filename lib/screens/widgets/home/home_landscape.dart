import 'package:flutter/material.dart';
import '../../../services/auth/auth_service.dart';
import '../../widgets/home/home_header.dart';
import '../login/animated_logo_header.dart';
import 'home_profile.dart';
import 'home_buttons.dart';
import 'home_bottom_actions.dart';

class HomeLandscapeLayout extends StatelessWidget {
  final AuthService authService;

  const HomeLandscapeLayout({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AnimatedLogoHeader(),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              HomeUserProfile(authService: authService),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HomeMainButtons(authService: authService),
                const SizedBox(height: 20),
                HomeBottomActions(authService: authService),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
