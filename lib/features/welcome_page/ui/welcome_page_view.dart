import 'package:flutter/material.dart';

class WelcomePageView extends StatelessWidget {
  const WelcomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Stack(
        children: [
          
          Container(
            width: double.infinity,
            height: double.infinity,
            
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          
          Expanded(    
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(height: 90),
                  
                  
                  Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: 46.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1B432D),
                      fontFamily: 'Times New Roman', 
                      letterSpacing: 1.2,
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  ClipOval(
                    child: Container(
                      color: Colors.white70,
                      child: Image.asset(
                        'assets/images/logo.png', 
                        width: 110.0,
                        height: 110.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                 
                  SizedBox(height: 500,), 
                  
                  
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 30.0),
                    child: ElevatedButton(
                      onPressed: () {
                        
                        
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B432D),
                        foregroundColor: Colors.white, 
                        minimumSize: const Size(double.infinity, 55), 
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0), 
                        ),
                        elevation: 4, 
                      ),
                      child: const Text(
                        'Entrar',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}