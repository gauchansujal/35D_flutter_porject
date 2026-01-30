import 'package:flutter_application_1/core/services/storage/user_session_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

//provider
final tokenServicesProvider = Provider<TokenServices>((ref) {
  final prefs = ref.read(sharedPreferencesProvider);
  return TokenServices(prefs: prefs);
});

class TokenServices {
  final SharedPreferences _prefs;
  static const String _tokenKey = 'auth_token';

  TokenServices({required SharedPreferences prefs}) : _prefs = prefs;

  //save toek : secure storage
  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  //get token
  String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  //remove token
  Future<void> removeToken() async {
    await _prefs.remove(_tokenKey);
  }
}
