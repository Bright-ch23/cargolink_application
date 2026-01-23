import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        title: const Text("About Our Project"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Our Team"),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTeamMember(
                  name: "Bright",
                  imageUrl: "assets/images/bright.jpg",
                ),
                _buildTeamMember(
                  name: "Emma",
                  imageUrl: "assets/images/emma.jpg",
                ),
              ],
            ),
            const SizedBox(height: 40),
            _buildSectionTitle("Project Challenges"),
            const SizedBox(height: 15),
            _buildChallengeCard(
              "Backend Integration",
              "Connecting the Flutter frontend with the Django backend was a significant hurdle. We had to resolve CORS issues, manage asynchronous data flow, and ensure the API endpoints for user registration, login, and data fetching were secure and efficient.",
            ),
            const SizedBox(height: 15),
            _buildChallengeCard(
              "Real-time Location Tracking",
              "Implementing live location updates for shipments was complex. We had to find a reliable and battery-efficient way to track carrier locations and broadcast them to the shipper's interface, which involved using WebSockets and background services.",
            ),
             const SizedBox(height: 15),
            _buildChallengeCard(
              "State Management",
              "Managing the app's state, especially with real-time data, required careful planning. We evaluated several state management solutions before settling on one that could handle the complexity of user roles (Shipper vs. Carrier) and dynamic data.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTeamMember({required String name, required String imageUrl}) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.white24,
          backgroundImage: AssetImage(imageUrl), // Use AssetImage for local assets
        ),
        const SizedBox(height: 10),
        Text(
          name,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildChallengeCard(String title, String description) {
    return Card(
      color: const Color(0xFF161B22),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.white12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.blueAccent,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
