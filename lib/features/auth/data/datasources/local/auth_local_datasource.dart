import 'package:hive_flutter/hive_flutter.dart';
import '../../../domain/entities/auth_entity.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUser(AuthEntity user);
  Future<bool> checkUserExists(String email);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String _boxName = 'users';

  @override
  Future<void> saveUser(AuthEntity user) async {
    final box = await Hive.openBox<AuthEntity>(_boxName);
    await box.put(user.email, user);
  }

  @override
  Future<bool> checkUserExists(String email) async {
    final box = await Hive.openBox<AuthEntity>(_boxName);
    return box.containsKey(email);
  }
}
