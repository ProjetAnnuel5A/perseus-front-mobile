import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class SecureStorage {
  final _storage = const FlutterSecureStorage();

  static const _tokenKey = 'TOKEN';
  static const _usernameKey = 'USERNAME';
  static const _role = 'ROLE';
  static const _userId = 'USERID';

  Future<void> saveUsernameAndToken(String username, String token) async {
    await _storage.write(key: _usernameKey, value: username);
    await _storage.write(key: _tokenKey, value: token);

    final decodedToken = JwtDecoder.decode(token);

    final userId = decodedToken['sub'] as String;
    final role = decodedToken['auth'] as String;

    await _storage.write(key: _userId, value: userId);
    await _storage.write(key: _role, value: role);
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

  Future<bool> hasUserId() async {
    return _storage.containsKey(key: _userId);
  }

  Future<bool> hasRole() async {
    return _storage.containsKey(key: _role);
  }

  Future<void> deleteToken() async {
    return _storage.delete(key: _tokenKey);
  }

  Future<void> deleteUsername() async {
    return _storage.delete(key: _usernameKey);
  }

  Future<void> deleteUserId() async {
    return _storage.delete(key: _userId);
  }

  Future<void> deleteRole() async {
    return _storage.delete(key: _role);
  }

  Future<String?> getUsername() async {
    return _storage.read(key: _usernameKey);
  }

  Future<String?> getToken() async {
    return _storage.read(key: _tokenKey);
  }

  Future<String?> getUserId() async {
    return _storage.read(key: _userId);
  }

  Future<String?> getRole() async {
    return _storage.read(key: _role);
  }

  Future<void> deleteAll() async {
    return _storage.deleteAll();
  }
}
