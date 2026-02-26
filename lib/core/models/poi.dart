class POI {
  final int id;
  // El backend PoiResponse usa 'name'
  final String name;
  final double lat;
  final double lon;
  final String? photoFileId;
  final int routeId;
  // Campos extra presentes en el modelo Poi pero no en PoiResponse; opcionales
  final double rating;
  final int reviews;
  final String? difficulty;
  final String? duration;
  final String? type;
  final String? description;
  final String? historicalNote;
  final List<String> features;

  POI({
    required this.id,
    required this.name,
    required this.lat,
    required this.lon,
    this.photoFileId,
    required this.routeId,
    this.rating = 0.0,
    this.reviews = 0,
    this.difficulty,
    this.duration,
    this.type,
    this.description,
    this.historicalNote,
    this.features = const [],
  });

  factory POI.fromJson(Map<String, dynamic> json) {
    return POI(
      id: json['id'],
      // El DTO del backend devuelve 'name' (no 'title')
      name: json['name'] ?? json['title'] ?? 'Sin nombre',
      lat: (json['lat'] ?? 0.0).toDouble(),
      lon: (json['lon'] ?? 0.0).toDouble(),
      photoFileId: json['photoFileId'] as String?,
      routeId: json['routeId'] ?? 0,
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviews: json['reviews'] ?? 0,
      difficulty: json['difficulty'] as String?,
      duration: json['duration'] as String?,
      type: json['type'] as String?,
      description: json['description'] as String?,
      historicalNote: json['historicalNote'] as String?,
      features: json['features'] != null
          ? List<String>.from(json['features'])
          : [],
    );
  }
}