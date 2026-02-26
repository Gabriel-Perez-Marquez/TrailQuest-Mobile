part of 'crear_poi_screen_bloc.dart';

@immutable
sealed class CrearPoiScreenState {}

final class CrearPoiScreenInitial extends CrearPoiScreenState {}

class CrearPoiScreenLoading extends CrearPoiScreenState {}

class CrearPoiScreenSuccess extends CrearPoiScreenState {}

class CrearPoiScreenError extends CrearPoiScreenState {
  final String error;

  CrearPoiScreenError({required this.error});
}
