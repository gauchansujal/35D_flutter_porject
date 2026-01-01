import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repositories.dart';
import '../datasources/local/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl(this.localDataSource);

  @override
  Future<void> signup(AuthEntity user) async {
    await localDataSource.saveUser(user);
  }

  @override
  Future<bool> isEmailTaken(String email) async {
    return await localDataSource.checkUserExists(email);
  }
}
