import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:trailquest_mobile/core/models/poi.dart';
import 'package:trailquest_mobile/core/services/token_service.dart';

class PoiService {
  final String baseUrl = 'http://10.0.0.2:8080'; 
  

  Future<POI> getPoiDetails(String id) async {
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

  Future<void> createPoi({
    required int routeId,
    required String name,
    required double lat,
    required double lon,
    required String difficulty,
    required String duration,
    required String type,
    required String description,
    required String historicalNote,
    required List<String> features,
    String? photoFileId,
  }) async {

    final tokenService = TokenService();
    final token = await tokenService.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/route/$routeId/poi'), 
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', 
      },
      body: jsonEncode({
        'name': name,
        'lat': lat,
        'lon': lon,
        'difficulty': difficulty,
        'duration': duration,
        'type': type,
        'description': description,
        'historicalNote': historicalNote,
        'features': features,
        'photoFileId': photoFileId,
      }),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Error al crear el POI: ${response.body}');
    }
  }
}