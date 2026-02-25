part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class HomeLoadRoutes extends HomeEvent {
  final String? query;
  final String? difficulty;
  final double? maxDistance;
  final String? region;

  HomeLoadRoutes({
    this.query,
    this.difficulty,
    this.maxDistance,
    this.region,
  });
}

class HomeRefresh extends HomeEvent {}
