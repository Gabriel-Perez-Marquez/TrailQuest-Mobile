import 'dart:convert';
import 'package:latlong2/latlong.dart';
import 'poi.dart';

class TrailRoute {
  final int id;
  final String title;
  final String region;
  final double distanceKm;
  final String difficulty;
  final String creatorId;
  final String coverFileId;
  final int elevation; 
  final List<LatLng> pathPoints; 
  final List<POI> pois;

  TrailRoute({
    required this.id,
    required this.title,
    required this.region,
    required this.distanceKm,
    required this.difficulty,
    required this.creatorId,
    required this.coverFileId,
    required this.elevation,
    required this.pathPoints,
    required this.pois,
  });


factory TrailRoute.fromJson(Map<String, dynamic> json) {
    // 1. Mapear los POIs de forma segura
    List<POI> parsedPois = json['pois'] != null
        ? (json['pois'] as List).map((poiJson) => POI.fromJson(poiJson)).toList()
        : [];

    // 2. Decodificar las coordenadas (pathPointsJson) de forma segura
    List<LatLng> parsedPath = [];
    if (json['pathPointsJson'] != null && json['pathPointsJson'].toString().isNotEmpty) {
      try {
        List<dynamic> decodedPoints = jsonDecode(json['pathPointsJson']);
        parsedPath = decodedPoints.map((point) {
          return LatLng(point[0].toDouble(), point[1].toDouble());
        }).toList();
      } catch (e) {
        print("Error decodificando la ruta del mapa: $e");
      }
    }

    // 3. Retornar el objeto con el mismo estilo que tu POI
    return TrailRoute(
      id: json['id'],
      title: json['title'] ?? 'Sin título',
      region: json['region'] ?? 'N/A',
      distanceKm: (json['distanceKm'] ?? 0.0).toDouble(),
      difficulty: json['difficulty'] ?? 'N/A',
      creatorId: json['creatorId'] ?? 'Desconocido',
      coverFileId: json['coverFileId'] ?? '',
      elevation: json['elevation'] ?? 0,
      pathPoints: parsedPath,
      pois: parsedPois,
    );
  }
}