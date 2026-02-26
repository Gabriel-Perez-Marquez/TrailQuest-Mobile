part of 'crear_poi_screen_bloc.dart';

@immutable
sealed class CrearPoiScreenEvent {}


class CreatePoiSubmittedEvent extends CrearPoiScreenEvent {
  final int routeId;
  final String name;
  final double lat;
  final double lon;
  final String difficulty;
  final String duration;
  final String type;
  final String description;
  final String historicalNote;
  final List<String> features;
  final String? photoFileId; 

  CreatePoiSubmittedEvent({
    required this.routeId,
    required this.name,
    required this.lat,
    required this.lon,
    required this.difficulty,
    required this.duration,
    required this.type,
    required this.description,
    required this.historicalNote,
    required this.features,
    this.photoFileId,
  });
}