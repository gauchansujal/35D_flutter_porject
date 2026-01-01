import 'package:flutter_application_1/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  late SharedPreferences _sharedPreferences;

  // add username and password sharde pref

  Future addUser(User user) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setString('username', user.username);
    _sharedPreferences.setString('password', user.password);
  }

  Future<User> getUser(User user) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    final username = _sharedPreferences.getString('username');
    final password = _sharedPreferences.getString('password');
    return User(username: username ?? '', password: password ?? '');
  }
  //get username and password
  // User getUser(){

  // }
}
