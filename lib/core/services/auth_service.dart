import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trailquest_mobile/core/models/login_request.dart';
import 'package:trailquest_mobile/core/models/auth_response.dart';

class AuthService {
  final String baseUrl = 'http://10.0.2.2:8080';

  Future<AuthResponse> login(String username, String password) async {
    try {
      final url = Uri.parse('$baseUrl/auth/login');
      final loginRequest = LoginRequest(username: username, password: password);

      print('Enviando solicitud de login a: $url con payload: ${loginRequest.toJson()}');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(loginRequest.toJson()),
      );
      print('Respuesta del servidor: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        return AuthResponse.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        throw Exception('Usuario o contraseña incorrectos');
      } else if (response.statusCode == 404) {
        throw Exception('Usuario no encontrado');
      } else {
        throw Exception('Error en el servidor: código ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('Usuario o contraseña incorrectos') ||
          e.toString().contains('Usuario no encontrado')) {
        rethrow;
      }
      throw Exception('Error de conexión: $e');
    }
  }
}
