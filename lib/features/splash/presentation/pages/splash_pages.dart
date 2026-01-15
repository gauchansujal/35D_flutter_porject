import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/dashboard/persentation/pages/dashboard_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

import 'package:flutter_application_1/core/services/storage/user_session_service.dart';

import 'package:flutter_application_1/features/onboarding/presentation/pages/onboarding_pages.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    // Give splash screen some time to be visible (1.8–2.5 seconds feels natural)
    await Future.delayed(const Duration(milliseconds: 1800));

    // Safety check: widget still mounted?
    if (!mounted) return;

    final userSession = ref.read(userSessionServiceProvider);
    final isLoggedIn = userSession.isLoggedIn();

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingPages()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ← you can change to your brand color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            // Optional: Add your app logo here later
            // Image.asset('assets/images/logo.png', height: 120),
            Text(
              'Bike Rental App',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Find your next ride',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 48),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
