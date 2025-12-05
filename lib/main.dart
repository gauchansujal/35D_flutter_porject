import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/dashboard_screen.dart';
import 'package:flutter_application_1/screen/login_screen.dart';
// import 'package:flutter_application_1/screen/onboarding_screen.dart';
import 'package:flutter_application_1/screen/signup_screen.dart';
import 'package:flutter_application_1/screen/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      title: 'Bike-Rental',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
        '/login': (_) => LoginScreen(),
        // '/onboarding': (_) => OnboardingScreen(),
        '/signup': (_) => SignupScreen(),
        '/dashboard': (_) => DashboardScreen(),
      },
    );
  }
}
