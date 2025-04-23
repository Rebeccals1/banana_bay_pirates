import 'package:flutter/material.dart';
import 'package:bb_pirates/services/auth/auth_service.dart';
import 'package:bb_pirates/screens/login_screen.dart';

class HomeBottomActions extends StatelessWidget {
  final AuthService authService;

  const HomeBottomActions({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    final isAnonymous = authService.isAnonymous;

    return Column(
      children: [
        if (isAnonymous)
          TextButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Create Account'),
                  content: const Text('Would you like to create an account to save your progress and scores?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Not Now'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        authService.signOut().then((_) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
                          );
                        });
                      },
                      child: const Text('Create Account'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.person_add, color: Colors.white),
            label: const Text('Create Account', style: TextStyle(color: Colors.white)),
          ),
        TextButton.icon(
          onPressed: () async {
            await authService.signOut();
            if (context.mounted) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            }
          },
          icon: const Icon(Icons.logout, color: Colors.white70),
          label: const Text('Sign Out', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
