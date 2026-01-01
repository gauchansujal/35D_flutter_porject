import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/dashboard/dashboard_screen.dart';
import 'package:flutter_application_1/features/auth/presentation/pages/login_pages.dart';
import 'package:flutter_application_1/screen/onboarding_screen.dart';
import 'package:flutter_application_1/features/auth/presentation/pages/signup_pages.dart';
import 'package:flutter_application_1/screen/splash_screen.dart';
import 'app/themes/app.dart';

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
        '/login': (_) => LoginPages(),
        '/onboarding': (_) => OnboardingScreen(),
        '/signup': (_) => SignupPages(),
        '/dashboard': (_) => DashboardScreen(),
      },
    );
  }
}
