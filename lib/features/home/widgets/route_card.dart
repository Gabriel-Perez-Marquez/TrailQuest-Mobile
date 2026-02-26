import 'package:flutter/material.dart';
import 'package:trailquest_mobile/core/models/route_response.dart';

class RouteCard extends StatefulWidget {
  final TrailRoute route;
  final VoidCallback onTap;

  const RouteCard({
    super.key,
    required this.route,
    required this.onTap,
  });

  @override
  State<RouteCard> createState() => _RouteCardState();
}

class _RouteCardState extends State<RouteCard> {
  bool isFavorite = false;

  String _calculateEstimatedTime() {
    // Estimación básica: 5 km/h velocidad promedio
    final hours = widget.route.distanceKm / 5;
    final totalMinutes = (hours * 60).round();
    final h = totalMinutes ~/ 60;
    final min = totalMinutes % 60;
    
    if (h > 0) {
      return '${h}h ${min} min';
    }
    return '${min} min';
  }

  Widget _buildDifficultyIcon() {
    Color color;
    final difficultyLower = widget.route.difficulty.toLowerCase();
    
    if (difficultyLower.contains('easy') || difficultyLower.contains('fácil') || difficultyLower == 'easy') {
      color = const Color(0xFF4CAF50); // Verde
    } else if (difficultyLower.contains('moderate') || difficultyLower.contains('moderado') || difficultyLower == 'moderate') {
      color = const Color(0xFFFF9800); // Naranja
    } else if (difficultyLower.contains('hard') || difficultyLower.contains('difícil') || difficultyLower.contains('dificil') || difficultyLower == 'hard') {
      color = const Color(0xFFF44336); // Rojo
    } else {
      color = const Color(0xFFFF9800); // Por defecto naranja
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section with favorite button
            Stack(
              children: [
                Container(
                  height: 240,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    color: const Color(0xFFD2E993),
                    image: widget.route.coverFileId.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage('http://10.0.2.2:8080/files/${widget.route.coverFileId}'),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                ),
                // Favorite button
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey[600],
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Content section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    widget.route.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F1F17),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Subtitle (region)
                  Text(
                    widget.route.region,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  
                  // Bottom row with difficulty, distance and time
                  Row(
                    children: [
                      _buildDifficultyIcon(),
                      const SizedBox(width: 8),
                      Text(
                        widget.route.difficulty,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F1F17),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${widget.route.distanceKm}km',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F1F17),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        _calculateEstimatedTime(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F1F17),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
