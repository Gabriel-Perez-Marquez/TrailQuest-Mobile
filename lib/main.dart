import 'package:flutter/material.dart';

import 'features/login/ui/login_view.dart';

import 'package:trailquest_mobile/features/welcome_page/ui/welcome_page_view.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrailQuest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A3A2E),
        ),
        useMaterial3: true,
      ),
,

        
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const WelcomePageView(),

    );
  }
}
