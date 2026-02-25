import 'package:flutter/material.dart';
import 'package:trailquest_mobile/core/models/route_response.dart';
import 'package:trailquest_mobile/core/services/route_service.dart';

class UserProfilePage extends StatefulWidget {
  final String? username;

  const UserProfilePage({super.key, this.username});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late String _currentUsername;
  late String _currentUserAvatar;
  late TrailRoute? _lastRoute;
  bool _isLoading = true;
  bool _hasError = false;

  final RouteService _routeService = RouteService();

  @override
  void initState() {
    super.initState();
    _currentUsername = widget.username ?? 'Usuario';
    _currentUserAvatar = _currentUsername.isNotEmpty 
        ? _currentUsername[0].toUpperCase() 
        : 'U';
    _lastRoute = null;
    _loadLastRoute();
  }

  Future<void> _loadLastRoute() async {
    try {
      // Intenta cargar la ruta con ID 1 como ejemplo
      // En una aplicación real, esto vendría del usuario actual
      final route = await _routeService.getRoute(1);
      setState(() {
        _lastRoute = route;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      print('Error cargando última ruta: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F0),
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              // Handle settings navigation
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Card
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFCEDF8F), Color(0xFFC5D88E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Avatar
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 4,
                            ),
                            color: const Color(0xFFFCE4EC),
                          ),
                          child: Center(
                            child: Text(
                              _currentUserAvatar,
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFF48FB1),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // User Name
                    Text(
                      _currentUsername,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D5016),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Location
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: Color(0xFF6B8E23),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Seattle, WA',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B8E23),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Stats
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _StatItem(
                          value: '142',
                          label: 'KM HIKED',
                        ),
                        _StatItem(
                          value: '28',
                          label: 'HIKES',
                        ),
                        _StatItem(
                          value: '12',
                          label: 'BADGES',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Earned Badges Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Earned Badges',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Handle view all badges
                        },
                        child: const Text(
                          'View all',
                          style: TextStyle(
                            color: Color(0xFF9DB92C),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _BadgeItem(
                          icon: Icons.wb_sunny,
                          label: 'Early Bird',
                          iconColor: const Color(0xFFFDB833),
                        ),
                        const SizedBox(width: 12),
                        _BadgeItem(
                          icon: Icons.terrain,
                          label: 'Peak Hunter',
                          iconColor: const Color(0xFF5DADE2),
                        ),
                        const SizedBox(width: 12),
                        _BadgeItem(
                          icon: Icons.nature,
                          label: 'Tree Hugger',
                          iconColor: const Color(0xFF52BE80),
                        ),
                        const SizedBox(width: 12),
                        _BadgeItem(
                          icon: Icons.water_drop,
                          label: 'Rain Rider',
                          iconColor: const Color(0xFFAED6F1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Recent Activity Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Activity',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Handle view history
                        },
                        child: const Text(
                          'History',
                          style: TextStyle(
                            color: Color(0xFF9DB92C),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_isLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                  else if (_hasError || _lastRoute == null)
                    _ActivityCard(
                      title: 'No hay rutas disponibles',
                      date: 'Sin datos',
                      distance: '0km',
                      duration: '0h 0m',
                      onTap: () {
                        // Handle activity tap
                      },
                    )
                  else
                    _ActivityCard(
                      title: _lastRoute!.title,
                      date: 'Ruta completada',
                      distance: '${_lastRoute!.distanceKm.toStringAsFixed(1)}km',
                      duration: '${(_lastRoute!.distanceKm / 3).toStringAsFixed(0)}h ${(((_lastRoute!.distanceKm % 3) / 3) * 60).toStringAsFixed(0)}m',
                      onTap: () {
                        // Handle activity tap
                      },
                    ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2D5016),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF6B8E23),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _BadgeItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;

  const _BadgeItem({
    required this.icon,
    required this.label,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              icon,
              size: 40,
              color: iconColor,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 80,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final String title;
  final String date;
  final String distance;
  final String duration;
  final VoidCallback onTap;

  const _ActivityCard({
    required this.title,
    required this.date,
    required this.distance,
    required this.duration,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image placeholder
            Container(
              width: 100,
              height: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  bottomLeft: const Radius.circular(12),
                ),
                child: Image.network(
                  'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=400&fit=crop',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFFE8E8E8),
                      child: const Icon(
                        Icons.image,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          date,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.straighten,
                          size: 16,
                          color: const Color(0xFF9DB92C),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          distance,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF9DB92C),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.schedule,
                          size: 16,
                          color: const Color(0xFF9DB92C),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          duration,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF9DB92C),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Arrow
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Icon(
                Icons.chevron_right,
                color: const Color(0xFF9DB92C),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
