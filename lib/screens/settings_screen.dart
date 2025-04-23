import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../services/auth/auth_service.dart';
import 'package:bb_pirates/screens/login_screen.dart';

class SettingsScreen extends StatelessWidget {
  final AuthService authService;

  const SettingsScreen({super.key, required this.authService});

  Future<void> _deleteAccountAndData(BuildContext context) async {
    final user = authService.currentUser;

    if (user == null) return;

    // Prevent deletion if user is a guest
    if (authService.isGuest) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Guests cannot delete accounts.")),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text(
          'Are you sure you want to delete your account? '
              'This will permanently remove your profile and scores.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final uid = user.uid;

      // Delete Firestore documents if they exist
      final playersRef = FirebaseFirestore.instance.collection('players').doc(uid);
      final scoresRef = FirebaseFirestore.instance.collection('scores').doc(uid);

      if ((await playersRef.get()).exists) await playersRef.delete();
      if ((await scoresRef.get()).exists) await scoresRef.delete();

      // Delete Firebase Auth user
      await user.delete();

      // Sign out and navigate to login screen
      await authService.signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting account: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Game Settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Tooltip(
              message: 'Coming soon',
              child: SwitchListTile(
                title: Text(
                  'Sound Effects',
                  style: TextStyle(color: Colors.grey.shade400),
                ),
                value: true,
                onChanged: null, // disables the switch
                activeColor: Colors.grey,
              ),
            ),

            const SizedBox(height: 40),
            const Divider(),
            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () => _deleteAccountAndData(context),
              icon: const Icon(Icons.delete_forever),
              label: const Text('Delete My Account'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
