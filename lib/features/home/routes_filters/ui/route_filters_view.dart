import 'package:flutter/material.dart';
import 'package:trailquest_mobile/features/home/routes_filters/widgets/difficultyCard.dart';

class RouteFiltersView extends StatefulWidget {
  const RouteFiltersView({super.key});

  @override
  State<RouteFiltersView> createState() => _RouteFiltersViewState();
}

class _RouteFiltersViewState extends State<RouteFiltersView> {
  String difficulty = 'Easy';
  double maxDistance = 40;
  String routeType = 'Out & Back';
  String region = 'All regions';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1F17),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1F17),
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 64,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFF1E432B),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, size: 18),
                color: Colors.white,
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ),
            const Text(
              'Filters',
              style: TextStyle(
                color: Color(0xFFEDF7D1),
                fontSize: 26,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  difficulty = 'Easy';
                  maxDistance = 40;
                  routeType = 'Out & Back';
                  region = 'All regions';
                });
              },
              child: const Text(
                'RESET',
                style: TextStyle(
                  color: Color(0xFFD2E993),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: ListView(
          children: [
            const SizedBox(height: 16),
            const Text(
              'DIFFICULTY',
              style: TextStyle(
                color: Color(0xFFD2E993),
                fontSize: 14,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DifficultyCard(
                  label: 'Easy',
                  selectedLabel: difficulty,
                  color: const Color(0xFF46E071),
                  onSelected: (value) => setState(() => difficulty = value),
                ),
                DifficultyCard(
                  label: 'Moderate',
                  selectedLabel: difficulty,
                  color: const Color(0xFFFFB769),
                  onSelected: (value) => setState(() => difficulty = value),
                ),
                DifficultyCard(
                  label: 'Hard',
                  selectedLabel: difficulty,
                  color: const Color(0xFFFF7B7B),
                  onSelected: (value) => setState(() => difficulty = value),
                ),
                DifficultyCard(
                  label: 'Extreme',
                  selectedLabel: difficulty,
                  color: const Color(0xFFFF4545),
                  onSelected: (value) => setState(() => difficulty = value),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'LENGTH (Km)',
              style: TextStyle(
                color: Color(0xFFD2E993),
                fontSize: 14,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF1E432B),
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
