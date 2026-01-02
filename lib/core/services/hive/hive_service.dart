import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/hive_table_constatn.dart';
import 'package:flutter_application_1/features/auth/data/models/auth_hive_model.dart';
import 'package:flutter_application_1/features/batch/data/models/batch_hive_model.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

class HiveService {
  Future<void> init() async {
    // Get app documents directory
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path; // Hive will create subfolder automatically
    Hive.init(path);

    _registerAdapters(); // Fixed name

    await openBoxes();
    await insertDummyBatches(); // Fixed typo: Btches → Batches
  }

  Future<void> insertDummyBatches() async {
    final box = Hive.box<BatchHivemodel>(
      HiveTableConstant.batchTable,
    ); // Use correct constant

    if (box.isNotEmpty) return;

    final dummyBatches = [
      BatchHivemodel(batchName: '35-A'),
      BatchHivemodel(batchName: '35-B'),
      BatchHivemodel(batchName: '35-C'),
      BatchHivemodel(batchName: '35-D'),
    ];

    for (var batch in dummyBatches) {
      await box.put(batch.batchId, batch);
    }
    // No need to close here — keep box open for app lifetime
  }

  void _registerAdapters() {
    // Register Batch adapter (uncomment when you generate the adapter)
    // if (!Hive.isAdapterRegistered(HiveTableConstant.batchTypeId)) {
    //   Hive.registerAdapter(BatchHiveModelAdapter()); // Fixed: BatchHivemode() → BatchHiveModelAdapter()
    // }

    // Register Auth adapter
    if (!Hive.isAdapterRegistered(HiveTableConstant.authTypeId)) {
      Hive.registerAdapter(AuthHiveModelAdapter());
    }
  }

  Future<void> openBoxes() async {
    await Hive.openBox<BatchHivemodel>(HiveTableConstant.batchTable);
    await Hive.openBox<AuthHiveModel>(HiveTableConstant.authTable);
  }

  Future<void> close() async {
    await Hive.close();
  }

  // Batch operations
  Box<BatchHivemodel> get _batchBox =>
      Hive.box<BatchHivemodel>(HiveTableConstant.batchTable);

  Future<BatchHivemodel> createBatch(BatchHivemodel model) async {
    await _batchBox.put(model.batchId, model);
    return model;
  }

  Future<void> updateBatch(BatchHivemodel model) async {
    await _batchBox.put(model.batchId, model);
  }

  // Auth operations
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
}
