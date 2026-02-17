import 'package:flutter/material.dart';

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
                color: Color (0xFFEDF7D1),
                fontSize: 26,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: (){
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
                  color: Color (0xFFD2E993),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}