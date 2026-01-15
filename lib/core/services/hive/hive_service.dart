import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/hive_table_constatn.dart';
import 'package:flutter_application_1/features/auth/data/models/auth_hive_model.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

class HiveService {
  // Constants for current user tracking
  static const String _currentUserIdKey = 'current_user_id';
  static const String _settingsBoxName = 'app_settings';

  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);

    _registerAdapters();
    await openBoxes();
  }

  void _registerAdapters() {
    if (!Hive.isAdapterRegistered(HiveTableConstant.authTypeId)) {
      Hive.registerAdapter(AuthHiveModelAdapter());
    }
  }

  Future<void> openBoxes() async {
    await Hive.openBox<AuthHiveModel>(HiveTableConstant.authTable);
    await Hive.openBox(_settingsBoxName); // For storing current user ID
  }

  Future<void> close() async {
    await Hive.close();
  }

  // Box getters
  Box<AuthHiveModel> get _authBox =>
      Hive.box<AuthHiveModel>(HiveTableConstant.authTable);

  Box get _settingsBox => Hive.box(_settingsBoxName);

  // ========== LOGIN ==========
  Future<AuthHiveModel?> loginUser(String email, String password) async {
    final lowerEmail = email.toLowerCase();

    final users = _authBox.values.where(
      (user) =>
          (user.email ?? '').toLowerCase() == lowerEmail &&
          user.password == password,
    );

    if (users.isEmpty) return null;

    final loggedInUser = users.first;

    // Save current user ID
    await _settingsBox.put(_currentUserIdKey, loggedInUser.authId);

    return loggedInUser;
  }

  // ========== REGISTER ==========
  Future<void> registerUser(AuthHiveModel model) async {
    // Use existing authId or generate new one
    final String userId = model.authId ?? const Uuid().v4();
    final userWithId = model.copyWith(authId: userId);

    await _authBox.put(userId, userWithId);

    // Auto-login after registration
    await _settingsBox.put(_currentUserIdKey, userId);
  }

  // ========== LOGOUT (No parameter) ==========
  Future<void> logoutUser() async {
    await _settingsBox.delete(_currentUserIdKey);
  }

  // ========== GET CURRENT USER (No parameter) ==========
  Future<AuthHiveModel?> getCurrentUser() async {
    final String? currentUserId = _settingsBox.get(_currentUserIdKey);
    if (currentUserId == null) return null;

    return _authBox.get(currentUserId);
  }

  // ========== CHECK EMAIL EXISTS ==========
  Future<bool> isEmailExists(String email) async {
    final lowerEmail = email.toLowerCase();
    return _authBox.values.any(
      (user) => (user.email ?? '').toLowerCase() == lowerEmail,
    );
  }

  // ========== GET USER BY ID ==========
  Future<AuthHiveModel?> getUserById(String authId) async {
    return _authBox.get(authId);
  }

  // ========== GET USER BY EMAIL ==========
  Future<AuthHiveModel?> getUserByEmail(String email) async {
    final lowerEmail = email.toLowerCase();

    try {
      return _authBox.values.firstWhere(
        (user) => (user.email).toLowerCase() == lowerEmail,
      );
    } catch (_) {
      return null;
    }
  }

  // ========== UPDATE USER ==========
  Future<void> updateUser(AuthHiveModel user) async {
    await _authBox.put(user.authId, user);
  }

  // ========== DELETE USER ==========
  Future<void> deleteUser(String authId) async {
    await _authBox.delete(authId);

    // If deleted user is logged in → logout
    final currentUserId = _settingsBox.get(_currentUserIdKey);
    if (currentUserId == authId) {
      await logoutUser();
    }
  }
}
