import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailquest_mobile/core/services/route_service.dart';
import 'package:trailquest_mobile/features/general_map/bloc/general_map_bloc.dart';
import 'all_routes_map.dart'; 

class AllRoutesMapScreen extends StatelessWidget {
  const AllRoutesMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Instanciamos el BLoC y pedimos que cargue todas las rutas al abrir la pantalla
      create: (context) => GeneralMapBloc(RouteService())..add(GeneralMapFetchAllRoutesEvent()),
      
      child: Scaffold(
        body: Stack(
          children: [
            // 1. CAPA DEL MAPA (Escuchando al BLoC)
            Positioned.fill(
              child: BlocBuilder<GeneralMapBloc, GeneralMapState>(
                builder: (context, state) {
                  if (state is GeneralMapLoading || state is GeneralMapInitial) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.redAccent),
                    );
                  }
                  
                  if (state is GeneralMapError) {
                    return Center(
                      child: Text(state.message, style: const TextStyle(color: Colors.red)),
                    );
                  }

                  if (state is GeneralMapSuccess) {
                    return AllRoutesMap(allRoutes: state.listaRoutes);
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),

            // 2. CAPA SUPERIOR (Botón de volver y título)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 24,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.black87),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))
                          ],
                        ),
                        child: const Text(
                          "Explorar Rutas",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}