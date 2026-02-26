import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Provider
final tokenServicesProvider = Provider<TokenServices>((ref) {
  return TokenServices();
});

class TokenServices {
  final FlutterSecureStorage _storage;
  static const String _tokenKey = 'auth_token';

  TokenServices() : _storage = const FlutterSecureStorage();

  // Save token → SecureStorage
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // Get token → SecureStorage (now async, matches where we save)
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // Remove token → SecureStorage
  Future<void> removeToken() async {
    await _storage.delete(key: _tokenKey);
  }
}
