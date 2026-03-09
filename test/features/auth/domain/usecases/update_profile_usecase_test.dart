import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/error/failures.dart';
import 'package:flutter_application_1/features/auth/domain/entities/auth_entity.dart';
import 'package:flutter_application_1/features/auth/domain/repositories/auth_repositories.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// ─── Mock ─────────────────────────────────────────────────────────────────────

class MockAuthRepository extends Mock implements IAuthRepository {}

// ─── Fake for registerFallbackValue ───────────────────────────────────────────

class FakeAuthEntity extends Fake implements AuthEntity {}

// ─── Test Data ────────────────────────────────────────────────────────────────

final tProfile = AuthEntity(
  userId: 'user-123',
  email: 'test@example.com',
  fullName: 'Test User',
  password: 'password123',
);

// ─── ApiFailure helper ────────────────────────────────────────────────────────
// ApiFailure(String s, {int? statusCode, required String message})

ApiFailure tApiFailure({String message = 'error', int? statusCode}) =>
    ApiFailure('', statusCode: statusCode, message: message);

void main() {
  late MockAuthRepository mockRepository;
  late UpdateProfileUsecase usecase;

  setUpAll(() {
    registerFallbackValue(FakeAuthEntity());
  });

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = UpdateProfileUsecase(repository: mockRepository);
  });

  // ─── 1. Success ─────────────────────────────────────────────────────────────

  group('Success', () {
    test('returns Right(true) when update succeeds', () async {
      when(
        () => mockRepository.updateProfile(any()),
      ).thenAnswer((_) async => const Right(true));

      final result = await usecase(tProfile);

      expect(result, const Right(true));
    });

    test('calls repository exactly once', () async {
      when(
        () => mockRepository.updateProfile(any()),
      ).thenAnswer((_) async => const Right(true));

      await usecase(tProfile);

      verify(() => mockRepository.updateProfile(tProfile)).called(1);
    });

    test('no extra repository calls are made', () async {
      when(
        () => mockRepository.updateProfile(any()),
      ).thenAnswer((_) async => const Right(true));

      await usecase(tProfile);

      verify(() => mockRepository.updateProfile(tProfile)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });

  // ─── 2. Failure ─────────────────────────────────────────────────────────────

  group('Failure', () {
    test(
      'returns Left(ApiFailure) when repository fails with server error',
      () async {
        when(() => mockRepository.updateProfile(any())).thenAnswer(
          (_) async =>
              Left(tApiFailure(message: 'Server error', statusCode: 500)),
        );

        final result = await usecase(tProfile);

        expect(result.isLeft(), isTrue);
        result.fold((failure) {
          expect(failure, isA<ApiFailure>());
          expect(failure.message, 'Server error');
        }, (_) => fail('Expected Left'));
      },
    );

    test('ApiFailure carries correct statusCode', () async {
      when(() => mockRepository.updateProfile(any())).thenAnswer(
        (_) async => Left(tApiFailure(message: 'Not found', statusCode: 404)),
      );

      final result = await usecase(tProfile);

      result.fold((failure) {
        expect((failure as ApiFailure).statusCode, 404);
      }, (_) => fail('Expected Left'));
    });

    test('returns Left(ApiFailure) without statusCode', () async {
      when(
        () => mockRepository.updateProfile(any()),
      ).thenAnswer((_) async => Left(tApiFailure(message: 'Unknown error')));

      final result = await usecase(tProfile);

      expect(result.isLeft(), isTrue);
      result.fold((failure) {
        expect(failure, isA<ApiFailure>());
        expect((failure as ApiFailure).statusCode, isNull);
      }, (_) => fail('Expected Left'));
    });

    test('returns Left(LocalDatabaseFailure) when local db fails', () async {
      when(() => mockRepository.updateProfile(any())).thenAnswer(
        (_) async => const Left(LocalDatabaseFailure(message: 'DB error')),
      );

      final result = await usecase(tProfile);

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<LocalDatabaseFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('does not return Right when repository fails', () async {
      when(
        () => mockRepository.updateProfile(any()),
      ).thenAnswer((_) async => Left(tApiFailure(message: 'error')));

      final result = await usecase(tProfile);

      expect(result.isRight(), isFalse);
    });
  });

  // ─── 3. Repository Interaction ──────────────────────────────────────────────

  group('Repository interaction', () {
    test('repository called once per usecase call', () async {
      when(
        () => mockRepository.updateProfile(any()),
      ).thenAnswer((_) async => const Right(true));

      await usecase(tProfile);

      verify(() => mockRepository.updateProfile(any())).called(1);
    });

    test('repository never called without explicit usecase call', () async {
      verifyNever(() => mockRepository.updateProfile(any()));
    });

    test('handles multiple different profiles independently', () async {
      final anotherProfile = AuthEntity(
        userId: 'user-456',
        email: 'other@example.com',
        fullName: 'Other User',
      );

      when(
        () => mockRepository.updateProfile(any()),
      ).thenAnswer((_) async => const Right(true));

      await usecase(tProfile);
      await usecase(anotherProfile);

      verify(() => mockRepository.updateProfile(tProfile)).called(1);
      verify(() => mockRepository.updateProfile(anotherProfile)).called(1);
    });
  });

  // ─── 4. Entity Fields ───────────────────────────────────────────────────────

  group('AuthEntity fields', () {
    test('profile with only userId and email is accepted', () async {
      final minimalProfile = AuthEntity(
        userId: 'user-789',
        email: 'minimal@example.com',
      );

      when(
        () => mockRepository.updateProfile(any()),
      ).thenAnswer((_) async => const Right(true));

      final result = await usecase(minimalProfile);

      expect(result, const Right(true));
    });

    test('profile with localProfilePicturePath is passed correctly', () async {
      final profileWithPic = AuthEntity(
        userId: 'user-123',
        email: 'test@example.com',
        fullName: 'Test User',
        localProfilePicturePath: '/local/path/image.jpg',
      );

      when(
        () => mockRepository.updateProfile(any()),
      ).thenAnswer((_) async => const Right(true));

      await usecase(profileWithPic);

      verify(() => mockRepository.updateProfile(profileWithPic)).called(1);
    });

    test('profile with profilePicture URL is passed correctly', () async {
      final profileWithUrl = AuthEntity(
        userId: 'user-123',
        email: 'test@example.com',
        profilePicture: 'https://example.com/pic.jpg',
      );

      when(
        () => mockRepository.updateProfile(any()),
      ).thenAnswer((_) async => const Right(true));

      await usecase(profileWithUrl);

      verify(() => mockRepository.updateProfile(profileWithUrl)).called(1);
    });
  });
}
