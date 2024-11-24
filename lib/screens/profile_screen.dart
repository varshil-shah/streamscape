import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamscape/providers/user_provider.dart';
import 'package:streamscape/providers/theme_provider.dart';
import 'package:streamscape/routes.dart';
import 'package:streamscape/services/auth_service.dart';
import 'package:streamscape/widgets/circular_avatar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final AuthService authService = AuthService();
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircularAvatar(displayName: userProvider.user!.displayName),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userProvider.user!.displayName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    userProvider.user!.email,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const Spacer(),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  authService.signout(context);
                  userProvider.clearUser();
                  Navigator.pushReplacementNamed(context, Routes.signin);
                },
                icon: const Icon(
                  Icons.logout_sharp,
                  size: 30,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text(
                "Select Mode",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const Spacer(),
              Switch.adaptive(
                value: themeProvider.isDarkMode,
                onChanged: (_) => themeProvider.toggleTheme(),
                activeColor: Theme.of(context).colorScheme.secondary,
                thumbIcon: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return const Icon(Icons.dark_mode, color: Colors.white);
                  }
                  return const Icon(Icons.light_mode, color: Colors.orange);
                }),
              ),
            ],
          )
        ],
      ),
    );
  }
}
