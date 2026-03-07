import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/domain/entities/auth_entity.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/logout_usecase.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/register_usecase.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/uplode_photo_usecase.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:flutter_application_1/features/auth/presentation/providers/state/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authViewModelProvider = NotifierProvider<AuthViewmodel, AuthState>(
  () => AuthViewmodel(),
);

class AuthViewmodel extends Notifier<AuthState> {
  late final RegisterUsecase _registerUsecase;
  late final LoginUsecase _loginUsecase;
  late final UplodePhotoUsecase _uploadPhotoUsecase;
  late final UpdateProfileUsecase _updateProfileUsecase;

  @override
  AuthState build() {
    _registerUsecase = ref.read(registerUsecaseProvider);
    _loginUsecase = ref.read(LoginUsecaseProvider);
    _uploadPhotoUsecase = ref.read(UplodePhotoUsecaseProvider);
    _updateProfileUsecase = ref.read(updateProfileUsecaseProvider);

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

      final userId = prefs.getString('user_id')?.trim();
      final fullName = prefs.getString('user_fullname')?.trim();
      final email = prefs.getString('user_email')?.trim();
      final profilePic = prefs.getString('user_profile_pic')?.trim();

      if (email != null && email.isNotEmpty) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          authEntity: AuthEntity(
            userId: userId,
            fullName: fullName,
            email: email,
            profilePicture: profilePic?.isNotEmpty == true ? profilePic : null,
          ),
          clearErrorMessage: true,
        );
      } else {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          clearAuthEntity: true,
          clearErrorMessage: true,
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Failed to restore session: $e',
      );
    }
  }

  // REGISTER
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
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (isRegistered) => state = state.copyWith(
        status: isRegistered ? AuthStatus.registered : AuthStatus.error,
        errorMessage: isRegistered ? null : 'Registration failed',
        clearErrorMessage: isRegistered,
      ),
    );
  }

  // LOGIN
  Future<void> login({
    required String username,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);

    final params = LoginUsecaseParams(username: username, password: password);
    final result = await _loginUsecase(params);

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (authEntity) async {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          authEntity: authEntity,
          clearErrorMessage: true,
        );

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', authEntity.userId ?? '');
        await prefs.setString('user_fullname', authEntity.fullName ?? '');
        await prefs.setString('user_email', authEntity.email ?? '');
        await prefs.setString(
            'user_profile_pic', authEntity.profilePicture ?? '');
      },
    );
  }

  // LOGOUT
  Future<void> logout() async {
    state = state.copyWith(
      status: AuthStatus.loading,
      clearErrorMessage: true,
    );

    final logoutUsecase = ref.read(logoutUsecaseProvider);
    final result = await logoutUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message ?? 'Failed to logout',
      ),
      (_) async {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          clearAuthEntity: true,
          clearErrorMessage: true,
        );

        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('user_id');
        await prefs.remove('user_fullname');
        await prefs.remove('user_email');
        await prefs.remove('user_profile_pic');
        await prefs.remove('user_phone');
      },
    );
  }

  // UPLOAD PHOTO
  Future<void> uploadPhoto(File photo) async {
    state = state.copyWith(
      status: AuthStatus.loading,
      clearErrorMessage: true,
    );

    final uploadResult = await _uploadPhotoUsecase(photo);

    uploadResult.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message ?? 'Failed to upload photo',
      ),
      (imageName) async {
        final updateResult = await _updateProfileUsecase(
          AuthEntity(localProfilePicturePath: photo.path),
        );

        updateResult.fold(
          (failure) => state = state.copyWith(
            status: AuthStatus.error,
            errorMessage: failure.message ?? 'Failed to update profile',
          ),
          (_) async {
            state = state.copyWith(
              status: AuthStatus.authenticated,
              uploadPhotoName: imageName,
              authEntity: state.authEntity?.copyWith(
                profilePicture: photo.path,
              ),
              clearErrorMessage: true,
            );

            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('user_profile_pic', photo.path);
          },
        );
      },
    );
  }

  // UPDATE TEXT FIELDS
  Future<void> updateProfileInfo({
    String? fullName,
    String? email,
    String? password,
  }) async {
    state = state.copyWith(
      status: AuthStatus.loading,
      clearErrorMessage: true,
    );

    final result = await _updateProfileUsecase(
      AuthEntity(fullName: fullName, email: email, password: password),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message ?? 'Update failed',
      ),
      (_) async {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          authEntity: state.authEntity?.copyWith(
            fullName: fullName ?? state.authEntity?.fullName,
            email: email ?? state.authEntity?.email,
          ),
          clearErrorMessage: true,
        );

        final prefs = await SharedPreferences.getInstance();
        if (fullName != null) await prefs.setString('user_fullname', fullName);
        if (email != null) await prefs.setString('user_email', email);
      },
    );
  }

  // FIX: use clearErrorMessage: true instead of errorMessage: null
  void clearError() {
    state = state.copyWith(clearErrorMessage: true);
  }

  void updateUser(AuthEntity? updatedUser) {
    if (updatedUser == null) {
      state = state.copyWith(clearAuthEntity: true);
    } else {
      state = state.copyWith(authEntity: updatedUser);
    }
  }
}