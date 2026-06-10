import 'package:flutter/material.dart';

import 'core/theme/theme.dart';
import 'screens/splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const WomenSafetyApp());
}

class WomenSafetyApp extends StatelessWidget {
  const WomenSafetyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Women Safety Application",
      debugShowCheckedModeBanner: false,

      // Theme setup
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,

      // Start screen
      home: const SplashScreen(),
    );
  }
}