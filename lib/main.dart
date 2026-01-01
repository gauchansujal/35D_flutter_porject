import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/domain/entities/auth_entity_adapter.dart';
import 'package:flutter_application_1/features/dashboard/persentation/pages/dashboard_screen.dart';
import 'package:flutter_application_1/features/auth/presentation/pages/login_pages.dart';
import 'package:flutter_application_1/features/onboarding/presentation/pages/onboarding_pages.dart';
import 'package:flutter_application_1/features/auth/presentation/pages/signup_pages.dart';
import 'package:flutter_application_1/features/splash/presentation/pages/splash_pages.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/themes/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await path_provider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(directory.path);
  Hive.registerAdapter(AuthEntityAdapter());
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
        '/signup': (_) => SignupPage(),
        '/dashboard': (_) => DashboardScreen(),
      },
    );
  }
}
