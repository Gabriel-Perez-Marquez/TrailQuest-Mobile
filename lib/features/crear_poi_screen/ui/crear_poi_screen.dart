import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailquest_mobile/core/services/poi_service.dart';
import 'package:trailquest_mobile/features/crear_poi_screen/bloc/crear_poi_screen_bloc.dart';


class CreatePoiScreen extends StatelessWidget {
  final int routeId;
  const CreatePoiScreen({super.key, required this.routeId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CrearPoiScreenBloc(PoiService()),
      child: _CreatePoiScreenContent(routeId: routeId),
    );
  }
}

class _CreatePoiScreenContent extends StatefulWidget {
  final int routeId;
  const _CreatePoiScreenContent({required this.routeId});

  @override
  State<_CreatePoiScreenContent> createState() => _CreatePoiScreenContentState();
}

class _CreatePoiScreenContentState extends State<_CreatePoiScreenContent> {
  final Color bgColor = const Color(0xFF1B3824);
  final Color fieldColor = const Color(0xFF295738);
  final Color accentColor = const Color(0xFFD4A351);
  final Color textHintColor = const Color(0xFF7BA082);

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _historyController = TextEditingController();
  final TextEditingController _featuresController = TextEditingController();

  String? _selectedDifficulty;
  String? _selectedType;
  double? _selectedLat;
  double? _selectedLon;
  String? _uploadedPhotoFileId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leadingWidth: 80,
        leading: TextButton(
          onPressed: () {
            // NAVEGACIÓN SEGURA: Solo vuelve atrás si realmente hay historial
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              print("Estás probando la pantalla directa: No se puede volver atrás.");
            }
          },
          child: Text(
            'Cancel',
            style: TextStyle(color: accentColor, fontSize: 16),
          ),
        ),
        title: const Text(
          'Create POI',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- GENERAL INFO & DETAILS ---
            _buildSectionHeader(Icons.info_outline, 'GENERAL INFO & DETAILS'),
            const SizedBox(height: 12),
            _buildLabel('POI Name'),
            _buildTextField(
              controller: _nameController,
              hintText: 'e.g., Whispering Pines Overlook',
            ),
            const SizedBox(height: 16),

            // Campos añadidos del modelo: Type, Difficulty, Duration
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Type'),
                      _buildDropdown(
                        value: _selectedType,
                        hint: 'e.g., Viewpoint',
                        items: ['Viewpoint', 'Historical', 'Rest Area', 'Landmark'],
                        onChanged: (val) => setState(() => _selectedType = val),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Difficulty'),
                      _buildDropdown(
                        value: _selectedDifficulty,
                        hint: 'e.g., Moderate',
                        items: ['Easy', 'Moderate', 'Hard', 'Expert'],
                        onChanged: (val) => setState(() => _selectedDifficulty = val),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildLabel('Duration'),
            _buildTextField(
              controller: _durationController,
              hintText: 'e.g., 2 hours, 30 mins',
            ),
            const SizedBox(height: 24),

            // --- LOCATION (lat, lon) ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionHeader(Icons.location_on_outlined, 'LOCATION'),
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.edit_location_alt_outlined, color: accentColor, size: 16),
                  label: Text('ADJUST', style: TextStyle(color: accentColor, fontSize: 12, fontWeight: FontWeight.bold)),
                )
              ],
            ),
            _buildMapPlaceholder(),
            const SizedBox(height: 24),

            // --- IMAGES (photoFileId) ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionHeader(Icons.image_outlined, 'IMAGE'),
                const Text('0 / 1', style: TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 12),
            _buildImagePickerPlaceholder(),
            const SizedBox(height: 24),

            // --- FEATURES (List<String>) ---
            _buildSectionHeader(Icons.featured_play_list_outlined, 'FEATURES'),
            const SizedBox(height: 12),
            _buildLabel('Facilities and features'),
            _buildTextField(
              controller: _featuresController,
              hintText: 'e.g., Parking, Water, Restrooms (comma separated)',
            ),
            const SizedBox(height: 24),

            // --- DESCRIPTION ---
            _buildSectionHeader(Icons.description_outlined, 'DESCRIPTION'),
            const SizedBox(height: 12),
            _buildLabel('Interesting Description'),
            _buildTextField(
              controller: _descriptionController,
              hintText: 'Tell others what makes this spot special...',
              maxLines: 4,
            ),
            const SizedBox(height: 24),

            // --- HISTORY (historicalNote) ---
            _buildSectionHeader(Icons.history_edu_outlined, 'HISTORY'),
            const SizedBox(height: 12),
            _buildLabel('Historical Information'),
            _buildTextField(
              controller: _historyController,
              hintText: 'Share local legends, heritage, or geological history...',
              maxLines: 4,
            ),
            const SizedBox(height: 32),

            // --- CREATE BUTTON ---
            SizedBox(
              width: double.infinity,
              height: 56,
              child: BlocConsumer<CrearPoiScreenBloc, CrearPoiScreenState>(
                listener: (context, state) {
                  if (state is CrearPoiScreenSuccess) {
                    final messenger = ScaffoldMessenger.of(context);
                    
                    // NAVEGACIÓN SEGURA AL GUARDAR
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context); 
                    }

                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text('POI creado con éxito! 🏔️'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else if (state is CrearPoiScreenError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: ${state.error}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is CrearPoiScreenLoading) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: null,
                      child: const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      ),
                    );
                  }

                  return ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: bgColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: const Icon(Icons.add_location_alt_outlined),
                    label: const Text(
                      'CREATE POI',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      if (_nameController.text.isEmpty || 
                          _selectedType == null || 
                          _selectedDifficulty == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Rellena Nombre, Tipo y Dificultad.'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                        return;
                      }

                      if (_selectedLat == null || _selectedLon == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Por favor, selecciona una ubicación en el mapa.'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                        return;
                      }

                      List<String> featureList = _featuresController.text
                          .split(',')
                          .map((e) => e.trim())
                          .where((e) => e.isNotEmpty)
                          .toList();

                      context.read<CrearPoiScreenBloc>().add(
                        CreatePoiSubmittedEvent(
                          routeId: widget.routeId, 
                          name: _nameController.text,
                          lat: _selectedLat!, 
                          lon: _selectedLon!, 
                          difficulty: _selectedDifficulty!,
                          duration: _durationController.text,
                          type: _selectedType!,
                          description: _descriptionController.text,
                          historicalNote: _historyController.text,
                          features: featureList,
                          photoFileId: _uploadedPhotoFileId, 
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS AUXILIARES ---

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 14),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: textHintColor),
        filled: true,
        fillColor: fieldColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: fieldColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint, style: TextStyle(color: textHintColor)),
          dropdownColor: fieldColor,
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down, color: textHintColor),
          style: const TextStyle(color: Colors.white),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildMapPlaceholder() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: fieldColor,
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: NetworkImage('https://www.transparenttextures.com/patterns/cubes.png'), 
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: accentColor.withOpacity(0.9),
            foregroundColor: bgColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          icon: const Icon(Icons.touch_app),
          label: const Text('TAP TO SELECT ON MAP', style: TextStyle(fontWeight: FontWeight.bold)),
          onPressed: () {
            print("Abrir mapa pulsado");
          },
        ),
      ),
    );
  }

  Widget _buildImagePickerPlaceholder() {
    return Row(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: fieldColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: textHintColor, style: BorderStyle.solid, width: 1.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 28),
              const SizedBox(height: 4),
              const Text('ADD PHOTO', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }
}