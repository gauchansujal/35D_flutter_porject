import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/dashboard/persentation/pages/dashboard_screen.dart';
import 'package:flutter_application_1/features/auth/presentation/pages/login_pages.dart';
import 'package:flutter_application_1/features/onboarding/presentation/pages/onboarding_pages.dart';
import 'package:flutter_application_1/features/auth/presentation/pages/signup_pages.dart';
import 'package:flutter_application_1/features/splash/presentation/pages/splash_pages.dart';

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
      home: SplashPages(),
      routes: {
        '/login': (_) => LoginPages(),
        '/onboarding': (_) => OnboardingPages(),
        '/signup': (_) => SignupPages(),
        '/dashboard': (_) => DashboardScreen(),
      },
    );
  }
}
