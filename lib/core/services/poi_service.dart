import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:trailquest_mobile/core/models/poi.dart';

class PoiService {
  // Mismo baseUrl que RouteService (10.0.2.2 = localhost desde el emulador Android)
  final String baseUrl = 'http://10.0.2.2:8080/api';

  /// Devuelve todos los POIs de una ruta: GET /api/pois/route/{routeId}
  Future<List<POI>> getPoisByRoute(int routeId) async {
    try {
      final url = Uri.parse('$baseUrl/pois/route/$routeId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // El backend devuelve una Page<PoiResponse>, el contenido está en 'content'
        final List<dynamic> content =
            data is Map ? (data['content'] ?? []) : data as List;
        return content.map((e) => POI.fromJson(e)).toList();
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Fallo la conexión con la API: $e');
    }
  }

  /// Detalle de un POI por id: GET /api/pois/{id}
  Future<POI> getPoiDetails(int id) async {
    try {
      final url = Uri.parse('$baseUrl/pois/$id');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return POI.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('El punto de interés no existe.');
      } else {
        throw Exception('Error en el servidor: código ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Fallo la conexión con la API: $e');
    }
  }
}