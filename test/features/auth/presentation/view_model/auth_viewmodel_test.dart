import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/error/failures.dart';
import 'package:flutter_application_1/features/auth/domain/entities/auth_entity.dart';
import 'package:flutter_application_1/features/auth/domain/repositories/auth_repositories.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/logout_usecase.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/register_usecase.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/uplode_photo_usecase.dart';
import 'package:flutter_application_1/features/auth/presentation/providers/state/auth_state.dart';
import 'package:flutter_application_1/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── Stub repository (satisfies constructor, never called) ─────────────────────
class _StubAuthRepository implements IAuthRepository {
  @override
  dynamic noSuchMethod(Invocation i) =>
      throw UnimplementedError(i.memberName.toString());
}

// ── Fake usecases ─────────────────────────────────────────────────────────────

class FakeRegisterUsecase extends RegisterUsecase {
  Either<Failure, bool> result = Right(true);
  FakeRegisterUsecase() : super(authRepository: _StubAuthRepository());

  @override
  Future<Either<Failure, bool>> call(RegisterUsecaseParams params) async =>
      result;
}

class FakeLoginUsecase extends LoginUsecase {
  Either<Failure, AuthEntity> result = Right(
    AuthEntity(fullName: 'John', email: 'john@example.com'),
  );
  FakeLoginUsecase() : super(authRepository: _StubAuthRepository());

  @override
  Future<Either<Failure, AuthEntity>> call(LoginUsecaseParams params) async =>
      result;
}

class FakeLogoutUsecase extends LogoutUsecase {
  Either<Failure, bool> result = Right(true);
  FakeLogoutUsecase() : super(authRepository: _StubAuthRepository());

  @override
  Future<Either<Failure, bool>> call() async => result;
}

class FakeUploadPhotoUsecase extends UplodePhotoUsecase {
  Either<Failure, String> result = Right('photo.jpg');
  FakeUploadPhotoUsecase() : super(repository: _StubAuthRepository());

  @override
  Future<Either<Failure, String>> call(File params) async => result;
}

class FakeUpdateProfileUsecase extends UpdateProfileUsecase {
  Either<Failure, bool> result = Right(true);
  FakeUpdateProfileUsecase() : super(repository: _StubAuthRepository());

  @override
  Future<Either<Failure, bool>> call(AuthEntity profile) async => result;
}

// ── Shared helpers ────────────────────────────────────────────────────────────

final tFailure = ApiFailure(message: 'Something went wrong');

ProviderContainer makeContainer({
  FakeRegisterUsecase? register,
  FakeLoginUsecase? login,
  FakeLogoutUsecase? logout,
  FakeUploadPhotoUsecase? upload,
  FakeUpdateProfileUsecase? update,
}) {
  return ProviderContainer(
    overrides: [
      registerUsecaseProvider.overrideWithValue(
        register ?? FakeRegisterUsecase(),
      ),
      LoginUsecaseProvider.overrideWithValue(login ?? FakeLoginUsecase()),
      logoutUsecaseProvider.overrideWithValue(logout ?? FakeLogoutUsecase()),
      UplodePhotoUsecaseProvider.overrideWithValue(
        upload ?? FakeUploadPhotoUsecase(),
      ),
      updateProfileUsecaseProvider.overrideWithValue(
        update ?? FakeUpdateProfileUsecase(),
      ),
    ],
  );
}

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });

  // ── REGISTER ──────────────────────────────────────────────────────────────
  group('register', () {
    test('emits registered on success', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      await container
          .read(authViewModelProvider.notifier)
          .register(
            fullName: 'John',
            email: 'john@example.com',
            userName: 'john',
            password: '123456',
          );

      expect(
        container.read(authViewModelProvider).status,
        AuthStatus.registered,
      );
    });

    test('emits error when usecase returns false', () async {
      final container = makeContainer(
        register: FakeRegisterUsecase()..result = Right(false),
      );
      addTearDown(container.dispose);

      await container
          .read(authViewModelProvider.notifier)
          .register(
            fullName: 'John',
            email: 'john@example.com',
            userName: 'john',
            password: '123456',
          );

      final s = container.read(authViewModelProvider);
      expect(s.status, AuthStatus.error);
      expect(s.errorMessage, 'Registration failed');
    });

    test('emits error on failure', () async {
      final container = makeContainer(
        register: FakeRegisterUsecase()..result = Left(tFailure),
      );
      addTearDown(container.dispose);

      await container
          .read(authViewModelProvider.notifier)
          .register(
            fullName: 'John',
            email: 'john@example.com',
            userName: 'john',
            password: '123456',
          );

      final s = container.read(authViewModelProvider);
      expect(s.status, AuthStatus.error);
      expect(s.errorMessage, tFailure.message);
    });
  });

  // ── LOGIN ─────────────────────────────────────────────────────────────────
  group('login', () {
    test('emits authenticated and persists session on success', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      await container
          .read(authViewModelProvider.notifier)
          .login(username: 'john@example.com', password: '123456');

      final s = container.read(authViewModelProvider);
      expect(s.status, AuthStatus.authenticated);
      expect(s.authEntity?.email, 'john@example.com');

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('user_email'), 'john@example.com');
    });

    test('emits error on failure', () async {
      final container = makeContainer(
        login: FakeLoginUsecase()..result = Left(tFailure),
      );
      addTearDown(container.dispose);

      await container
          .read(authViewModelProvider.notifier)
          .login(username: 'bad', password: 'bad');

      final s = container.read(authViewModelProvider);
      expect(s.status, AuthStatus.error);
      expect(s.errorMessage, tFailure.message);
    });
  });

  // ── LOGOUT ────────────────────────────────────────────────────────────────
  group('logout', () {
    test('emits unauthenticated and clears session on success', () async {
      SharedPreferences.setMockInitialValues({
        'user_fullname': 'John',
        'user_email': 'john@example.com',
      });
      final container = makeContainer();
      addTearDown(container.dispose);

      await container.read(authViewModelProvider.notifier).logout();

      final s = container.read(authViewModelProvider);
      expect(s.status, AuthStatus.unauthenticated);
      expect(s.authEntity, isNull);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('user_fullname'), isNull);
      expect(prefs.getString('user_email'), isNull);
    });

    test('emits error on failure', () async {
      final container = makeContainer(
        logout: FakeLogoutUsecase()..result = Left(tFailure),
      );
      addTearDown(container.dispose);

      await container.read(authViewModelProvider.notifier).logout();

      final s = container.read(authViewModelProvider);
      expect(s.status, AuthStatus.error);
      expect(s.errorMessage, tFailure.message);
    });
  });

  // ── UPLOAD PHOTO ──────────────────────────────────────────────────────────
  group('uploadPhoto', () {
    final tFile = File('test/assets/test_image.jpg');

    test(
      'emits authenticated and persists photo path on full success',
      () async {
        final container = makeContainer();
        addTearDown(container.dispose);

        await container.read(authViewModelProvider.notifier).uploadPhoto(tFile);

        final s = container.read(authViewModelProvider);
        expect(s.status, AuthStatus.authenticated);
        expect(s.uploadPhotoName, 'photo.jpg');

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('user_profile_pic'), tFile.path);
      },
    );

    test(
      'emits error and never reaches updateProfile when upload fails',
      () async {
        final container = makeContainer(
          upload: FakeUploadPhotoUsecase()..result = Left(tFailure),
          // if update were reached its different message would fail the assertion
          update:
              FakeUpdateProfileUsecase()
                ..result = Left(ApiFailure(message: 'Should not be called')),
        );
        addTearDown(container.dispose);

        await container.read(authViewModelProvider.notifier).uploadPhoto(tFile);

        final s = container.read(authViewModelProvider);
        expect(s.status, AuthStatus.error);
        expect(s.errorMessage, tFailure.message);
      },
    );

    test(
      'emits error when updateProfile fails after successful upload',
      () async {
        final container = makeContainer(
          update: FakeUpdateProfileUsecase()..result = Left(tFailure),
        );
        addTearDown(container.dispose);

        await container.read(authViewModelProvider.notifier).uploadPhoto(tFile);

        final s = container.read(authViewModelProvider);
        expect(s.status, AuthStatus.error);
        expect(s.errorMessage, tFailure.message);
      },
    );
  });

  // ── UPDATE PROFILE INFO ───────────────────────────────────────────────────
  group('updateProfileInfo', () {
    test(
      'emits authenticated and persists updated fields on success',
      () async {
        final container = makeContainer();
        addTearDown(container.dispose);

        await container
            .read(authViewModelProvider.notifier)
            .updateProfileInfo(fullName: 'Jane', email: 'jane@example.com');

        final s = container.read(authViewModelProvider);
        expect(s.status, AuthStatus.authenticated);

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('user_fullname'), 'Jane');
        expect(prefs.getString('user_email'), 'jane@example.com');
      },
    );

    test('does not overwrite prefs for null fields', () async {
      SharedPreferences.setMockInitialValues({'user_fullname': 'John'});
      final container = makeContainer();
      addTearDown(container.dispose);

      await container
          .read(authViewModelProvider.notifier)
          .updateProfileInfo(email: 'new@example.com');

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('user_fullname'), 'John'); // untouched
      expect(prefs.getString('user_email'), 'new@example.com');
    });

    test('emits error on failure', () async {
      final container = makeContainer(
        update: FakeUpdateProfileUsecase()..result = Left(tFailure),
      );
      addTearDown(container.dispose);

      await container
          .read(authViewModelProvider.notifier)
          .updateProfileInfo(fullName: 'Fail');

      final s = container.read(authViewModelProvider);
      expect(s.status, AuthStatus.error);
      expect(s.errorMessage, tFailure.message);
    });
  });

  // ── CLEAR ERROR ───────────────────────────────────────────────────────────
  group('clearError', () {
    test('removes errorMessage from state', () async {
      final container = makeContainer(
        login: FakeLoginUsecase()..result = Left(tFailure),
      );
      addTearDown(container.dispose);

      await container
          .read(authViewModelProvider.notifier)
          .login(username: 'x', password: 'y');

      expect(container.read(authViewModelProvider).errorMessage, isNotNull);

      container.read(authViewModelProvider.notifier).clearError();

      expect(container.read(authViewModelProvider).errorMessage, isNull);
    });
  });

  // ── UPDATE USER ───────────────────────────────────────────────────────────
  group('updateUser', () {
    final tUser = AuthEntity(fullName: 'Alice', email: 'alice@example.com');

    test('replaces authEntity in state', () {
      final container = makeContainer();
      addTearDown(container.dispose);

      container.read(authViewModelProvider.notifier).updateUser(tUser);

      expect(container.read(authViewModelProvider).authEntity, tUser);
    });

    test('sets authEntity to null', () {
      final container = makeContainer();
      addTearDown(container.dispose);

      container.read(authViewModelProvider.notifier).updateUser(null);

      expect(container.read(authViewModelProvider).authEntity, isNull);
    });
  });
}
