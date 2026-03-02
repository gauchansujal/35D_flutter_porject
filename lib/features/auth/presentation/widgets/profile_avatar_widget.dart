import 'dart:io';
import 'package:flutter/material.dart';

class ProfileAvatarWidget extends StatelessWidget {
  final File? selectedImage;
  final String? networkImageUrl;
  final VoidCallback onTap;

  const ProfileAvatarWidget({
    super.key,
    this.selectedImage,
    this.networkImageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 70,
          backgroundColor: Colors.blue.shade700,
          child: _buildImage(),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade700,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildImage() {
    // 1. Show local file first (just picked)
    if (selectedImage != null) {
      return ClipOval(
        child: Image.file(
          selectedImage!,
          fit: BoxFit.cover,
          width: 140,
          height: 140,
          errorBuilder: (_, __, ___) => const Icon(
            Icons.error,
            color: Colors.red,
            size: 50,
          ),
        ),
      );
    }

    // 2. Show server image
    if (networkImageUrl != null && networkImageUrl!.trim().isNotEmpty) {
      return ClipOval(
        child: Image.network(
          networkImageUrl!,
          fit: BoxFit.cover,
          width: 140,
          height: 140,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const CircularProgressIndicator();
          },
          errorBuilder: (_, __, ___) => const Icon(
            Icons.person,
            size: 70,
            color: Colors.white,
          ),
        ),
      );
    }

    // 3. Default icon
    return const Icon(Icons.person, size: 70, color: Colors.white);
  }
}