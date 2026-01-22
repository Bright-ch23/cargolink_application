import 'package:flutter/material.dart';

class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({super.key});

  @override
  State<PrivacySecurityScreen> createState() => _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends State<PrivacySecurityScreen> {
  // Mock states for toggles
  bool _isTwoFactorEnabled = true;
  bool _isBiometricsEnabled = false;
  bool _isLocationSharingEnabled = true;
  bool _isDataAnalyticsEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        title: const Text("Privacy & Security"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSectionHeader("Account Security"),
          _buildSecurityTile(
            title: "Two-Factor Authentication",
            subtitle: "Secure your account with a secondary code.",
            icon: Icons.enhanced_encryption_outlined,
            trailing: Switch(
              value: _isTwoFactorEnabled,
              onChanged: (val) => setState(() => _isTwoFactorEnabled = val),
              activeColor: Colors.blueAccent,
            ),
          ),
          _buildSecurityTile(
            title: "Biometric Login",
            subtitle: "Use FaceID or Fingerprint to unlock.",
            icon: Icons.fingerprint,
            trailing: Switch(
              value: _isBiometricsEnabled,
              onChanged: (val) => setState(() => _isBiometricsEnabled = val),
              activeColor: Colors.blueAccent,
            ),
          ),
          _buildSecurityTile(
            title: "Change Password",
            subtitle: "Last updated 3 months ago",
            icon: Icons.lock_outline,
            onTap: () {
              // Navigate to change password logic
            },
          ),

          const SizedBox(height: 30),
          _buildSectionHeader("Data & Privacy"),
          _buildSecurityTile(
            title: "Real-time Location",
            subtitle: "Allow carriers to see your facility location.",
            icon: Icons.location_on_outlined,
            trailing: Switch(
              value: _isLocationSharingEnabled,
              onChanged: (val) => setState(() => _isLocationSharingEnabled = val),
              activeColor: Colors.blueAccent,
            ),
          ),
          _buildSecurityTile(
            title: "Usage Analytics",
            subtitle: "Help us improve by sharing anonymous data.",
            icon: Icons.analytics_outlined,
            trailing: Switch(
              value: _isDataAnalyticsEnabled,
              onChanged: (val) => setState(() => _isDataAnalyticsEnabled = val),
              activeColor: Colors.blueAccent,
            ),
          ),

          const SizedBox(height: 30),
          _buildSectionHeader("Legal"),
          _buildSecurityTile(
            title: "Privacy Policy",
            subtitle: "How we manage your business data.",
            icon: Icons.description_outlined,
            onTap: () {
              // Open web view or policy screen
            },
          ),
          _buildSecurityTile(
            title: "Request My Data",
            subtitle: "Download a copy of your account activity.",
            icon: Icons.download_for_offline_outlined,
            onTap: () {
              // Trigger data export
            },
          ),

          const SizedBox(height: 40),
          TextButton(
            onPressed: () {
              // Logic for account deletion
            },
            child: const Text(
              "Delete Account",
              style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
            ),
          ),
          const Center(
            child: Text(
              "v1.0.4 (Build 2026)",
              style: TextStyle(color: Colors.white24, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, left: 5),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.blueAccent,
          fontSize: 13,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSecurityTile({
    required String title,
    required String subtitle,
    required IconData icon,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: Colors.white70),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 12)),
        trailing: trailing ?? const Icon(Icons.chevron_right, color: Colors.white24),
      ),
    );
  }
}