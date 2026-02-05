import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/utils/snackbar_utils.dart';
import 'package:flutter_application_1/features/profile/domain/usecases/uplode_photo_usecase.dart';
import 'package:flutter_application_1/features/profile/presentation/view_models/profile_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:flutter_application_1/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:flutter_application_1/features/auth/presentation/providers/state/auth_state.dart';

Future<bool> _userSangaPermissionLinuParcha(
  BuildContext context,
  Permission permission,
) async {
  final status = await permission.status;
  if (status.isGranted) {
    return true;
  }
  if (status.isDenied) {
    final result = await permission.request();
    return result.isGranted;
  }
  if (status.isPermanentlyDenied) {
    _showPermissionDialog(context);
    return false;
  }
  return false;
}

void _showPermissionDialog(BuildContext context) {
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text('premission denied'),
          content: Text(
            "yo features use gerna lai permission setting ma janu hola",
          ),
          actions: [
            TextButton(onPressed: () {}, child: Text('cancle')),
            TextButton(onPressed: () {}, child: Text('open settings')),
          ],
        ),
  );
}

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final List<XFile> _selectedmedia = [];
  final ImagePicker _imagePicker = ImagePicker();
  bool _isPicking = false;

  Future<void> _cameraBataKhicha() async {
    final hashPermission = await _userSangaPermissionLinuParcha(
      context,
      Permission.camera,
    );
    if (!hashPermission) return;

    final XFile? photo = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (photo != null) {
      setState(() {
        _selectedmedia.clear();
        _selectedmedia.add(photo);
      });
      // upload image to server automatically
      await ref
          .read(authViewModelProvider.notifier)
          .uploadPhoto(File(photo.path));
    }
  }

  // Returns a permanent File that won't be deleted
  Future<File> saveImagePermanently(XFile pickedImage) async {
    try {
      // Get permanent app directory
      final appDir = await getApplicationDocumentsDirectory();

      // Create a subfolder for profile pictures (optional but cleaner)
      final profileDir = Directory('${appDir.path}/profile_pictures');
      if (!await profileDir.exists()) {
        await profileDir.create(recursive: true);
      }

      // Use original name or generate unique name
      final String fileName =
          pickedImage.name.isNotEmpty
              ? pickedImage.name
              : 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';

      final File permanentFile = File('${profileDir.path}/$fileName');

      // Copy the image from temp to permanent location
      await File(pickedImage.path).copy(permanentFile.path);

      // Optional: delete the temporary file to save space
      // await File(pickedImage.path).delete();

      return permanentFile;
    } catch (e) {
      print("Error saving image permanently: $e");
      rethrow;
    }
  }

  Future<void> _pickFromGallery({bool allowMultiple = false}) async {
    try {
      if (allowMultiple) {
        final List<XFile>? images = await _imagePicker.pickMultiImage(
          imageQuality: 80,
        );
        if (images != null && images.isNotEmpty) {
          // For simplicity we take first image
          final permanentFile = await saveImagePermanently(images.first);

          setState(() {
            _selectedmedia.clear();
            _selectedmedia.add(XFile(permanentFile.path));
          });

          await ref
              .read(authViewModelProvider.notifier)
              .uploadPhoto(permanentFile); // ← use permanent file
        }
      } else {
        final XFile? image = await _imagePicker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 80,
        );
        if (image != null) {
          final permanentFile = await saveImagePermanently(image);

          setState(() {
            _selectedmedia.clear();
            _selectedmedia.add(XFile(permanentFile.path));
          });

          await ref
              .read(authViewModelProvider.notifier)
              .uploadPhoto(permanentFile);
        }
      }
    } catch (e) {
      debugPrint('gallery error: $e');
      SnackbarUtils.showError(context, 'Failed to pick image from gallery');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final authState = ref.watch(authViewModelProvider);

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

        final user = authState.authEntity!;

        return SafeArea(
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.blue.shade700,
                      child:
                          _selectedmedia.isNotEmpty
                              ? ClipOval(
                                child: Image.file(
                                  File(_selectedmedia.first.path),
                                  fit: BoxFit.cover,
                                  width: 140,
                                  height: 140,
                                  errorBuilder:
                                      (context, error, stack) => const Icon(
                                        Icons.error,
                                        color: Colors.red,
                                        size: 50,
                                      ),
                                ),
                              )
                              : (user.profilePicture != null &&
                                  user.profilePicture!.trim().isNotEmpty)
                              ? ClipOval(
                                child: Image.network(
                                  user.profilePicture!,
                                  fit: BoxFit.cover,
                                  width: 140,
                                  height: 140,
                                  loadingBuilder: (
                                    context,
                                    child,
                                    loadingProgress,
                                  ) {
                                    if (loadingProgress == null) return child;
                                    return const CircularProgressIndicator();
                                  },
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          const Icon(
                                            Icons.person,
                                            size: 70,
                                            color: Colors.white,
                                          ),
                                ),
                              )
                              : const Icon(
                                Icons.person,
                                size: 70,
                                color: Colors.white,
                              ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      user.fullName ?? '',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _pickFromGallery,
                          icon: const Icon(Icons.photo_camera),
                          label: const Text("Upload Photo"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        ElevatedButton.icon(
                          onPressed: _cameraBataKhicha,
                          icon: const Icon(Icons.camera_alt),
                          label: const Text("Take Photo"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal.shade600,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Implement video upload
                          },
                          icon: const Icon(Icons.videocam),
                          label: const Text("Upload Video"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple.shade700,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
