import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_application_1/core/error/failures.dart';
import 'package:flutter_application_1/features/auth/domain/repositories/auth_repositories.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/logout_usecase.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late LogoutUsecase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = LogoutUsecase(authRepository: mockRepository);
  });

  test('should logout successfully', () async {
    // arrange
    when(
      () => mockRepository.logout(),
    ).thenAnswer((_) async => const Right(true));

    // act
    final result = await usecase();

    // assert
    expect(result, const Right(true));
    verify(() => mockRepository.logout()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when logout fails', () async {
    // arrange
    when(
      () => mockRepository.logout(),
    ).thenAnswer((_) async => Left(ApiFailure(message: "Logout failed")));

    // act
    final result = await usecase();

    // assert
    expect(result.isLeft(), true);
  });
}
