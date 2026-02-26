import 'package:flutter/material.dart';
import 'package:trailquest_mobile/features/welcome_page/ui/welcome_page_view.dart';
import 'package:trailquest_mobile/core/services/token_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final tokenService = TokenService();
  final token = await tokenService.getToken();
  final username = await tokenService.getUsername();
  
  if (token != null) {
    print('TOKEN ENCONTRADO:');
    print('   Username: $username');
    print('   Token: ${token.substring(0, 20)}...');
  } else {
    print('No hay token guardado (usuario no autenticado)');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'TrailQuest',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1B512D)),
        useMaterial3: true,
      ),
      home: const WelcomePageView(),
    );
  }
}
