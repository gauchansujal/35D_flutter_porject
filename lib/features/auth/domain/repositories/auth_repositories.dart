import '../entities/auth_entity.dart';

abstract class AuthRepository {
  Future<void> signup(AuthEntity user);
  Future<bool> isEmailTaken(String email);
}
