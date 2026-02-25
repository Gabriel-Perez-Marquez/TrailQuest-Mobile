part of 'route_selected_map_bloc.dart';

@immutable
sealed class RouteSelectedMapEvent {}

class RouteSelectedMapGetOneEvent extends RouteSelectedMapEvent {
  final int routeId;
  RouteSelectedMapGetOneEvent(this.routeId);
}