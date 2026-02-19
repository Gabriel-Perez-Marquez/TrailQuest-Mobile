class POI {
  final String title;
  final String location;
  final double rating;
  final int reviews;
  final String difficulty;
  final String duration;
  final String type;
  final String description;
  final String? historicalNote; 
  final List<String> features;
  final String imageUrl;

  POI({
    required this.title,
    required this.location,
    required this.rating,
    required this.reviews,
    required this.difficulty,
    required this.duration,
    required this.type,
    required this.description,
    this.historicalNote,
    required this.features,
    required this.imageUrl,
  });

  factory POI.fromJson(Map<String, dynamic> json) {
    return POI(
      title: json['title'] ?? 'Sin título',
      location: json['location'] ?? 'Ubicación desconocida',
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
      imageUrl: json['imageUrl'] ?? 'https://via.placeholder.com/400', 
    );
  }
}