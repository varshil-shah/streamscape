import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamscape/providers/user_provider.dart';
import 'package:streamscape/widgets/circular_avatar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

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
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.logout_sharp,
                  size: 30,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
