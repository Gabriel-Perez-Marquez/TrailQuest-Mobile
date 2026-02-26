part of 'route_create_bloc.dart';

@immutable
abstract class RouteCreateState {}

class RouteCreateInitial extends RouteCreateState {}

class RouteCreateLoading extends RouteCreateState {}

class RouteCreateSuccess extends RouteCreateState {
  final int routeId;
  RouteCreateSuccess(this.routeId);
}

class RouteCreateError extends RouteCreateState {
  final String message;
  RouteCreateError(this.message);
}

class RouteCreateFormState extends RouteCreateState {
  final String routeName;
  final String region;
  final double distance;
  final String difficulty;
  final int elevation;
  final String description;
  final String? coverImagePath;
  final String? coverFileId;
  final LatLng? trailheadLocation;
  final List<LatLng> pathPoints;
  final bool isLoadingImage;
  final String? imageError;

  RouteCreateFormState({
    this.routeName = '',
    this.region = 'ANDALUCIA',
    this.distance = 0.0,
    this.difficulty = 'MEDIA',
    this.elevation = 0,
    this.description = '',
    this.coverImagePath,
    this.coverFileId,
    this.trailheadLocation,
    this.pathPoints = const [],
    this.isLoadingImage = false,
    this.imageError,
  });

  RouteCreateFormState copyWith({
    String? routeName,
    String? region,
    double? distance,
    String? difficulty,
    int? elevation,
    String? description,
    String? coverImagePath,
    String? coverFileId,
    LatLng? trailheadLocation,
    List<LatLng>? pathPoints,
    bool? isLoadingImage,
    String? imageError,
  }) {
    return RouteCreateFormState(
      routeName: routeName ?? this.routeName,
      region: region ?? this.region,
      distance: distance ?? this.distance,
      difficulty: difficulty ?? this.difficulty,
      elevation: elevation ?? this.elevation,
      description: description ?? this.description,
      coverImagePath: coverImagePath ?? this.coverImagePath,
      coverFileId: coverFileId ?? this.coverFileId,
      trailheadLocation: trailheadLocation ?? this.trailheadLocation,
      pathPoints: pathPoints ?? this.pathPoints,
      isLoadingImage: isLoadingImage ?? this.isLoadingImage,
      imageError: imageError ?? this.imageError,
    );
  }

  bool get isFormValid =>
      routeName.isNotEmpty &&
      distance > 0.1 &&
      elevation >= 0 &&
      coverFileId != null &&
      coverFileId!.isNotEmpty &&
      pathPoints.isNotEmpty;
}
