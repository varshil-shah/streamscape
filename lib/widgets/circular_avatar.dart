import 'package:flutter/material.dart';

class CircularAvatar extends StatelessWidget {
  final String displayName;
  const CircularAvatar({super.key, required this.displayName});

  @override
  Widget build(BuildContext context) {
    final List<String> nameParts = displayName.split(' ');

    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.secondary,
      ),
      child: Center(
        child: Text(
          nameParts[0][0] + nameParts[1][0],
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
