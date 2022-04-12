import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final _storage = const FlutterSecureStorage();

  static const _tokenKey = 'TOKEN';
  static const _usernameKey = 'USERNAME';

  Future<void> saveUsernameAndToken(String username, String token) async {
    await _storage.write(key: _usernameKey, value: username);
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<bool> hasToken() async {
    return _storage.containsKey(key: _tokenKey);
    // final value = await _storage.read(key: _tokenKey);
    // return value != null;
  }

  Future<bool> hasUsername() async {
    return _storage.containsKey(key: _usernameKey);
    // final value = _storage.read(key: _usernameKey);
    // return value != null;
  }

  Future<void> deleteToken() async {
    return _storage.delete(key: _tokenKey);
  }

  Future<void> deleteUsername() async {
    return _storage.delete(key: _usernameKey);
  }

  Future<String?> getUsername() async {
    return _storage.read(key: _usernameKey);
  }

  Future<String?> getToken() async {
    return _storage.read(key: _tokenKey);
  }

  Future<void> deleteAll() async {
    return _storage.deleteAll();
  }
}
