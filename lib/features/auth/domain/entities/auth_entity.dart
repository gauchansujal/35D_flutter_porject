import 'package:hive/hive.dart';

// Must match the filename exactly

@HiveType(typeId: 0)
class AuthEntity extends HiveObject {
  @HiveField(0)
  final String fullName;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String phoneNumber;

  @HiveField(3)
  final String batch;

  @HiveField(4)
  final String password;

  AuthEntity({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.batch,
    required this.password,
  });
}
