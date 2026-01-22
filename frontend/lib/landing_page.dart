import 'package:flutter/material.dart';

class CargoLinkLandingPage extends StatelessWidget {
  const CargoLinkLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1A237E), Color(0xFF121212)],
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),
                  // App Branding
                  Row(
                    children: [
                      Image.asset('assets/logos/truck_logo.png', height: 100),
                      const SizedBox(width: 12),
                      const Text(
                        'CargoLink',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  const Text(
                    'Moving Goods Made Simple.',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    'The smartest way to connect Shippers with reliable Carriers. Fast, secure, and transparent.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
                  ),

                  const Spacer(),

                  // Value Props
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildFeatureIcon(Icons.verified_user, "Secure"),
                      _buildFeatureIcon(Icons.bolt, "Fast"),
                      _buildFeatureIcon(Icons.location_on, "Live Track"),
                    ],
                  ),

                  const SizedBox(height: 50),

                  // Primary Action
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/shipper_login'); // Changed from shipper_register
                      },
                      child: const Text(
                        'Get Started as Shipper',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/carrier_login'); // Navigate to carrier login
                      },
                      child: const Text(
                        'Are you a Carrier? Join here',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureIcon(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.blueAccent, size: 30),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)),
      ],
    );
  }
}
