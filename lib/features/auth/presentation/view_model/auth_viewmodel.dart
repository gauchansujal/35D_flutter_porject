import 'package:flutter/material.dart'; // ← added for WidgetsBinding
import 'package:flutter_application_1/core/error/failures.dart';
import 'package:flutter_application_1/features/auth/domain/entities/auth_entity.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/logout_usecase.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/register_usecase.dart';
import 'package:flutter_application_1/features/auth/presentation/providers/state/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provider
final authViewModelProvider = NotifierProvider<AuthViewmodel, AuthState>(
  () => AuthViewmodel(),
);

class AuthViewmodel extends Notifier<AuthState> {
  late final RegisterUsecase _registerUsecase;
  late final LoginUsecase _loginUsecase;

  @override
  AuthState build() {
    _registerUsecase = ref.read(registerUsecaseProvider);
    _loginUsecase = ref.read(
      LoginUsecaseProvider,
    ); // ← fixed casing (was LoginUsecaseProvider)

    // Trigger async restore after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tryRestoreSession();
    });

    return AuthState.initial();
  }

  Future<void> _tryRestoreSession() async {
    // Avoid running multiple times or when already logged in
    if (state.status != AuthStatus.initial) return;

    state = state.copyWith(status: AuthStatus.loading);

    try {
      final prefs = await SharedPreferences.getInstance();

      final fullName = prefs.getString('user_fullname');
      final email = prefs.getString('user_email');
      final profilePic = prefs.getString('user_profile_pic');
      final phone = prefs.getString('user_phone');

      if (fullName != null &&
          fullName.trim().isNotEmpty &&
          email != null &&
          email.trim().isNotEmpty) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          authEntity: AuthEntity(
            fullName: fullName,
            email: email,
            profilePicture:
                profilePic != null && profilePic.trim().isNotEmpty
                    ? profilePic
                    : null,
            phoneNumber:
                phone != null && phone.trim().isNotEmpty ? phone : null,
            // Add other fields (id, username, token, batchId, etc.) if you save them
          ),
          errorMessage: null,
        );
      } else {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          authEntity: null,
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Failed to restore session: $e',
      );
    }
  }

  // ========== REGISTER ==========
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
      phoneNumber: phoneNumber,
      // batchId: batchId,
      // username: userName,
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

  // ========== LOGIN ==========
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
        // SAVE TO SHARED PREFERENCES FOR PERSISTENCE
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_fullname', authEntity.fullName);
        await prefs.setString('user_email', authEntity.email);
        await prefs.setString(
          'user_profile_pic',
          authEntity.profilePicture ?? '',
        );
        await prefs.setString('user_phone', authEntity.phoneNumber ?? '');
      },
    );
  }

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
        // CLEAR SHARED PREFERENCES ON LOGOUT
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('user_fullname');
        await prefs.remove('user_email');
        await prefs.remove('user_profile_pic');
        await prefs.remove('user_phone');
        // await prefs.remove('auth_token'); // if you have token
      },
    );
  }
}
