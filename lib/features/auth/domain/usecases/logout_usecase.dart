import 'package:dartz/dartz.dart';

import 'package:flutter_application_1/core/error/failures.dart';
import 'package:flutter_application_1/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_application_1/features/auth/domain/repositories/auth_repositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Then the logout provider becomes very clean:
final logoutUsecaseProvider = Provider<LogoutUsecase>((ref) {
  return LogoutUsecase(
    authRepository: ref.watch(authRepositoryProvider),
  );
});
// No parameters needed for logout (just clear session)
class LogoutUsecase {
  final IAuthRepository _authRepository;

  const LogoutUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  /// Calls the repository to log out the current user
  /// Returns:
  /// - Right(true) on successful logout
  /// - Left(Failure) on any error (e.g., network, storage failure)
  Future<Either<Failure, bool>> call() async {
    return await _authRepository.logout();
  }
}
