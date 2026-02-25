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
  
  final double? startLat;
  final double? startLon;
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
    this.startLat,
    this.startLon,
    required this.elevation,
    required this.pathPoints,
    required this.pois,
  });

  factory TrailRoute.fromJson(Map<String, dynamic> json) {
    List<POI> parsedPois = json['pois'] != null
        ? (json['pois'] as List).map((poiJson) => POI.fromJson(poiJson)).toList()
        : [];

    List<LatLng> parsedPath = [];
    if (json['pathPoints'] != null) {
      try {
        var pointsList = json['pathPoints'] as List;
        parsedPath = pointsList.map((point) {
          double lat = (point['latitude'] ?? point['lat'] ?? 0.0).toDouble();
          double lon = (point['longitude'] ?? point['lon'] ?? 0.0).toDouble();
          return LatLng(lat, lon);
        }).toList();
      } catch (e) {
        print("Error decodificando pathPoints: $e");
      }
    }

    return TrailRoute(
      id: json['id'],
      title: json['title'] ?? 'Sin título',
      region: json['region'] ?? 'N/A',
      distanceKm: (json['distanceKm'] ?? 0.0).toDouble(),
      difficulty: json['difficulty'] ?? 'N/A',
      creatorId: json['creatorId'] ?? 'Desconocido',
      coverFileId: json['coverFileId'] ?? '',
      
      startLat: json['startLat']?.toDouble(),
      startLon: json['startLon']?.toDouble(),
      elevation: json['elevation'] ?? 0,
      pathPoints: parsedPath,
      pois: parsedPois,
    );
  }
}