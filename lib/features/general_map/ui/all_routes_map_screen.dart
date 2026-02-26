import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailquest_mobile/core/services/route_service.dart';
import 'package:trailquest_mobile/features/general_map/bloc/general_map_bloc.dart';
import 'package:trailquest_mobile/features/home/ui/home_screen.dart';
import 'package:trailquest_mobile/features/welcome_page/ui/welcome_page_view.dart';
import 'all_routes_map.dart'; 

class AllRoutesMapScreen extends StatelessWidget {
  const AllRoutesMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Instanciamos el BLoC y pedimos que cargue todas las rutas al abrir la pantalla
      create: (context) => GeneralMapBloc(RouteService())..add(GeneralMapFetchAllRoutesEvent()),
      
      child: Scaffold(
        // 1. EL CUERPO PRINCIPAL (Mapa y Barra Superior)
        body: Stack(
          children: [
            // CAPA DEL MAPA (Escuchando al BLoC)
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

            // CAPA SUPERIOR (Botón de volver y título)
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
                          onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const HomeScreen()),
                          ),
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

        // 2. EL MENÚ INFERIOR DE NAVEGACIÓN
        bottomNavigationBar: _buildCustomBottomBar(context),
      ),
    );
  }

  // --- WIDGET DEL MENÚ INFERIOR ---
  Widget _buildCustomBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 14, bottom: 20), 
      decoration: const BoxDecoration(
        color: Color(0xFF2B3A2C), 
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildNavItem(Icons.search, "Explore", isActive: false, onTap: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (ctx) => const HomeScreen()),
                          ),),
            _buildNavItem(Icons.favorite_border, "Saved", isActive: false, onTap: () => {},),
            _buildNavItem(Icons.where_to_vote_outlined, "Check ins", isActive: false, onTap: () => {},),
            _buildNavItem(Icons.navigation_outlined, "Navigate", isActive: true, onTap: () => {},),
            _buildNavItem(Icons.route_outlined, "My Routes", isActive: false, onTap: () => {},),
            _buildNavItem(Icons.person_outline, "Profile", isActive: false, onTap: () => {},),
          ],
        ),
      ),
    );
  }

  // --- DISEÑO DE CADA BOTÓN ---
  Widget _buildNavItem(IconData icon, String label, {required bool isActive, required VoidCallback onTap}) {
    final color = isActive ? const Color(0xFFDFE69B) : const Color(0xFFDFE69B).withOpacity(0.6);

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}