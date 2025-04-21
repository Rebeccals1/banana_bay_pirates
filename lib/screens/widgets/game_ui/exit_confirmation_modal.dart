import 'package:flutter/material.dart';

Future<bool?> showExitConfirmationModal(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Quit Game?'),
      content: const Text('Are you sure you want to quit? Your progress will be lost.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('No')),
        TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Yes')),
      ],
    ),
  );
}
