part of 'poi_detail_bloc.dart';

@immutable
sealed class PoiDetailState {}

final class PoiDetailInitial extends PoiDetailState {}


final class PoiDetailLoading extends PoiDetailState {}


final class PoiDetailSuccess extends PoiDetailState {
  final POI poi;
  PoiDetailSuccess(this.poi);
}


final class PoiDetailError extends PoiDetailState {
  final String message;
  PoiDetailError(this.message);
}