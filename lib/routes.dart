import 'package:flutter/material.dart';
import 'package:streamscape/screens/my_videos_screen.dart';
import 'package:streamscape/screens/home_screen.dart';
import 'package:streamscape/screens/main_screen.dart';
import 'package:streamscape/screens/profile_screen.dart';
import 'package:streamscape/screens/search_screen.dart';
import 'package:streamscape/screens/signin_screen.dart';
import 'package:streamscape/screens/signup_screen.dart';
import 'package:streamscape/screens/splash_screen.dart';
import 'package:streamscape/screens/upload_screen.dart';

class Routes {
  static const String initial = "/";
  static const String main = "/main";
  static const String signup = '/signup';
  static const String signin = '/signin';
  static const String home = '/home';
  static const String search = '/search';
  static const String profile = '/profile';
  static const String upload = '/upload';
  static const String history = '/my_videos';
  static const String video = '/video';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initial:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case main:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case signin:
        return MaterialPageRoute(builder: (_) => const SigninScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case search:
        return MaterialPageRoute(builder: (_) => const SearchScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case upload:
        return MaterialPageRoute(builder: (_) => const UploadScreen());
      case history:
        return MaterialPageRoute(builder: (_) => const MyVideosScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
