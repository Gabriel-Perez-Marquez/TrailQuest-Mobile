import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:trailquest_mobile/core/models/route_response.dart';
import 'package:trailquest_mobile/core/services/route_service.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final RouteService routeService;

  HomeBloc(this.routeService) : super(HomeInitial()) {
    on<HomeLoadRoutes>(_onLoadRoutes);
    on<HomeRefresh>(_onRefresh);
  }

  Future<void> _onLoadRoutes(HomeLoadRoutes event, Emitter<HomeState> emit) async {
    emit(HomeLoading());

    try {
      // TODO: Cuando el backend tenga el endpoint de listado con filtros, usar:
      // final routes = await routeService.getRoutes(
      //   query: event.query,
      //   difficulty: event.difficulty,
      //   maxDistance: event.maxDistance,
      //   region: event.region,
      // );

      // Por ahora, usamos datos mock para que funcione
      final List<TrailRoute> mockRoutes = _getMockRoutes();
      
      emit(HomeLoaded(mockRoutes));
    } catch (e) {
      emit(HomeError('Error al cargar las rutas: $e'));
    }
  }

  Future<void> _onRefresh(HomeRefresh event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    
    try {
      final List<TrailRoute> mockRoutes = _getMockRoutes();
      emit(HomeLoaded(mockRoutes));
    } catch (e) {
      emit(HomeError('Error al actualizar: $e'));
    }
  }

  // Mock data temporal hasta que el backend esté listo
  List<TrailRoute> _getMockRoutes() {
    return [
      TrailRoute(
        id: 1,
        title: 'Caminito del Rey',
        region: 'Málaga',
        distanceKm: 7.7,
        difficulty: 'Moderate',
        creatorId: 'user1',
        coverFileId: '',
        elevation: 300,
        pathPoints: [],
        pois: [],
      ),
      TrailRoute(
        id: 2,
        title: 'Sierra de Grazalema',
        region: 'Cádiz',
        distanceKm: 12.5,
        difficulty: 'Hard',
        creatorId: 'user2',
        coverFileId: '',
        elevation: 600,
        pathPoints: [],
        pois: [],
      ),
      TrailRoute(
        id: 3,
        title: 'Sendero del Río Borosa',
        region: 'Jaén',
        distanceKm: 21.0,
        difficulty: 'Moderate',
        creatorId: 'user3',
        coverFileId: '',
        elevation: 450,
        pathPoints: [],
        pois: [],
      ),
      TrailRoute(
        id: 4,
        title: 'Cabo de Gata',
        region: 'Almería',
        distanceKm: 5.2,
        difficulty: 'Easy',
        creatorId: 'user4',
        coverFileId: '',
        elevation: 150,
        pathPoints: [],
        pois: [],
      ),
    ];
  }
}
