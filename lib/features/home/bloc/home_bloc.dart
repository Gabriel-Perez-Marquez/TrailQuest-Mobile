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
      final routes = await routeService.getRoutes(
        query: event.query,
        difficulty: event.difficulty,
        maxDistance: event.maxDistance,
        region: event.region,
      );
      
      emit(HomeLoaded(routes));
    } catch (e) {
      emit(HomeError('Error al cargar las rutas: $e'));
    }
  }

  Future<void> _onRefresh(HomeRefresh event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    
    try {
      final routes = await routeService.getRoutes();
      emit(HomeLoaded(routes));
    } catch (e) {
      emit(HomeError('Error al actualizar: $e'));
    }
  }
}
