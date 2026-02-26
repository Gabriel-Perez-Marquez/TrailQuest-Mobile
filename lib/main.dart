import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailquest_mobile/core/services/route_service.dart';
import 'package:trailquest_mobile/features/user/ui/user_profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<RouteService>(
          create: (context) => RouteService(),
        ),
      ],
      child: MaterialApp(
        title: 'TrailQuest',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1B512D)),
          useMaterial3: true,
        ),
        home: const UserProfilePage(),
      ),
    );
  }
}
