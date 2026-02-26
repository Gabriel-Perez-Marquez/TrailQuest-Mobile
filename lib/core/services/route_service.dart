import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trailquest_mobile/core/models/route_response.dart';
import 'package:trailquest_mobile/core/models/page_response.dart';
import 'package:trailquest_mobile/core/services/token_service.dart';

class RouteService {
  final String baseUrl = 'http://10.0.2.2:8080/api';
  final TokenService _tokenService = TokenService();

  Future<List<TrailRoute>> getRoutes({
    String? query,
    String? difficulty,
    double? maxDistance,
    String? region,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final token = await _tokenService.getToken();
      
      final Map<String, String> queryParams = {
        'page': page.toString(),
        'size': size.toString(),
      };

      if (query != null && query.isNotEmpty) {
        queryParams['query'] = query;
      }
      if (difficulty != null && difficulty.isNotEmpty) {
        queryParams['difficulty'] = difficulty;
      }
      if (maxDistance != null) {
        queryParams['maxDistance'] = maxDistance.toString();
      }
      if (region != null && region.isNotEmpty) {
        queryParams['region'] = region;
      }

      final uri = Uri.parse('$baseUrl/routes').replace(queryParameters: queryParams);
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final pageResponse = PageResponse.fromJson(
          json,
          (routeJson) => TrailRoute.fromJson(routeJson),
        );
        return pageResponse.content;
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<TrailRoute> getRoute(int routeId) async {
    try {
      final token = await _tokenService.getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/routes/$routeId'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

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