import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:trailquest_mobile/core/models/route_response.dart';
import 'package:trailquest_mobile/core/services/route_service.dart';

part 'route_selected_map_event.dart';
part 'route_selected_map_state.dart';

class RouteSelectedMapBloc extends Bloc<RouteSelectedMapEvent, RouteSelectedMapState> {
  RouteSelectedMapBloc(RouteService routeService) : super(RouteSelectedMapInitial()) {
    on<RouteSelectedMapGetOneEvent>((event, emit) async {
      emit(RouteSelectedMapLoading());
      
      try {
        final route = await routeService.getRoute(event.routeId);
        emit(RouteSelectedMapSuccess(route));
      } catch (e) {
        emit(RouteSelectedMapError("Error crítico al cargar la ruta: $e"));
      }
    });
  }
}
