import 'package:flutter/material.dart';
// Correct import
import 'package:flutter_application_1/core/constants/hive_table_constatn.dart';
// Removed duplicate wrong import: hive_table_constatn.dart

import 'package:flutter_application_1/features/auth/data/models/auth_hive_model.dart';
// import 'package:flutter_application_1/features/batch/data/models/batch_hive_model.dart'; // Commented out

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

class HiveService {
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    Hive.init(path);

    _registerAdapters();

    await openBoxes();
    // await insertDummyBatches(); // Commented out - batch related
  }

  // Future<void> insertDummyBatches() async { ... } // Fully commented out

  void _registerAdapters() {
    if (!Hive.isAdapterRegistered(HiveTableConstant.authTypeId)) {
      Hive.registerAdapter(AuthHiveModelAdapter());
    }
    // Batch adapter registration removed since batch is not used now
  }

  Future<void> openBoxes() async {
    // await Hive.openBox<BatchHiveModel>(HiveTableConstant.batchTable); // Commented out
    await Hive.openBox<AuthHiveModel>(HiveTableConstant.authTable);
  }

  Future<void> close() async {
    await Hive.close();
  }

  // // Batch operations - all commented out
  // Box<BatchHiveModel> get _batchBox =>
  //     Hive.box<BatchHiveModel>(HiveTableConstant.batchTable);
  //
  // Future<BatchHiveModel> createBatch(BatchHiveModel model) async { ... }
  //
  // Future<void> updateBatch(BatchHiveModel model) async { ... }

  // Auth operations - kept active
  Box<AuthHiveModel> get _authBox =>
      Hive.box<AuthHiveModel>(HiveTableConstant.authTable);

  Future<AuthHiveModel?> loginUser(String email, String password) async {
    final users = _authBox.values.where(
      (user) => user.email == email && user.password == password,
    );

    if (users.isNotEmpty) {
      return users.first;
    }
    return null;
  }

  Future<void> logoutUser(String authId) async {
    await _authBox.delete(authId);
  }

  AuthHiveModel? getCurrentUser(String authId) {
    return _authBox.get(authId);
  }

  Future<void> registerUser(AuthHiveModel model) async {
    await _authBox.put(model.authId, model);
  }

  Future<bool> isEmailExists(String email) async {
    final lowerEmail = email.toLowerCase();
    return _authBox.values.any(
      (user) => (user.email ?? '').toLowerCase() == lowerEmail,
    );
  }
}
