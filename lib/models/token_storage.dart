import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static var storage = FlutterSecureStorage();
  static const _tokenKey = "token";

  static Future<String?> readToken() async {
    return await storage.read(key: _tokenKey);
  }

  static Future<void> writeToken(String token) async {
    await storage.write(key: _tokenKey, value: token);
  }
}
