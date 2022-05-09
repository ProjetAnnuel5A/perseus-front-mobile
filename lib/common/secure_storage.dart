import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final _storage = const FlutterSecureStorage();

  static const _tokenKey = 'TOKEN';
  static const _usernameKey = 'USERNAME';

  Future<void> saveUsernameAndToken(String username, String token) async {
    await _storage.write(key: _usernameKey, value: username);
    await _storage.write(key: _tokenKey, value: token);

    // TODO Save UserId in decodedToken ?
    // final decodedToken = JwtDecoder.decode(token)
  }

  Future<bool> hasToken() async {
    final containsToken = await _storage.containsKey(key: _tokenKey);

    if (containsToken && await getToken() != null) {
      return true;
    }

    return false;
  }

  Future<bool> hasUsername() async {
    return _storage.containsKey(key: _usernameKey);
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
