import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:provider/provider.dart';
import 'package:streamscape/constants.dart';
import 'package:streamscape/providers/connectivity_provider.dart';
import 'package:streamscape/providers/user_provider.dart';
import 'package:streamscape/providers/video_provider.dart';
import 'package:streamscape/routes.dart';
import 'package:streamscape/widgets/internet_connectivity.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
    Gemini.init(apiKey: dotenv.env['GEMINI_API_KEY'] ?? '');
  } catch (e) {
    debugPrint('Error loading .env file: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VideoProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StreamScape',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          secondary: secondaryColor,
        ),
        primaryColor: primaryColor,
        useMaterial3: true,
      ),
      onGenerateRoute: Routes.generateRoute,
      initialRoute: Routes.initial,
      builder: (context, child) {
        return InternetConnectivity(
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child!,
          ),
        );
      },
    );
  }
}
