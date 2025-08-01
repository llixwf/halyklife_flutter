// class TokenStorage {
//   static String? token;
// }

import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static String? token;

  static Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    TokenStorage.token = token;
  }

  static Future<void> loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
  }

  static Future<void> clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    token = null;
  }
}

class PinStorage {
  static Future<void> savePin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pin_code', pin);
  }

  static Future<String?> getPin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('pin_code');
  }

  // static Future<void> clearPin() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.remove('pin_code');
  // }
}
