import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HeaderWidget extends ConsumerWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final user = authState.authEntity;

    const String baseUrl = 'http://10.0.2.2:5000';

    final profilePicPath = user?.profilePicture;
    final fullImageUrl =
        (profilePicPath != null && profilePicPath.isNotEmpty)
            ? '$baseUrl$profilePicPath'
            : null;

    // Extract first name only for a cleaner greeting
    final firstName = user?.fullName?.split(' ').first ?? 'User';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF3B4EFF), Color(0xFF1B2B8F)],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ── Left: greeting ──────────────────────────────────
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.pedal_bike, color: Colors.white, size: 28),
              const SizedBox(height: 6),
              Text(
                "Hello, $firstName 👋",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          // ── Right: tappable avatar ───────────────────────────
          GestureDetector(
            onTap: () {
              if (fullImageUrl != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => _FullScreenImageViewer(imageUrl: fullImageUrl),
                  ),
                );
              }
            },
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 24,
              backgroundImage:
                  fullImageUrl != null ? NetworkImage(fullImageUrl) : null,
              child:
                  fullImageUrl == null
                      ? const Icon(
                        Icons.person,
                        color: Colors.black54,
                        size: 28,
                      )
                      : null,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Full-Screen Image Viewer ────────────────────────────────────────────────

class _FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;

  const _FullScreenImageViewer({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Profile Picture',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.8,
          maxScale: 4.0,
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value:
                      loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                  color: Colors.white,
                ),
              );
            },
            errorBuilder:
                (context, error, stackTrace) => const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.broken_image, color: Colors.white54, size: 64),
                    SizedBox(height: 12),
                    Text(
                      'Could not load image',
                      style: TextStyle(color: Colors.white54),
                    ),
                  ],
                ),
          ),
        ),
      ),
    );
  }
}
