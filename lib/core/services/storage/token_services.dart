import 'package:flutter_application_1/core/services/storage/user_session_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

//provider
final tokenServicesProvider = Provider<TokenServices>((ref) {
  final prefs = ref.read(sharedPreferencesProvider);
  return TokenServices(prefs: prefs);
});

class TokenServices {
  final FlutterSecureStorage _storage;
  final SharedPreferences _prefs;
  static const String _tokenKey = 'auth_token';

  TokenServices({required SharedPreferences prefs}) : _prefs = prefs, _storage = const FlutterSecureStorage();

  //save toek : secure storage
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  //get token
  String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  //remove token
  Future<void> removeToken() async {
    await _storage.delete(key: _tokenKey);
  }
}
