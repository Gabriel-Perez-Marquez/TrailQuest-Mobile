part of 'route_create_bloc.dart';

@immutable
abstract class RouteCreateEvent {}

class InitializeRouteCreateEvent extends RouteCreateEvent {}

class RouteNameChangedEvent extends RouteCreateEvent {
  final String name;
  RouteNameChangedEvent(this.name);
}

class RegionChangedEvent extends RouteCreateEvent {
  final String region;
  RegionChangedEvent(this.region);
}

class DifficultyChangedEvent extends RouteCreateEvent {
  final String difficulty;
  DifficultyChangedEvent(this.difficulty);
}

class DistanceChangedEvent extends RouteCreateEvent {
  final double distance;
  DistanceChangedEvent(this.distance);
}

class ElevationChangedEvent extends RouteCreateEvent {
  final int elevation;
  ElevationChangedEvent(this.elevation);
}

class DescriptionChangedEvent extends RouteCreateEvent {
  final String description;
  DescriptionChangedEvent(this.description);
}

class CoverImagePickedEvent extends RouteCreateEvent {
  final String imagePath;
  CoverImagePickedEvent(this.imagePath);
}

class CoverImageUploadedEvent extends RouteCreateEvent {
  final String fileId;
  CoverImageUploadedEvent(this.fileId);
}

class TrailheadLocationSetEvent extends RouteCreateEvent {
  final LatLng location;
  TrailheadLocationSetEvent(this.location);
}

class PathPointAddedEvent extends RouteCreateEvent {
  final LatLng point;
  PathPointAddedEvent(this.point);
}

class PathPointsChangedEvent extends RouteCreateEvent {
  final List<LatLng> pathPoints;
  PathPointsChangedEvent(this.pathPoints);
}

class PublishRouteEvent extends RouteCreateEvent {
  final String userId;
  PublishRouteEvent(this.userId);
}

class ResetFormEvent extends RouteCreateEvent {}
