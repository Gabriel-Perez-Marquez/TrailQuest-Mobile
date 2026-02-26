import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trailquest_mobile/core/services/route_service.dart';
import 'package:trailquest_mobile/features/route_create/bloc/route_create_bloc.dart';
import 'package:trailquest_mobile/features/route_create/widgets/route_form_widgets.dart';

class RouteCreateScreen extends StatelessWidget {
  const RouteCreateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RouteCreateBloc(
        routeService: context.read<RouteService>(),
      )..add(InitializeRouteCreateEvent()),
      child: const RouteCreateScreenContent(),
    );
  }
}

class RouteCreateScreenContent extends StatefulWidget {
  const RouteCreateScreenContent({Key? key}) : super(key: key);

  @override
  State<RouteCreateScreenContent> createState() =>
      _RouteCreateScreenContentState();
}

class _RouteCreateScreenContentState extends State<RouteCreateScreenContent> {
  late ScrollController _scrollController;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null && mounted) {
        // First, update the UI with the local image
        context
            .read<RouteCreateBloc>()
            .add(CoverImagePickedEvent(pickedFile.path));

        // Then upload to server
        final fileId =
            await context.read<RouteService>().uploadCoverImage(File(pickedFile.path));
        if (mounted) {
          context
              .read<RouteCreateBloc>()
              .add(CoverImageUploadedEvent(fileId));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al subir la imagen: $e')),
        );
      }
    }
  }

  void _publishRoute() {
    // TODO: Get actual userId from authentication provider
    // This should be extracted from the auth context or service
    // For now, using a placeholder UUID
    const userId = '550e8400-e29b-41d4-a716-446655440000'; 
    context.read<RouteCreateBloc>().add(PublishRouteEvent(userId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RouteCreateBloc, RouteCreateState>(
      listenWhen: (previous, current) =>
          current is RouteCreateSuccess || current is RouteCreateError,
      listener: (context, state) {
        if (state is RouteCreateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('¡Ruta creada exitosamente! ID: ${state.routeId}'),
              backgroundColor: Colors.green,
            ),
          );
          // Navigate back or show success screen
          Navigator.of(context).pop();
        } else if (state is RouteCreateError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Color(0xFF1B3A1B),
        appBar: _buildAppBar(context),
        body: BlocBuilder<RouteCreateBloc, RouteCreateState>(
          builder: (context, state) {
            if (state is RouteCreateLoading) {
              return Center(
                child: CircularProgressIndicator(color: Color(0xFFB8D4A8)),
              );
            }

            if (state is! RouteCreateFormState) {
              return Center(
                child: Text(
                  'Error al cargar el formulario',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            return SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  ImageGallerySection(
                    imagePath: state.coverImagePath,
                    onAddPhoto: _pickAndUploadImage,
                    isLoading: state.isLoadingImage,
                    error: state.imageError,
                  ),
                  RouteDetailsForm(
                    formState: state,
                    onNameChanged: (name) {
                      context
                          .read<RouteCreateBloc>()
                          .add(RouteNameChangedEvent(name));
                    },
                    onRegionChanged: (region) {
                      context
                          .read<RouteCreateBloc>()
                          .add(RegionChangedEvent(region));
                    },
                    onDifficultyChanged: (difficulty) {
                      context
                          .read<RouteCreateBloc>()
                          .add(DifficultyChangedEvent(difficulty));
                    },
                    onDistanceChanged: (distance) {
                      context
                          .read<RouteCreateBloc>()
                          .add(DistanceChangedEvent(distance));
                    },
                    onElevationChanged: (elevation) {
                      context
                          .read<RouteCreateBloc>()
                          .add(ElevationChangedEvent(elevation));
                    },
                    onDescriptionChanged: (description) {
                      context
                          .read<RouteCreateBloc>()
                          .add(DescriptionChangedEvent(description));
                    },
                  ),
                  TrailheadMapSection(
                    location: state.trailheadLocation,
                    pathPoints: state.pathPoints,
                    onLocationSelected: (location) {
                      context
                          .read<RouteCreateBloc>()
                          .add(TrailheadLocationSetEvent(location));
                    },
                    onPathPointsChanged: (pathPoints) {
                      context
                          .read<RouteCreateBloc>()
                          .add(PathPointsChangedEvent(pathPoints));
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: ElevatedButton(
                      onPressed:
                          state.isFormValid ? _publishRoute : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFB8D4A8),
                        disabledBackgroundColor: Colors.white24,
                        minimumSize: Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'PUBLISH',
                        style: TextStyle(
                          color: state.isFormValid ? Colors.black : Colors.white54,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFF1B3A1B),
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.close, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 16),
          child: Center(
            child: Text(
              'New Route',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
