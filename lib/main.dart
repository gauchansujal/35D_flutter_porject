import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ✅ ADD THIS
import 'package:flutter_application_1/core/sensors/sensor_dashboard_page.dart';
import 'package:flutter_application_1/core/sensors/sensor_wraper.dart';
import 'package:flutter_application_1/core/sensors/sensors_riverpod_provider.dart';
import 'package:flutter_application_1/core/services/storage/user_session_service.dart';
import 'package:flutter_application_1/features/admin/presentation/page/admin_user_page.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:shared_preferences/shared_preferences.dart';

import 'app/themes/app.dart';

// Pages
import 'package:flutter_application_1/features/splash/presentation/pages/splash_pages.dart';
import 'package:flutter_application_1/features/auth/presentation/pages/login_pages.dart';
import 'package:flutter_application_1/features/auth/presentation/pages/signup_pages.dart';
import 'package:flutter_application_1/features/onboarding/presentation/pages/onboarding_pages.dart';
import 'package:flutter_application_1/features/dashboard/persentation/pages/dashboard_screen.dart';

// Hive Model & Constants
import 'package:flutter_application_1/features/auth/data/models/auth_hive_model.dart';
import 'package:flutter_application_1/core/constants/hive_table_constatn.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ ADD THIS - Fixes keyboard issues on physical devices
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  // ✅ ADD THIS - Fixes IME/keyboard cancel issue on physical devices
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);

  if (!Hive.isAdapterRegistered(HiveTableConstant.authTypeId)) {
    Hive.registerAdapter(AuthHiveModelAdapter());
  }

  await Hive.openBox<AuthHiveModel>(HiveTableConstant.authTable);
  await Hive.openBox('app_settings');

  final sharedPref =
      await SharedPreferences.getInstance(); // ✅ fixed variable name

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(sharedPref)],
      child: const MyApp(), // ✅ added const
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(sensorProvider);
    return MaterialApp(
      title: 'Bike-Rental',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // ✅ ADD THIS - critical for keyboard on physical devices
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.noScaling, // prevents font scaling issues
          ),
          child: SensorWrapper(child: child!),
        );
      },
      home: const SplashPage(),
      routes: {
        '/login': (_) => const LoginPages(), // ✅ added const
        '/onboarding': (_) => OnboardingPages(), // ✅ added const
        '/signup': (_) => const SignupPage(), // ✅ added const
        '/dashboard': (_) => const DashboardScreen(), // ✅ added const
        '/sensors': (_) => const SensorDashboardPage(),
        '/admin':      (_) => const AdminUsersPage(), // ✅ ADD

      },
    );
  }
}
