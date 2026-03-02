import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/utils/snackbar_utils.dart';
import 'package:flutter_application_1/features/auth/presentation/providers/state/auth_state.dart';
import 'package:flutter_application_1/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:flutter_application_1/features/auth/presentation/widgets/profile_avatar_widget.dart';
import 'package:flutter_application_1/features/auth/presentation/widgets/profile_field_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isEditing = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Pre-fill fields
      final user = ref.read(authViewModelProvider).authEntity;
      if (user != null) {
        _fullNameController.text = user.fullName ?? '';
        _emailController.text = user.email ?? '';
      }

      // Listen for state changes
      ref.listenManual(authViewModelProvider, (previous, next) {
        if (next.status == AuthStatus.error && next.errorMessage != null) {
          SnackbarUtils.showError(context, next.errorMessage!);
          ref.read(authViewModelProvider.notifier).clearError();
        }
        if (next.status == AuthStatus.authenticated &&
            previous?.status == AuthStatus.loading) {
          SnackbarUtils.showSuccess(context, 'Profile updated successfully!');
          setState(() {
            _selectedImage = null;
            _isEditing = false;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() => _selectedImage = File(image.path));
      await ref
          .read(authViewModelProvider.notifier)
          .uploadPhoto(File(image.path));
    }
  }

  Future<void> _saveProfile() async {
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    await ref.read(authViewModelProvider.notifier).updateProfileInfo(
          fullName: fullName.isNotEmpty ? fullName : null,
          email: email.isNotEmpty ? email : null,
          password: password.isNotEmpty ? password : null,
        );
  }

  void _cancelEdit(user) {
    _fullNameController.text = user.fullName ?? '';
    _emailController.text = user.email ?? '';
    _passwordController.clear();
    setState(() => _isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    // ── Loading ────────────────────────────────────────────────────────
    if (authState.status == AuthStatus.loading ||
        authState.status == AuthStatus.initial) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Loading...',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      );
    }

    // ── Not logged in ──────────────────────────────────────────────────
    if (authState.status != AuthStatus.authenticated ||
        authState.authEntity == null) {
      return const Center(
        child: Text(
          'Not logged in',
          style: TextStyle(color: Colors.redAccent, fontSize: 20),
        ),
      );
    }

    final user = authState.authEntity!;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            // ── Avatar ───────────────────────────────────────────────
            ProfileAvatarWidget(
              selectedImage: _selectedImage,
              networkImageUrl: user.profilePicture,
              onTap: _pickImage,
            ),

            const SizedBox(height: 32),

            // ── Header Row ───────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Profile Info',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () =>
                      _isEditing ? _saveProfile() : setState(() => _isEditing = true),
                  icon: Icon(
                    _isEditing ? Icons.save : Icons.edit,
                    color: Colors.blue.shade300,
                  ),
                  label: Text(
                    _isEditing ? 'Save' : 'Edit',
                    style: TextStyle(color: Colors.blue.shade300),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ── Full Name ────────────────────────────────────────────
            ProfileFieldWidget(
              label: 'Full Name',
              controller: _fullNameController,
              icon: Icons.person_outline,
              enabled: _isEditing,
            ),

            const SizedBox(height: 16),

            // ── Email ────────────────────────────────────────────────
            ProfileFieldWidget(
              label: 'Email',
              controller: _emailController,
              icon: Icons.email_outlined,
              enabled: _isEditing,
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 16),

            // ── Password ─────────────────────────────────────────────
            ProfileFieldWidget(
              label: 'New Password',
              controller: _passwordController,
              icon: Icons.lock_outline,
              enabled: _isEditing,
              obscureText: _obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white54,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),

            const SizedBox(height: 16),

            // ── User ID (read-only) ──────────────────────────────────
            ProfileFieldWidget(
              label: 'User ID',
              controller: TextEditingController(text: user.userId ?? '-'),
              icon: Icons.badge_outlined,
              enabled: false,
            ),

            const SizedBox(height: 32),

            // ── Cancel Button ────────────────────────────────────────
            if (_isEditing)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _cancelEdit(user),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white70,
                    side: const BorderSide(color: Colors.white30),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
