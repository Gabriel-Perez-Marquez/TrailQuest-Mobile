import 'package:latlong2/latlong.dart';

class RouteCreateRequest {
  final String title;
  final String region;
  final double distanceKm;
  final String difficulty;
  final String coverFileId;
  final int elevation;
  final List<LatLng> pathPoints;

  RouteCreateRequest({
    required this.title,
    required this.region,
    required this.distanceKm,
    required this.difficulty,
    required this.coverFileId,
    required this.elevation,
    required this.pathPoints,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'region': region,
      'distanceKm': distanceKm,
      'difficulty': difficulty,
      'coverFileId': coverFileId,
      'elevation': elevation,
      'pathPoints': pathPoints.map((point) => [point.latitude, point.longitude]).toList(),
    };
  }
}
