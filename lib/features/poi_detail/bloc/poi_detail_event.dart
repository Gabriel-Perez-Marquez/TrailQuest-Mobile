part of 'poi_detail_bloc.dart';

@immutable
sealed class PoiDetailEvent {}


class PoiDetailFetchOneEvent extends PoiDetailEvent {
  final String poiId;
  
  PoiDetailFetchOneEvent(this.poiId);
}