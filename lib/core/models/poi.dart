class POI {
  final int id;
  final String title;
  final double lat;
  final double lon;
  final double rating;
  final int reviews;
  final String difficulty;
  final String duration;
  final String type;
  final String description;
  final String? historicalNote; 
  final List<String> features;
  final String photoFileId;

  POI({
    required this.id,
    required this.title,
    required this.lat,
    required this.lon,
    required this.rating,
    required this.reviews,
    required this.difficulty,
    required this.duration,
    required this.type,
    required this.description,
    this.historicalNote,
    required this.features,
    required this.photoFileId,
  });

  factory POI.fromJson(Map<String, dynamic> json) {
    return POI(
      id: json['id'],
      title: json['title'] ?? 'Sin título',
      lat: (json['lat'] ?? 0.0).toDouble(),
      lon: (json['lon'] ?? 0.0).toDouble(),
      rating: (json['rating'] ?? 0.0).toDouble(), 
      reviews: json['reviews'] ?? 0,
      difficulty: json['difficulty'] ?? 'N/A',
      duration: json['duration'] ?? 'N/A',
      type: json['type'] ?? 'N/A',
      description: json['description'] ?? 'Sin descripción',
      historicalNote: json['historicalNote'], 
      features: json['features'] != null 
          ? List<String>.from(json['features']) 
          : [],
      photoFileId: json['photoFileId'], 
    );
  }
}