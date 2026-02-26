import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
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

  Future<String> uploadCoverImage(File imageFile) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/routes/upload-cover'),
      );

      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );

      final response = await request.send();

      if (response.statusCode == 201) {
        final responseData = await response.stream.bytesToString();
        final json = jsonDecode(responseData);
        return json['id'] ?? json['fileId'] ?? '';
      } else {
        throw Exception('Error al subir imagen: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al subir imagen: $e');
    }
  }

  Future<TrailRoute> createRoute({
    required String title,
    required String region,
    required double distanceKm,
    required String difficulty,
    required String creatorId,
    required String coverFileId,
    required int elevation,
    required List<LatLng> pathPoints,
  }) async {
    try {
      final requestBody = {
        'title': title,
        'region': region,
        'distanceKm': distanceKm,
        'difficulty': difficulty,
        'creatorId': creatorId,
        'coverFileId': coverFileId,
        'elevation': elevation,
        'pathPoints': pathPoints.map((p) => [p.latitude, p.longitude]).toList(),
      };

      final response = await http.post(
        Uri.parse('$baseUrl/routes'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return TrailRoute.fromJson(json);
      } else {
        throw Exception('Error del servidor: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error al crear la ruta: $e');
    }
  }
}