import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:trailquest_mobile/core/services/poi_service.dart';

part 'crear_poi_screen_event.dart';
part 'crear_poi_screen_state.dart';

class CrearPoiScreenBloc extends Bloc<CrearPoiScreenEvent, CrearPoiScreenState> {
  CrearPoiScreenBloc(PoiService poiService) : super(CrearPoiScreenInitial()) {
    on<CreatePoiSubmittedEvent>((event, emit) async {
      emit(CrearPoiScreenLoading());

    try {
      await poiService.createPoi(
        routeId: event.routeId,
        name: event.name,
        lat: event.lat,
        lon: event.lon,
        difficulty: event.difficulty,
        duration: event.duration,
        type: event.type,
        description: event.description,
        historicalNote: event.historicalNote,
        features: event.features,
        photoFileId: event.photoFileId,
      );
      
      emit(CrearPoiScreenSuccess());
      
    } catch (e) {
      emit(CrearPoiScreenError(error: e.toString()));
    }
      
    });
  }
}
