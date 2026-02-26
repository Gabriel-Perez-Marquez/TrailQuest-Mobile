import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:trailquest_mobile/core/services/route_service.dart';

part 'route_create_event.dart';
part 'route_create_state.dart';

class RouteCreateBloc extends Bloc<RouteCreateEvent, RouteCreateState> {
  final RouteService routeService;
  final ImagePicker _imagePicker = ImagePicker();

  RouteCreateBloc({required this.routeService})
      : super(RouteCreateFormState()) {
    on<InitializeRouteCreateEvent>(_onInitialize);
    on<RouteNameChangedEvent>(_onRouteNameChanged);
    on<RegionChangedEvent>(_onRegionChanged);
    on<DifficultyChangedEvent>(_onDifficultyChanged);
    on<DistanceChangedEvent>(_onDistanceChanged);
    on<ElevationChangedEvent>(_onElevationChanged);
    on<DescriptionChangedEvent>(_onDescriptionChanged);
    on<CoverImagePickedEvent>(_onCoverImagePicked);
    on<CoverImageUploadedEvent>(_onCoverImageUploaded);
    on<TrailheadLocationSetEvent>(_onTrailheadLocationSet);
    on<PathPointAddedEvent>(_onPathPointAdded);
    on<PathPointsChangedEvent>(_onPathPointsChanged);
    on<PublishRouteEvent>(_onPublishRoute);
    on<ResetFormEvent>(_onResetForm);
  }

  Future<void> _onInitialize(
    InitializeRouteCreateEvent event,
    Emitter<RouteCreateState> emit,
  ) async {
    emit(RouteCreateFormState());
  }

  Future<void> _onRouteNameChanged(
    RouteNameChangedEvent event,
    Emitter<RouteCreateState> emit,
  ) async {
    final currentState = state;
    if (currentState is RouteCreateFormState) {
      emit(currentState.copyWith(routeName: event.name));
    }
  }

  Future<void> _onRegionChanged(
    RegionChangedEvent event,
    Emitter<RouteCreateState> emit,
  ) async {
    final currentState = state;
    if (currentState is RouteCreateFormState) {
      emit(currentState.copyWith(region: event.region));
    }
  }

  Future<void> _onDifficultyChanged(
    DifficultyChangedEvent event,
    Emitter<RouteCreateState> emit,
  ) async {
    final currentState = state;
    if (currentState is RouteCreateFormState) {
      emit(currentState.copyWith(difficulty: event.difficulty));
    }
  }

  Future<void> _onDistanceChanged(
    DistanceChangedEvent event,
    Emitter<RouteCreateState> emit,
  ) async {
    final currentState = state;
    if (currentState is RouteCreateFormState) {
      emit(currentState.copyWith(distance: event.distance));
    }
  }

  Future<void> _onElevationChanged(
    ElevationChangedEvent event,
    Emitter<RouteCreateState> emit,
  ) async {
    final currentState = state;
    if (currentState is RouteCreateFormState) {
      emit(currentState.copyWith(elevation: event.elevation));
    }
  }

  Future<void> _onDescriptionChanged(
    DescriptionChangedEvent event,
    Emitter<RouteCreateState> emit,
  ) async {
    final currentState = state;
    if (currentState is RouteCreateFormState) {
      emit(currentState.copyWith(description: event.description));
    }
  }

  Future<void> _onCoverImagePicked(
    CoverImagePickedEvent event,
    Emitter<RouteCreateState> emit,
  ) async {
    final currentState = state;
    if (currentState is RouteCreateFormState) {
      emit(currentState.copyWith(coverImagePath: event.imagePath));
      // TODO: Upload image and get fileId
    }
  }

  Future<void> _onCoverImageUploaded(
    CoverImageUploadedEvent event,
    Emitter<RouteCreateState> emit,
  ) async {
    final currentState = state;
    if (currentState is RouteCreateFormState) {
      emit(currentState.copyWith(coverFileId: event.fileId));
    }
  }

  Future<void> _onTrailheadLocationSet(
    TrailheadLocationSetEvent event,
    Emitter<RouteCreateState> emit,
  ) async {
    final currentState = state;
    if (currentState is RouteCreateFormState) {
      emit(currentState.copyWith(trailheadLocation: event.location));
      // Agregar el punto inicial a la ruta
      emit(currentState.copyWith(
        trailheadLocation: event.location,
        pathPoints: [event.location],
      ));
    }
  }

  Future<void> _onPathPointAdded(
    PathPointAddedEvent event,
    Emitter<RouteCreateState> emit,
  ) async {
    final currentState = state;
    if (currentState is RouteCreateFormState) {
      final updatedPoints = [...currentState.pathPoints, event.point];
      emit(currentState.copyWith(pathPoints: updatedPoints));
    }
  }

  Future<void> _onPathPointsChanged(
    PathPointsChangedEvent event,
    Emitter<RouteCreateState> emit,
  ) async {
    final currentState = state;
    if (currentState is RouteCreateFormState) {
      emit(currentState.copyWith(pathPoints: event.pathPoints));
    }
  }

  Future<void> _onPublishRoute(
    PublishRouteEvent event,
    Emitter<RouteCreateState> emit,
  ) async {
    final currentState = state;
    if (currentState is! RouteCreateFormState) return;

    if (!currentState.isFormValid) {
      emit(RouteCreateError('Por favor completa todos los campos requeridos'));
      return;
    }

    emit(RouteCreateLoading());

    try {
      final route = await routeService.createRoute(
        title: currentState.routeName,
        region: currentState.region,
        distanceKm: currentState.distance,
        difficulty: currentState.difficulty,
        creatorId: event.userId,
        coverFileId: currentState.coverFileId!,
        elevation: currentState.elevation,
        pathPoints: currentState.pathPoints,
      );

      emit(RouteCreateSuccess(route.id));
    } catch (e) {
      emit(RouteCreateError('Error al crear la ruta: ${e.toString()}'));
    }
  }

  Future<void> _onResetForm(
    ResetFormEvent event,
    Emitter<RouteCreateState> emit,
  ) async {
    emit(RouteCreateFormState());
  }

  Future<String?> pickImage() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        return pickedFile.path;
      }
    } catch (e) {
      // Error picking image
    }
    return null;
  }
}
