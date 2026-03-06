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

  bool _isEditing = false;

  static const String _baseUrl = 'http://10.0.2.2:5000';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _prefillFields();

      ref.listenManual(authViewModelProvider, (previous, next) {
        if (!mounted) return;

        if (next.status == AuthStatus.error && next.errorMessage != null) {
          SnackbarUtils.showError(context, next.errorMessage!);
          ref.read(authViewModelProvider.notifier).clearError();
        }

        if (previous?.status == AuthStatus.loading &&
            next.status == AuthStatus.authenticated) {
          SnackbarUtils.showSuccess(context, 'Profile updated successfully!');
          setState(() {
            _selectedImage = null;
            _isEditing = false;
          });
          _prefillFields();
        }
      });
    });
  }

  void _prefillFields() {
    final user = ref.read(authViewModelProvider).authEntity;
    if (user != null) {
      _fullNameController.text = user.fullName ?? '';
      _emailController.text = user.email ?? '';
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
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

    final user = ref.read(authViewModelProvider).authEntity;

    // Only send fields that actually changed
    final newFullName = fullName != (user?.fullName ?? '') ? fullName : null;
    final newEmail = email != (user?.email ?? '') ? email : null;

    // Nothing changed — just exit edit mode
    if (newFullName == null && newEmail == null) {
      setState(() => _isEditing = false);
      return;
    }

    await ref
        .read(authViewModelProvider.notifier)
        .updateProfileInfo(fullName: newFullName, email: newEmail);
  }

  void _cancelEdit() {
    _prefillFields();
    setState(() => _isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    // ── Loading ──────────────────────────────────────────────────────────
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

    // ── Not logged in ────────────────────────────────────────────────────
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

    // ✅ Build full image URL from server path
    final profilePicPath = user.profilePicture;
    final fullImageUrl =
        (profilePicPath != null && profilePicPath.isNotEmpty)
            ? '$_baseUrl$profilePicPath'
            : null;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Avatar ─────────────────────────────────────────────────
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.blue.shade700,
                  backgroundImage:
                      _selectedImage != null
                          ? FileImage(_selectedImage!) as ImageProvider
                          : fullImageUrl != null
                          ? NetworkImage(fullImageUrl)
                          : null,
                  child:
                      (_selectedImage == null && fullImageUrl == null)
                          ? const Icon(
                            Icons.person,
                            size: 55,
                            color: Colors.white,
                          )
                          : null,
                ),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade400,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ── Name + email under avatar ───────────────────────────────
            Text(
              user.fullName?.isNotEmpty == true ? user.fullName! : 'User',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              user.email ?? '',
              style: const TextStyle(color: Colors.white54, fontSize: 14),
            ),

            const SizedBox(height: 32),

            // ── Header Row ──────────────────────────────────────────────
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
                  onPressed:
                      authState.status == AuthStatus.loading
                          ? null
                          : () =>
                              _isEditing
                                  ? _saveProfile()
                                  : setState(() => _isEditing = true),
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

            // ── Full Name ───────────────────────────────────────────────
            ProfileFieldWidget(
              label: 'Full Name',
              controller: _fullNameController,
              icon: Icons.person_outline,
              enabled: _isEditing,
            ),

            const SizedBox(height: 16),

            // ── Email ───────────────────────────────────────────────────
            ProfileFieldWidget(
              label: 'Email',
              controller: _emailController,
              icon: Icons.email_outlined,
              enabled: _isEditing,
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 32),

            // ── Action Buttons ──────────────────────────────────────────
            if (_isEditing) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed:
                      authState.status == AuthStatus.loading
                          ? null
                          : _saveProfile,
                  icon: const Icon(Icons.save),
                  label: const Text('Save Changes'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _cancelEdit,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white70,
                    side: const BorderSide(color: Colors.white30),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
