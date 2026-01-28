import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/utils/snackbar_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

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

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final List<XFile> _selectedmedia = []; // store images and video
  final ImagePicker _imagePicker = ImagePicker();

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
    }
  }

  //code for gallary
  Future<void> _pickFromGallary({bool allowMuiltiple = false}) async {
    try {
      if (allowMuiltiple) {
        final List<XFile>? images = await _imagePicker.pickMultiImage(
          imageQuality: 80,
        );
        if (images != null && images.isNotEmpty) {
          setState(() {
            _selectedmedia.clear();
            _selectedmedia.addAll(images);
          });
        }
      } else {
        final XFile? image = await _imagePicker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 80,
        );
        if (image != null) {
          setState(() {
            setState(() {
              _selectedmedia.clear();
              _selectedmedia.addAll([image]);
            });
          });
        }
      }
    } catch (e) {
      debugPrint('gallery error:$e');
      SnackbarUtils.showError(context, 'failed to pick image from gallary ');
    }
  }

  //code for video

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
                          ? const Icon(
                            Icons.person,
                            size: 70,
                            color: Colors.white,
                          )
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

                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _pickFromGallary,
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
        );
      },
    );
  }
}
