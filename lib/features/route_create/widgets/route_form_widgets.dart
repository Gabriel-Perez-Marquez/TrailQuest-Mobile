import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:trailquest_mobile/features/route_create/bloc/route_create_bloc.dart';

class ImageGallerySection extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onAddPhoto;
  final bool isLoading;
  final String? error;

  const ImageGallerySection({
    Key? key,
    this.imagePath,
    required this.onAddPhoto,
    this.isLoading = false,
    this.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'GALLERY',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onAddPhoto,
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white24,
                        width: 2,
                        strokeAlign: BorderSide.strokeAlignOutside,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: imagePath != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(imagePath!),
                              fit: BoxFit.cover,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.photo_camera,
                                color: Color(0xFFB8D4A8),
                                size: 32,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'ADD PHOTO',
                                style: TextStyle(
                                  color: Color(0xFFB8D4A8),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              if (imagePath != null)
                SizedBox(width: 12),
              if (imagePath != null)
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white12,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.image,
                    color: Colors.white12,
                    size: 32,
                  ),
                ),
            ],
          ),
          if (error != null)
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                error!,
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}

class RouteDetailsForm extends StatefulWidget {
  final RouteCreateFormState formState;
  final Function(String) onNameChanged;
  final Function(String) onRegionChanged;
  final Function(String) onDifficultyChanged;
  final Function(double) onDistanceChanged;
  final Function(int) onElevationChanged;
  final Function(String) onDescriptionChanged;

  const RouteDetailsForm({
    Key? key,
    required this.formState,
    required this.onNameChanged,
    required this.onRegionChanged,
    required this.onDifficultyChanged,
    required this.onDistanceChanged,
    required this.onElevationChanged,
    required this.onDescriptionChanged,
  }) : super(key: key);

  @override
  State<RouteDetailsForm> createState() => _RouteDetailsFormState();
}

class _RouteDetailsFormState extends State<RouteDetailsForm> {
  late TextEditingController nameController;
  late TextEditingController distanceController;
  late TextEditingController elevationController;
  late TextEditingController descriptionController;

  final List<String> regions = [
    'ANDALUCIA',
    'ARAGON',
    'ASTURIAS',
    'BALEARES',
    'CANARIAS',
    'CANTABRIA',
    'CASTILLA_LA_MANCHA',
    'CASTILLA_Y_LEON',
    'CATALUNA',
    'COMUNIDAD_VALENCIANA',
    'EXTREMADURA',
    'GALICIA',
    'MADRID',
    'MURCIA',
    'NAVARRA',
    'PAIS_VASCO',
    'LA_RIOJA',
  ];

  final List<String> difficulties = ['FACIL', 'MEDIA', 'DIFICIL', 'EXTREMA'];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.formState.routeName);
    distanceController =
        TextEditingController(text: widget.formState.distance.toString());
    elevationController =
        TextEditingController(text: widget.formState.elevation.toString());
    descriptionController =
        TextEditingController(text: widget.formState.description);
  }

  @override
  void didUpdateWidget(RouteDetailsForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.formState.routeName != widget.formState.routeName) {
      nameController.text = widget.formState.routeName;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    distanceController.dispose();
    elevationController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Route Name
          _buildSectionTitle('ROUTE NAME'),
          SizedBox(height: 12),
          _buildTextField(
            controller: nameController,
            hint: 'E.g. Emerald Valley Loop',
            onChanged: widget.onNameChanged,
          ),
          SizedBox(height: 24),

          // Route Type (Region)
          _buildSectionTitle('REGION'),
          SizedBox(height: 12),
          _buildDropdown(
            value: widget.formState.region,
            items: regions,
            onChanged: widget.onRegionChanged,
          ),
          SizedBox(height: 24),

          // Difficulty
          _buildSectionTitle('DIFFICULTY'),
          SizedBox(height: 12),
          _buildDifficultySelector(
            selectedDifficulty: widget.formState.difficulty,
            onDifficultyChanged: widget.onDifficultyChanged,
          ),
          SizedBox(height: 24),

          // Distance and Elevation
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('LENGTH'),
                    SizedBox(height: 12),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: distanceController,
                        onChanged: (value) {
                          widget.onDistanceChanged(
                            double.tryParse(value) ?? 0.0,
                          );
                        },
                        decoration: InputDecoration(
                          hintText: '0.0',
                          hintStyle: TextStyle(color: Colors.white30),
                          suffix: Text(
                            'KM',
                            style: TextStyle(color: Colors.white60),
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        style: TextStyle(color: Colors.white),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('ELEVATION'),
                    SizedBox(height: 12),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: elevationController,
                        onChanged: (value) {
                          widget.onElevationChanged(
                            int.tryParse(value) ?? 0,
                          );
                        },
                        decoration: InputDecoration(
                          hintText: '0',
                          hintStyle: TextStyle(color: Colors.white30),
                          suffix: Text(
                            'M',
                            style: TextStyle(color: Colors.white60),
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        style: TextStyle(color: Colors.white),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24),

          // Description
          _buildSectionTitle('DESCRIPTION'),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: descriptionController,
              onChanged: widget.onDescriptionChanged,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Tell other hikers what to expect, terrain details, and best views...',
                hintStyle: TextStyle(color: Colors.white30, fontSize: 13),
                border: InputBorder.none,
                isDense: true,
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white70,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.0,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required Function(String) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white30),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 12),
        ),
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required Function(String) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: SizedBox(),
        dropdownColor: Color(0xFF2D5016),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item.replaceAll('_', ' '),
              style: TextStyle(color: Colors.white),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            onChanged(newValue);
          }
        },
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildDifficultySelector({
    required String selectedDifficulty,
    required Function(String) onDifficultyChanged,
  }) {
    return Row(
      children: difficulties.map((difficulty) {
        final isSelected = selectedDifficulty == difficulty;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () => onDifficultyChanged(difficulty),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Color(0xFFB8D4A8) : Colors.white10,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  difficulty,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class TrailheadMapSection extends StatefulWidget {
  final LatLng? location;
  final List<LatLng> pathPoints;
  final Function(LatLng) onLocationSelected;
  final Function(List<LatLng>) onPathPointsChanged;

  const TrailheadMapSection({
    Key? key,
    this.location,
    required this.pathPoints,
    required this.onLocationSelected,
    required this.onPathPointsChanged,
  }) : super(key: key);

  @override
  State<TrailheadMapSection> createState() => _TrailheadMapSectionState();
}

class _TrailheadMapSectionState extends State<TrailheadMapSection> {
  late MapController mapController;
  late List<LatLng> currentPathPoints;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    currentPathPoints = List.from(widget.pathPoints);
  }

  @override
  void didUpdateWidget(TrailheadMapSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    currentPathPoints = List.from(widget.pathPoints);
  }

  void _onMapTap(LatLng point) {
    setState(() {
      currentPathPoints.add(point);
    });
    widget.onPathPointsChanged(currentPathPoints);
  }

  void _clearPath() {
    setState(() {
      currentPathPoints.clear();
    });
    widget.onPathPointsChanged([]);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TRAILHEAD LOCATION',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
            ),
          ),
          SizedBox(height: 16),
          Container(
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white12),
            ),
            child: Stack(
              children: [
                FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    initialCenter: widget.location ?? LatLng(37.7749, -122.4194),
                    initialZoom: 13,
                    onTap: (tapPosition, point) => _onMapTap(point),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    ),
                    if (currentPathPoints.isNotEmpty)
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: currentPathPoints,
                            color: Color(0xFFB8D4A8),
                            strokeWidth: 3,
                          ),
                        ],
                      ),
                    MarkerLayer(
                      markers: [
                        if (widget.location != null)
                          Marker(
                            point: widget.location!,
                            child: Icon(
                              Icons.location_on,
                              color: Color(0xFFB8D4A8),
                              size: 32,
                            ),
                          ),
                        ...currentPathPoints.asMap().entries.map((entry) {
                          final index = entry.key;
                          final point = entry.value;
                          return Marker(
                            point: point,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xFFB8D4A8),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (currentPathPoints.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: FloatingActionButton.small(
                            onPressed: _clearPath,
                            backgroundColor: Colors.red.withOpacity(0.8),
                            child: Icon(Icons.delete, size: 18),
                          ),
                        ),
                      FloatingActionButton.small(
                        onPressed: () {
                          if (widget.location != null) {
                            mapController.move(widget.location!, 15);
                          }
                        },
                        backgroundColor: Color(0xFFB8D4A8),
                        child: Icon(Icons.my_location, size: 18, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Tap on the map to add route points. The first point will be the trailhead location.',
              style: TextStyle(
                color: Colors.white60,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
