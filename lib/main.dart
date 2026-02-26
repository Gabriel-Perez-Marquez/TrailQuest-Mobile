import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trailquest_mobile/features/user/ui/user_profile.dart';
import 'package:trailquest_mobile/core/services/theme_service.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, _) {
        return MaterialApp(
          title: 'TrailQuest',
          theme: themeService.getLightTheme(),
          darkTheme: themeService.getDarkTheme(),
          themeMode: themeService.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const UserProfilePage(),
        );
      },
    );
  }
}
