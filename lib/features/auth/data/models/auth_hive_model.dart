// File: auth_hive_model.dart
// constant
import 'package:flutter_application_1/core/constants/hive_table_constatn.dart';
import 'package:flutter_application_1/features/auth/domain/entities/auth_entity.dart';
import 'package:flutter_application_1/features/batch/domain/entites/batch_entity.dart';
// Fixed: entites → entities
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'auth_hive_model.g.dart'; // Will be generated

@HiveType(typeId: HiveTableConstant.authTypeId)
class AuthHiveModel extends HiveObject {
  @HiveField(0)
  final String? authId;

  @HiveField(1)
  final String fullName;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String? phoneNumber;

  @HiveField(4)
  final String? batchId;

  @HiveField(5)
  final String userName;

  @HiveField(6)
  final String? password;

  @HiveField(7)
  final String? profilePicture;

  AuthHiveModel({
    String? authId,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.batchId,
    required this.userName,
    this.password,
    this.profilePicture,
  }) : authId = authId ?? const Uuid().v4();

  // Factory: Domain Entity → Hive Model
  factory AuthHiveModel.fromEntity(AuthEntity entity) => AuthHiveModel(
    authId: entity.userId,
    fullName: entity.fullName ?? '',
    email: entity.email ?? '',
    phoneNumber: entity.phoneNumber,
    batchId: entity.batchId,
    userName: entity.username ?? '',
    password: entity.password,
    profilePicture: entity.profilePicture,
  );

  // Instance method: Hive Model → Domain Entity
  AuthEntity toEntity({BatchEntity? batchEntity}) => AuthEntity(
    userId: authId,
    fullName: fullName,
    email: email,
    phoneNumber: phoneNumber,
    // batchId: batchId,
    username: userName,
    password: password,
    profilePicture: profilePicture,
    batch: batchEntity,
    batchId: '',
  );

  // Static method to convert list (now inside the class)
  static List<AuthEntity> toEntityList({
    required List<AuthHiveModel> models,
    List<BatchEntity>? batchEntities, // optional if you want to map batches
  }) {
    return models.map((model) => model.toEntity(batchEntity: null)).toList();
    // You can improve this later to match batches by ID if needed
  }
}
