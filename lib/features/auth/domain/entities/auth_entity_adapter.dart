import 'package:hive/hive.dart';
import 'auth_entity.dart';

class AuthEntityAdapter extends TypeAdapter<AuthEntity> {
  @override
  final int typeId = 0; // Must match the typeId in AuthEntity

  @override
  AuthEntity read(BinaryReader reader) {
    return AuthEntity(
      fullName: reader.readString(),
      email: reader.readString(),
      phoneNumber: reader.readString(),
      batch: reader.readString(),
      password: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, AuthEntity obj) {
    writer.writeString(obj.fullName);
    writer.writeString(obj.email);
    writer.writeString(obj.phoneNumber);
    writer.writeString(obj.batch);
    writer.writeString(obj.password);
  }
}
