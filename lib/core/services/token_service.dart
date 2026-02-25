import 'package:shared_preferences/shared_preferences.dart';

/// Servicio para gestionar el almacenamiento del token JWT
class TokenService {
  static const String _tokenKey = 'jwt_token';
  static const String _usernameKey = 'username';

  /// Guardar el token JWT y el username tras el login
  Future<void> saveToken(String token, String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_usernameKey, username);
  }

  /// Obtener el token JWT almacenado
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Obtener el username almacenado
  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  /// Verificar si el usuario está autenticado (tiene token)
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Eliminar el token y username (logout)
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_usernameKey);
  }

  /// Limpiar toda la información de autenticación
  Future<void> logout() async {
    await clearToken();
  }
}
