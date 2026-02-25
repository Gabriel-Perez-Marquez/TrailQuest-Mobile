import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart'; 
import 'package:trailquest_mobile/core/models/route_response.dart'; 

class RouteSelectedMap extends StatelessWidget {
  final TrailRoute trailRoute;

  const RouteSelectedMap({super.key, required this.trailRoute});

  @override
  Widget build(BuildContext context) {
    // Si la ruta no tiene puntos, centramos en un punto por defecto
    final initialCenter = trailRoute.pathPoints.isNotEmpty 
        ? trailRoute.pathPoints.first 
        : const LatLng(43.1850, -4.8300);

    return FlutterMap(
      options: MapOptions(
        initialCenter: initialCenter,
        initialZoom: 13.5,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.trailquest.app',
        ),
        
        // DIBUJAMOS LA LÍNEA NARANJA
        if (trailRoute.pathPoints.isNotEmpty)
          PolylineLayer(
            polylines: [
              Polyline(
                points: trailRoute.pathPoints,
                color: const Color(0xFFFF8C00), 
                strokeWidth: 8.0,
              ),
            ],
          ),

        // DIBUJAMOS LOS PINES
        MarkerLayer(
          markers: _buildMarkers(),
        ),
      ],
    );
  }

  List<Marker> _buildMarkers() {
    List<Marker> markers = [];

    // Iteramos sobre los POIs que vienen dentro de tu TrailRoute
    for (var poi in trailRoute.pois) {
      markers.add(
        Marker(
          point: LatLng(poi.lat, poi.lon),
          width: 32,
          height: 32,
          child: Icon(
            Icons.location_on_outlined, 
            color: Colors.redAccent[400],
            size: 32,
          ),
        ),
      );
    }

    return markers;
  }
}