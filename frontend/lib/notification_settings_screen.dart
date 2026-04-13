import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _pushNotifications = true;
  bool _bidUpdates = true;
  bool _shipmentStatus = true;
  bool _promotionalOffers = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        title: const Text("Notification Settings"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          _buildSectionHeader("General"),
          _buildSwitchTile(
            title: "Push Notifications",
            subtitle: "Receive updates when the app is closed.",
            value: _pushNotifications,
            onChanged: (value) => setState(() => _pushNotifications = value),
          ),

          const SizedBox(height: 20),
          _buildSectionHeader("Activity Alerts"),
          _buildSwitchTile(
            title: "Bid Updates",
            subtitle: "Get notified when a carrier places a new bid.",
            value: _bidUpdates,
            onChanged: (value) => setState(() => _bidUpdates = value),
          ),
          _buildSwitchTile(
            title: "Shipment Status Changes",
            subtitle: "Alerts for pickup, delivery, and delays.",
            value: _shipmentStatus,
            onChanged: (value) => setState(() => _shipmentStatus = value),
          ),

          const SizedBox(height: 20),
          _buildSectionHeader("Promotions"),
          _buildSwitchTile(
            title: "Promotional Offers",
            subtitle: "Receive special offers and news from CargoLink.",
            value: _promotionalOffers,
            onChanged: (value) => setState(() => _promotionalOffers = value),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 5),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.blueAccent,
          fontWeight: FontWeight.bold,
          fontSize: 14,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
      ),
      child: SwitchListTile.adaptive(
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 12)),
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blueAccent,
        inactiveTrackColor: Colors.white12,
      ),
    );
  }
}
