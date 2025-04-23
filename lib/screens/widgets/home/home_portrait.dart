import 'package:flutter/material.dart';
import '../../../services/auth/auth_service.dart';
import '../../widgets/home/home_profile.dart';
import '../../widgets/home/home_buttons.dart';
import 'home_bottom_actions.dart';
import '../login/animated_logo_header.dart';

class HomePortraitLayout extends StatelessWidget {
  final AuthService authService;

  const HomePortraitLayout({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 5.0),
                    child: AnimatedLogoHeader(),
                  ),
                  const SizedBox(height: 5),
                  HomeUserProfile(authService: authService),
                  const SizedBox(height: 20),
                  HomeMainButtons(authService: authService),
                  const SizedBox(height: 20),
                  HomeBottomActions(authService: authService),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

