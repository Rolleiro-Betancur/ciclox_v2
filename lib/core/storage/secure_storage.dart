import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage _storage;
  SecureStorage(this._storage);

  static const _tokenKey = 'jwt_token';
  static const _userKey  = 'user_data';
  static const _rolKey   = 'user_rol';

  Future<void>    saveToken(String token)    => _storage.write(key: _tokenKey, value: token);
  Future<String?> getToken()                 => _storage.read(key: _tokenKey);

  Future<void>    saveUserData(String json)  => _storage.write(key: _userKey, value: json);
  Future<String?> getUserData()              => _storage.read(key: _userKey);

  Future<void>    saveRol(String rol)        => _storage.write(key: _rolKey, value: rol);
  Future<String?> getRol()                   => _storage.read(key: _rolKey);

  Future<void>    clearAll()                 => _storage.deleteAll();
}
