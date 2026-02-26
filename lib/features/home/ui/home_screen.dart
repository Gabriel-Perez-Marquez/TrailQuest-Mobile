import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailquest_mobile/core/services/route_service.dart';
import 'package:trailquest_mobile/features/home/bloc/home_bloc.dart';
import 'package:trailquest_mobile/features/home/widgets/route_card.dart';
import 'package:trailquest_mobile/features/route_filters/ui/route_filters_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(RouteService())..add(HomeLoadRoutes()),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openFilters() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RouteFiltersView(),
      ),
    );
  }

  void _performSearch(String query) {
    context.read<HomeBloc>().add(HomeLoadRoutes(query: query));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1F17),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD2E993),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.map_outlined,
                          color: Color(0xFF0F1F17),
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD2E993),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: TextField(
                            controller: _searchController,
                            onSubmitted: _performSearch,
                            style: const TextStyle(
                              color: Color(0xFF0F1F17),
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Find trails',
                              hintStyle: TextStyle(
                                color: Color(0xFF2D4A35),
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Color(0xFF0F1F17),
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD2E993),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: IconButton(
                          onPressed: _openFilters,
                          icon: const Icon(
                            Icons.tune,
                            color: Color(0xFF0F1F17),
                            size: 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildFilterChip('Near', Icons.location_on_outlined, false),
                      const SizedBox(width: 8),
                      _buildFilterChip('Views', Icons.terrain, false),
                      const SizedBox(width: 8),
                      _buildFilterChip('Top selected', Icons.star, false),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF1B512D),
                      ),
                    );
                  }

                  if (state is HomeError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              context.read<HomeBloc>().add(HomeRefresh());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1B512D),
                            ),
                            child: const Text('Reintentar'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is HomeLoaded) {
                    if (state.routes.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.hiking_outlined,
                              size: 80,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No routes found',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<HomeBloc>().add(HomeRefresh());
                      },
                      color: const Color(0xFF1B512D),
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 16, bottom: 90),
                        itemCount: state.routes.length,
                        itemBuilder: (context, index) {
                          final route = state.routes[index];
                          return RouteCard(
                            route: route,
                            onTap: () {
                              // Descomentar cuando Carmen tenga lista la pantalla route_details_view:
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => RouteDetailsView(route: route),
                              //   ),
                              // );
                            },
                          );
                        },
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF1B512D) : const Color(0xFF1B512D),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: const Color(0xFFD2E993),
            size: 18,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFD2E993),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
