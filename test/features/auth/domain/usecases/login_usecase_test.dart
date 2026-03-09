import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_application_1/core/error/failures.dart';
import 'package:flutter_application_1/features/auth/domain/entities/auth_entity.dart';
import 'package:flutter_application_1/features/auth/domain/repositories/auth_repositories.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/login_usecase.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late LoginUsecase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = LoginUsecase(authRepository: mockRepository);
  });

  const username = "sujal";
  const password = "123456";

  final authEntity = AuthEntity(
    userId: "1",
    email: "sujal@gmail.com",
    fullName: "Sujal Gauchan",
    password: password,
  );

  test('should login user successfully', () async {
    // arrange
    when(
      () => mockRepository.login(username, password),
    ).thenAnswer((_) async => Right(authEntity));

    // act
    final result = await usecase(
      const LoginUsecaseParams(username: username, password: password),
    );

    // assert
    expect(result, Right(authEntity));

    verify(() => mockRepository.login(username, password)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return Failure when login fails', () async {
    // arrange
    when(
      () => mockRepository.login(username, password),
    ).thenAnswer((_) async => Left(ApiFailure('', message: "Login failed")));

    // act
    final result = await usecase(
      const LoginUsecaseParams(username: username, password: password),
    );

    // assert
    expect(result.isLeft(), true);
  });
}
