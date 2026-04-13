import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate a delay for loading resources or checking auth status
    Timer(const Duration(seconds: 7), () {
      // Navigate to Login or Dashboard after 3 seconds
      Navigator.pushReplacementNamed(context, '/landing');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background subtle gradient
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Colors.blueAccent.withOpacity(0.1),
                  Colors.transparent,
                ],
                radius: 1.2,
                center: Alignment.center,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25.0),
                  child: Image.asset('assets/logos/truck_logo.png'),
                ),
              ),
              const SizedBox(height: 40),
              // App Name
              const Text(
                "CARGOLINK",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
              const Text(
                "Smart Logistics Marketplace",
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 14,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          // Loading Indicator at the bottom
          const Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
