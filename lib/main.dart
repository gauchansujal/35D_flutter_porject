import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'app/themes/app.dart';

// Pages
import 'package:flutter_application_1/features/splash/presentation/pages/splash_pages.dart';
import 'package:flutter_application_1/features/auth/presentation/pages/login_pages.dart';
import 'package:flutter_application_1/features/auth/presentation/pages/signup_pages.dart';
import 'package:flutter_application_1/features/onboarding/presentation/pages/onboarding_pages.dart';
import 'package:flutter_application_1/features/dashboard/persentation/pages/dashboard_screen.dart';

// Hive Model & Constants
import 'package:flutter_application_1/features/auth/data/models/auth_hive_model.dart';
import 'package:flutter_application_1/core/constants/hive_table_constatn.dart'; // For box names

void main() async {
  // Essential: Initialize bindings before async calls
  WidgetsFlutterBinding.ensureInitialized();

  // Get app directory and initialize Hive Flutter
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);

  // Register Hive adapter for AuthHiveModel
  if (!Hive.isAdapterRegistered(HiveTableConstant.authTypeId)) {
    Hive.registerAdapter(AuthHiveModelAdapter());
  }

  // Open required boxes early (better performance + ensures they're ready)
  await Hive.openBox<AuthHiveModel>(
    HiveTableConstant.authTable,
  ); // 'auth_table'
  await Hive.openBox(
    'app_settings',
  ); // For current_user_id, seenOnboarding, etc.

  // Run the app with Riverpod ProviderScope
  runApp(const ProviderScope(child: MyApp()));
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
