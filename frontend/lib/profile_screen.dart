import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.white70),
            title: const Text("About Page", style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pushNamed(context, '/about');
            },
          ),
          // Add other profile options here
        ],
      ),
    );
  }
}
