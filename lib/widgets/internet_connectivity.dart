import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamscape/providers/connectivity_provider.dart';

class InternetConnectivity extends StatefulWidget {
  final Widget child;

  const InternetConnectivity({super.key, required this.child});

  @override
  State<InternetConnectivity> createState() => _InternetConnectivityState();
}

class _InternetConnectivityState extends State<InternetConnectivity> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(
      builder: (context, connectivityProvider, child) {
        if (!connectivityProvider.isConnected) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wifi_off,
                    size: 100,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'No internet connection',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return widget.child;
      },
    );
  }
}
