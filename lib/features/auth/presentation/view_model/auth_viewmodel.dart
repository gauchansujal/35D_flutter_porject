import 'dart:io'; // ← required for File

import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/error/failures.dart';
import 'package:flutter_application_1/features/auth/domain/entities/auth_entity.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/logout_usecase.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/register_usecase.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/uplode_photo_usecase.dart';
import 'package:flutter_application_1/features/auth/presentation/providers/state/auth_state.dart';
// note: typo "uplode" – consider renaming to upload
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provider
final authViewModelProvider = NotifierProvider<AuthViewmodel, AuthState>(
  () => AuthViewmodel(),
);

class AuthViewmodel extends Notifier<AuthState> {
  late final RegisterUsecase _registerUsecase;
  late final LoginUsecase _loginUsecase;
  late final UplodePhotoUsecase
  _uploadPhotoUsecase; // renamed variable for clarity

  @override
  AuthState build() {
    _registerUsecase = ref.read(registerUsecaseProvider);
    _loginUsecase = ref.read(LoginUsecaseProvider);
    _uploadPhotoUsecase = ref.read(UplodePhotoUsecaseProvider);

    // Restore session after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tryRestoreSession();
    });

    return AuthState.initial();
  }

  Future<void> _tryRestoreSession() async {
    if (state.status != AuthStatus.initial) return;

    state = state.copyWith(status: AuthStatus.loading);

    try {
      final prefs = await SharedPreferences.getInstance();

      final fullName = prefs.getString('user_fullname')?.trim();
      final email = prefs.getString('user_email')?.trim();
      final profilePic = prefs.getString('user_profile_pic')?.trim();
      // final phone = prefs.getString('user_phone')?.trim();

      if (fullName != null &&
          fullName.isNotEmpty &&
          email != null &&
          email.isNotEmpty) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          authEntity: AuthEntity(
            fullName: fullName,
            email: email,
            profilePicture: profilePic?.isNotEmpty == true ? profilePic : null,
            // phoneNumber: phone?.isNotEmpty == true ? phone : null,
          ),
          errorMessage: null,
        );
      } else {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          authEntity: null,
          errorMessage: null,
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Failed to restore session: $e',
      );
    }
  }

  // REGISTER (unchanged)
  Future<void> register({
    required String fullName,
    required String email,
    String? phoneNumber,
    String? batchId,
    required String userName,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);

    final params = RegisterUsecaseParams(
      fullName: fullName,
      email: email,

      password: password,
    );

    final result = await _registerUsecase(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (isRegistered) {
        state = state.copyWith(
          status: isRegistered ? AuthStatus.registered : AuthStatus.error,
          errorMessage: isRegistered ? null : 'Registration failed',
        );
      },
    );
  }

  // LOGIN (unchanged)
  Future<void> login({
    required String username,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);

    final params = LoginUsecaseParams(username: username, password: password);

    final result = await _loginUsecase(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (authEntity) async {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          authEntity: authEntity,
        );

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_fullname', authEntity.fullName ?? '');
        await prefs.setString('user_email', authEntity.email ?? '');
        await prefs.setString(
          'user_profile_pic',
          authEntity.profilePicture ?? '',
        );
        // await prefs.setString('user_phone', authEntity.phoneNumber ?? '');
      },
    );
  }

  // LOGOUT (unchanged)
  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    final logoutUsecase = ref.read(logoutUsecaseProvider);
    final result = await logoutUsecase();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message ?? 'Failed to logout',
        );
      },
      (_) async {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          authEntity: null,
          errorMessage: null,
        );

        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('user_fullname');
        await prefs.remove('user_email');
        await prefs.remove('user_profile_pic');
        await prefs.remove('user_phone');
      },
    );
  }

  // ── NEW: Upload Photo ────────────────────────────────────────────────
  Future<void> uploadPhoto(File photo) async {
    // Set loading state
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    final result = await _uploadPhotoUsecase(photo);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message ?? 'Failed to upload photo',
        );
      },
      (imageName) {
        // Success: update the auth entity with new profile picture URL
        // final currentUser = state.authEntity;

        // if (currentUser != null) {
        //   final updatedUser = currentUser.copyWith(profilePicture: uploadedUrl);

        // Update state
        state = state.copyWith(
          status: AuthStatus.loading, // or .success if you add it
          uploadPhotoName: imageName,
        );

        // Persist the new profile picture URL
        // final prefs = await SharedPreferences.getInstance();
        // await prefs.setString('user_profile_pic', uploadedUrl);
        // } else {
        //   // Rare case: user not logged in → just show success but no update
        //   state = state.copyWith(
        //     status: AuthStatus.sucess, // add this status if needed
        //     errorMessage: null,
        //   );
        // }
      },
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void updateUser(AuthEntity? updatedUser) {
    state = state.copyWith(authEntity: updatedUser);
  }
}
