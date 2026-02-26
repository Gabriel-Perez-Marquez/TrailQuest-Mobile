part of 'general_map_bloc.dart';

@immutable
sealed class GeneralMapState {}

final class GeneralMapInitial extends GeneralMapState {}

final class GeneralMapLoading extends GeneralMapState {}

final class GeneralMapSuccess extends GeneralMapState {
  final List<TrailRoute> listaRoutes;

  GeneralMapSuccess({required this.listaRoutes});
}

final class GeneralMapError extends GeneralMapState {
  final String message;

  GeneralMapError({required this.message});
}
