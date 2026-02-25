import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trailquest_mobile/core/models/route_response.dart';

class RouteService {
  final String baseUrl = 'http://10.0.2.2:8080/api'; 

  Future<TrailRoute> getRoute(int routeId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/routes/$routeId'));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return TrailRoute.fromJson(json); 
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}