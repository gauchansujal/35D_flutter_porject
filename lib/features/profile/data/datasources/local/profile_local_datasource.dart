import 'package:flutter_application_1/core/services/hive/hive_service.dart';
import 'package:flutter_application_1/features/profile/data/datasources/profile_datasource.dart';
import 'package:flutter_application_1/features/profile/data/models/profile_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileLocalDataSourceProvider = Provider<ProfileLocalDataSource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  return ProfileLocalDataSource(hiveService: hiveService);
});

class ProfileLocalDataSource implements IProfileLocalDataSource {
  final HiveService _hiveService;

  ProfileLocalDataSource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<ProfileHiveModel?> getProfile(String studentId) async {
    try {
      return await _hiveService.getProfile(studentId);
    } catch (e) {
      // You can log the error here if you have a logger
      return null;
    }
  }

  @override
  Future<List<ProfileHiveModel>> getAllProfiles() async {
    try {
      return await _hiveService.getAllProfiles();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> cacheProfile(ProfileHiveModel profile) async {
    try {
      await _hiveService.cacheProfile(profile);
    } catch (e) {
      // In production, you might want to rethrow or handle differently
      rethrow;
    }
  }

  @override
  Future<void> updateCachedProfile(ProfileHiveModel profile) async {
    try {
      // Usually same as cache in Hive (put overrides)
      await _hiveService.cacheProfile(profile);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> clearProfile(String studentId) async {
    try {
      await _hiveService.deleteProfile(studentId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> clearAll() async {
    try {
      await _hiveService.clearAllProfiles();
    } catch (e) {
      rethrow;
    }
  }
}
