import 'package:flutter/material.dart';
import '../../../services/auth/auth_service.dart';

class HomeUserProfile extends StatelessWidget {
  final AuthService authService;

  const HomeUserProfile({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    final userName = authService.userName;
    final isAnonymous = authService.isAnonymous;
    final isGuest = authService.isGuest;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isAnonymous || isGuest)
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Create an account to appear on the leaderboard!',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.6, red: 0, blue: 0, green: 0),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundColor: isAnonymous ? Colors.blue : Colors.white,
                radius: 20,
                child: Text(
                  userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isAnonymous ? Colors.white : Colors.deepPurple,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, $userName!',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (isAnonymous)
                    const Text(
                      'Playing as Guest',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

}
