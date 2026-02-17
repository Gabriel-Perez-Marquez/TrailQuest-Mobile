import 'package:flutter/material.dart';
import 'package:trailquest_mobile/features/welcome_page/ui/welcome_page_view.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'TrailQuest',
      theme: ThemeData(
        




        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const WelcomePageView(),

    );
  }
}
