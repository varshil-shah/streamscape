import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint("History Screen");

    return const Center(
      child: Text("History Screen", style: TextStyle(fontSize: 20)),
    );
  }
}
