import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:trailquest_mobile/core/models/poi.dart';
import 'package:trailquest_mobile/core/services/poi_service.dart';

part 'poi_detail_event.dart';
part 'poi_detail_state.dart';

class PoiDetailBloc extends Bloc<PoiDetailEvent, PoiDetailState> {
  PoiDetailBloc(PoiService poiService) : super(PoiDetailInitial()) {
    on<PoiDetailFetchOneEvent>((event, emit) async {

      emit(PoiDetailLoading());

    try {
      final poi = await poiService.getPoiDetails(event.poiId);
      
      emit(PoiDetailSuccess(poi));
      
    } catch (e) {
      emit(PoiDetailError(e.toString()));
    }


    });
  }
}
