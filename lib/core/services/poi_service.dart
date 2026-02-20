import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:trailquest_mobile/core/models/poi.dart';

class PoiService {
  final String baseUrl = 'http://10.0.0.2:8080'; 

  Future<POI> getPoiDetails(String id) async {
    try {
      
      final url = Uri.parse('$baseUrl/pois/$id');
      
      final response = await http.get(
        url,
        // headers: {
        //   'Authorization': 'Bearer TU_TOKEN_AQUI',
        //   'Content-Type': 'application/json',
        // },
      );

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