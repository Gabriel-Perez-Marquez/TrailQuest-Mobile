import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:trailquest_mobile/core/models/route_response.dart';

class AllRoutesMap extends StatelessWidget {
  final List<TrailRoute> allRoutes;

  const AllRoutesMap({super.key, required this.allRoutes});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: const MapOptions(
        initialCenter: LatLng(43.1850, -4.8300), 
        initialZoom: 8.0, 
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.trailquest.app',
        ),
        
        MarkerLayer(
          markers: _buildRouteMarkers(),
        ),
      ],
    );
  }

  List<Marker> _buildRouteMarkers() {
    List<Marker> markers = [];

    for (var route in allRoutes) {
      LatLng? startPoint;

      if (route.startLat != null && route.startLon != null) {
        startPoint = LatLng(route.startLat!, route.startLon!);
      } else if (route.pathPoints.isNotEmpty) {
        startPoint = route.pathPoints.first;
      } else if (route.pois.isNotEmpty) {
        startPoint = LatLng(route.pois.first.lat, route.pois.first.lon);
      }

      if (startPoint != null) {
        markers.add(
          Marker(
            point: startPoint,
            width: 20,
            height: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
            ),
          ),
        );
      }
    }

    return markers;
  }
}