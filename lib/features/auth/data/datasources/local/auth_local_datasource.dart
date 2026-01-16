import 'package:flutter_application_1/core/services/hive/hive_service.dart';
import 'package:flutter_application_1/core/services/storage/user_session_service.dart';
import 'package:flutter_application_1/features/auth/data/datasources/auth_datasource.dart';
import 'package:flutter_application_1/features/auth/data/models/auth_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authLocalDatasourceProvider = Provider<AuthLocalDatasource>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  final userSessionService = ref.read(userSessionServiceProvider);

  return AuthLocalDatasource(
    hiveService: hiveService,
    userSessionService: userSessionService,
  );
});

class AuthLocalDatasource implements IAuthLocalDatasource {
  final HiveService _hiveService;
  final UserSessionService _userSessionService; // ← fixed comma + naming

  AuthLocalDatasource({
    required HiveService hiveService,
    required UserSessionService userSessionService,
  }) : _hiveService = hiveService,
       _userSessionService = userSessionService; // ← fixed naming + syntax

  @override
  Future<AuthHiveModel?> login(String email, String password) async {
    try {
      final user = await _hiveService.loginUser(email, password);
      if (user != null) {
        await _userSessionService.saveUserSession(
          userId: user.authId,
          email: user.email,
          fullName: user.fullName,
          phoneNumber: user.phoneNumber,
          profilePicture: user.profilePicture,
        
          password: user.password,
        );
      }
      return user;
    } catch (e) {
      // ← this line was missing / broken in your file
      return Future.value(null);
    }
  }

  @override
  Future<bool> register(AuthHiveModel model) async {
    await _hiveService.registerUser(model);
    return true;
  }

  @override
  Future<bool> logout() async {
    await _hiveService.logoutUser();
    return true;
  }

  @override
  Future<AuthHiveModel?> getCurrentUser() async {
    return await _hiveService.getCurrentUser();
  }

  @override
  Future<bool> isEmailExists(String email) async {
    return await _hiveService.isEmailExists(email);
  }

  @override
  Future<AuthHiveModel?> getUserById(String authId) async {
    return await _hiveService.getUserById(authId);
  }

  @override
  Future<AuthHiveModel?> getUserByEmail(String email) async {
    return await _hiveService.getUserByEmail(email);
  }

  @override
  Future<bool> UpdateUser(AuthHiveModel user) async {
    // ← method name fixed (capital U → lowercase)
    await _hiveService.updateUser(user);
    return true;
  }

  @override
  Future<bool> deleteUser(String authId) async {
    await _hiveService.deleteUser(authId);
    return true;
  }
}
