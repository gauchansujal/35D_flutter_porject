import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_application_1/core/error/failures.dart';
import 'package:flutter_application_1/features/auth/domain/entities/auth_entity.dart';
import 'package:flutter_application_1/features/auth/domain/repositories/auth_repositories.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/register_usecase.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

class FakeAuthEntity extends Fake implements AuthEntity {}

void main() {
  late RegisterUsecase usecase;
  late MockAuthRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeAuthEntity());
  });

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = RegisterUsecase(authRepository: mockRepository);
  });

  const fullName = "Sujal Gauchan";
  const email = "sujal@gmail.com";
  const password = "123456";

  test('should register user successfully', () async {
    // arrange
    when(
      () => mockRepository.register(any()),
    ).thenAnswer((_) async => const Right(true));

    // act
    final result = await usecase(
      const RegisterUsecaseParams(
        fullName: fullName,
        email: email,
        password: password,
      ),
    );

    // assert
    expect(result, const Right(true));

    verify(() => mockRepository.register(any())).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when register fails', () async {
    // arrange
    when(
      () => mockRepository.register(any()),
    ).thenAnswer((_) async => Left(ApiFailure('', message: "Register failed")));

    // act
    final result = await usecase(
      const RegisterUsecaseParams(
        fullName: fullName,
        email: email,
        password: password,
      ),
    );

    // assert
    expect(result.isLeft(), true);
  });
}
