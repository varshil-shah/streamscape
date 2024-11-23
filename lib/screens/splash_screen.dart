import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamscape/models/user_model.dart';
import 'package:streamscape/providers/user_provider.dart';
import 'package:streamscape/routes.dart';
import 'package:streamscape/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService authService = AuthService();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    checkAuthentication();
  }

  Future<void> checkAuthentication() async {
    User? authenticatedUser = await authService.isAuthenticated();
    setState(() {
      isLoading = false;
    });

    if (!mounted) return;

    if (authenticatedUser != null) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setUser(authenticatedUser);

      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.main,
        (route) => false,
      );
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.signup,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/icons/logo.png',
          width: 300,
        ),
      ),
    );
  }
}
