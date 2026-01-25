import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:flutter_application_1/features/auth/presentation/providers/state/auth_state.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);

    // Show loading during initial load / session restore / any loading
    if (authState.status == AuthStatus.loading ||
        authState.status == AuthStatus.initial) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 24),
            Text(
              'Loading profile...',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      );
    }

    // Show error if something went wrong
    if (authState.status == AuthStatus.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: Colors.redAccent,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                authState.errorMessage ?? 'Something went wrong',
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Not logged in / no user data
    if (authState.status != AuthStatus.authenticated ||
        authState.authEntity == null) {
      return const Center(
        child: Text(
          'Not logged in',
          style: TextStyle(
            color: Colors.redAccent,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    // Logged in → show only full name + profile picture
    final user = authState.authEntity!;

    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 70,
              backgroundColor: Colors.blue.shade700,
              backgroundImage:
                  user.profilePicture != null &&
                          user.profilePicture!.trim().isNotEmpty
                      ? NetworkImage(user.profilePicture!)
                      : null,
              child:
                  user.profilePicture == null ||
                          user.profilePicture!.trim().isEmpty
                      ? const Icon(Icons.person, size: 70, color: Colors.white)
                      : null,
            ),
            const SizedBox(height: 32),
            Text(
              user.fullName,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
