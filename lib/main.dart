import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/dashboard/dashboard_screen.dart';
import 'package:flutter_application_1/screen/login_screen.dart';
import 'package:flutter_application_1/screen/onboarding_screen.dart';
import 'package:flutter_application_1/screen/signup_screen.dart';
import 'package:flutter_application_1/screen/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bike-Rental',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: SplashScreen(),
      routes: {
        '/login': (_) => LoginScreen(),
        '/onboarding': (_) => OnboardingScreen(),
        '/signup': (_) => SignupScreen(),
        '/dashboard/dashboardscreen': (_) => DashboardScreen(),
      },
    );
  }
}
