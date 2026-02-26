import 'package:flutter/material.dart';
import 'package:trailquest_mobile/core/widgets/custom_bottom_nav_bar.dart';
import 'package:trailquest_mobile/features/home/ui/home_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(), // ✅ Tu pantalla real de Explore
    const SavedPage(),
    const CheckInsPage(),
    const NavigatePage(),
    const ActivityPage(),
    const ProfilePage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}

class SavedPage extends StatelessWidget {
  const SavedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Trails'),
        backgroundColor: const Color(0xFF1B512D),
      ),
      body: const Center(
        child: Text('Rutas guardadas'),
      ),
    );
  }
}

class CheckInsPage extends StatelessWidget {
  const CheckInsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-in History'),
        backgroundColor: const Color(0xFF1B512D),
      ),
      body: const Center(
        child: Text('Historial de check-ins'),
      ),
    );
  }
}

class NavigatePage extends StatelessWidget {
  const NavigatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigate'),
        backgroundColor: const Color(0xFF1B512D),
      ),
      body: const Center(
        child: Text('Navegación de ruta'),
      ),
    );
  }
}

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity'),
        backgroundColor: const Color(0xFF1B512D),
      ),
      body: const Center(
        child: Text('Actividad y estadísticas'),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFF1B512D),
      ),
      body: const Center(
        child: Text('Perfil de usuario'),
      ),
    );
  }
}
