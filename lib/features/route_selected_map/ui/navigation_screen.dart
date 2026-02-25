// Archivo: lib/features/navigation/ui/navigation_screen.dart (o donde lo hayas creado)

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailquest_mobile/core/models/route_response.dart';
import 'package:trailquest_mobile/core/services/route_service.dart';
import 'package:trailquest_mobile/features/route_selected_map/bloc/route_selected_map_bloc.dart';
import 'package:trailquest_mobile/features/route_selected_map/ui/route_selected_map.dart'; 

class NavigationScreen extends StatelessWidget {
final int routeId;

  const NavigationScreen({super.key, required this.routeId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // 1. Instanciamos el BLoC, le pasamos el Servicio, y pedimos que cargue la ruta
      create: (context) => RouteSelectedMapBloc(RouteService())..add(RouteSelectedMapGetOneEvent(routeId)),
      
      child: Scaffold(
        body: BlocBuilder<RouteSelectedMapBloc, RouteSelectedMapState>(
          builder: (context, state) {
            

            if (state is RouteSelectedMapLoading || state is RouteSelectedMapInitial) {
              return Container(
                color: const Color(0xFFD6E3B5), 
                child: const Center(
                  child: CircularProgressIndicator(color: Color(0xFFFF8C00)),
                ),
              );
            }


            if (state is RouteSelectedMapError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.redAccent, size: 60),
                    const SizedBox(height: 16),
                    Text(state.message, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              );
            }


            if (state is RouteSelectedMapSuccess) {
              final route = state.route;

              return Stack(
                children: [
                  // CAPA 1: EL MAPA 
                  Positioned.fill(
                    child: RouteSelectedMap(trailRoute: route),
                  ),

                  // CAPA 2: BARRA SUPERIOR (Título dinámico)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: _buildTopBar(context, route.title), 
                      ),
                    ),
                  ),

                  // CAPA 3: BOTONES LATERALES
                  Positioned(
                    right: 20,
                    bottom: MediaQuery.of(context).size.height * 0.35,
                    child: _buildSideControls(),
                  ),

                  // CAPA 4: PANEL INFERIOR VERDE (Datos dinámicos)
                  Positioned(
                    bottom: 30,
                    left: 20,
                    right: 20,
                    child: _buildBottomDashboard(route),
                  ),
                ],
              );
            }

            
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  // --- WIDGETS DE LA INTERFAZ ---

  Widget _buildTopBar(BuildContext context, String routeTitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 26,
          child: IconButton(
            icon: const Icon(Icons.close, color: Colors.black87),
            onPressed: () => Navigator.of(context).pop(), 
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, 4))
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("CURRENTLY NAVIGATING", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.1)),
              const SizedBox(height: 4),
              Text(routeTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black87)),
            ],
          ),
        ),
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 26,
          child: IconButton(
            icon: const Icon(Icons.layers_outlined, color: Colors.black87),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildSideControls() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 26,
          child: IconButton(icon: const Icon(Icons.my_location, color: Colors.black87), onPressed: () {}),
        ),
        const SizedBox(height: 16),
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 26,
          child: IconButton(icon: const Icon(Icons.explore_outlined, color: Colors.black87), onPressed: () {}),
        ),
      ],
    );
  }

  Widget _buildBottomDashboard(TrailRoute route) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E3120),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatColumn("TIME", "01:42:08"),
              Container(width: 1, height: 40, color: Colors.white24),
              
              _buildStatColumn("DISTANCE", route.distanceKm.toStringAsFixed(1), unit: "km"),
              Container(width: 1, height: 40, color: Colors.white24),
              _buildStatColumn("ELEVATION", route.elevation.toString(), unit: "m"),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            decoration: BoxDecoration(color: const Color(0xFF152317), borderRadius: BorderRadius.circular(16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(children: const [Icon(Icons.speed, color: Colors.white70, size: 20), SizedBox(width: 8), Text("4.8 km/h", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500))]),
                Container(width: 1, height: 24, color: Colors.white24),
                Row(children: const [Icon(Icons.timer_outlined, color: Colors.white70, size: 20), SizedBox(width: 8), Text("19:24 pace", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500))]),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 18), side: const BorderSide(color: Colors.white30, width: 1.5), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                  onPressed: () {},
                  child: const Text("Pause", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDFE69B), padding: const EdgeInsets.symmetric(vertical: 18), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 0),
                  onPressed: () {},
                  child: const Text("Finish Trail", style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, {String? unit}) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1)),
        const SizedBox(height: 6),
        Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
          if (unit != null) Text(unit, style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600)),
        ]),
      ],
    );
  }
}