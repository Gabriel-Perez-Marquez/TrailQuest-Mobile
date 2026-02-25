part of 'route_selected_map_bloc.dart';

@immutable
sealed class RouteSelectedMapState {}

final class RouteSelectedMapInitial extends RouteSelectedMapState {}

class RouteSelectedMapLoading extends RouteSelectedMapState {}

class RouteSelectedMapSuccess extends RouteSelectedMapState {
  final TrailRoute route;
  RouteSelectedMapSuccess(this.route);
}

class RouteSelectedMapError extends RouteSelectedMapState {
  final String message;
  RouteSelectedMapError(this.message);
}