import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:trailquest_mobile/core/models/route_response.dart';
import 'package:trailquest_mobile/core/services/route_service.dart';

part 'general_map_event.dart';
part 'general_map_state.dart';

class GeneralMapBloc extends Bloc<GeneralMapEvent, GeneralMapState> {
  GeneralMapBloc(RouteService routeService) : super(GeneralMapInitial()) {
    on<GeneralMapFetchAllRoutesEvent>((event, emit) async {

      emit(GeneralMapLoading());

      try{
        final listaRoutes = await routeService.getAllRoutes();

        print(listaRoutes);
        emit(GeneralMapSuccess(listaRoutes: listaRoutes));
      } catch (e){
        emit(GeneralMapError(message: e.toString()));
      }

    });
  }
}
