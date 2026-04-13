import 'package:flutter/material.dart';
import 'main.dart'; // Import to access themeNotifier

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  bool _pushNotifications = true;
  bool _emailReports = false;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("App Settings"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildSectionHeader("Preferences"),
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeNotifier,
            builder: (context, currentMode, _) {
              return _buildSettingTile(
                "Dark Mode",
                "Adjust the app's appearance",
                Icons.dark_mode_outlined,
                trailing: Switch(
                  value: currentMode == ThemeMode.dark,
                  onChanged: (val) {
                    themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
                  },
                  activeColor: Colors.blueAccent,
                ),
              );
            },
          ),
          _buildSettingTile(
            "Push Notifications",
            "Receive alerts for bids and loads",
            Icons.notifications_active_outlined,
            trailing: Switch(
              value: _pushNotifications,
              onChanged: (val) => setState(() => _pushNotifications = val),
              activeColor: Colors.blueAccent,
            ),
          ),
          _buildSettingTile(
            "Email Reports",
            "Weekly summary of your activity",
            Icons.email_outlined,
            trailing: Switch(
              value: _emailReports,
              onChanged: (val) => setState(() => _emailReports = val),
              activeColor: Colors.blueAccent,
            ),
          ),

          const SizedBox(height: 25),
          _buildSectionHeader("Regional"),
          _buildSettingTile(
            "Language",
            _selectedLanguage,
            Icons.language_outlined,
            onTap: _showLanguageDialog,
          ),
          _buildSettingTile(
            "Currency",
            "USD (\$)",
            Icons.attach_money_outlined,
            onTap: () {},
          ),
          _buildSettingTile(
            "Unit System",
            "Metric (kg, km)",
            Icons.straighten_outlined,
            onTap: () {},
          ),

          const SizedBox(height: 25),
          _buildSectionHeader("About"),
          _buildSettingTile("Version", "1.0.4 (Build 2026)", Icons.info_outline),
          _buildSettingTile("Terms of Service", "", Icons.gavel_outlined, onTap: () {}),
          _buildSettingTile("Licenses", "", Icons.description_outlined, onTap: () {}),

          const SizedBox(height: 40),
          Center(
            child: TextButton(
              onPressed: () {},
              child: Text(
                "Restore Default Settings",
                style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 12),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.blueAccent,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildSettingTile(String title, String subtitle, IconData icon, {Widget? trailing, VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark 
            ? Colors.white.withOpacity(0.05) 
            : Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: Theme.of(context).iconTheme.color?.withOpacity(0.7), size: 22),
        title: Text(title, style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: 15)),
        subtitle: subtitle.isNotEmpty ? Text(subtitle, style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6), fontSize: 12)) : null,
        trailing: trailing ?? Icon(Icons.chevron_right, color: Theme.of(context).iconTheme.color?.withOpacity(0.3), size: 18),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        title: const Text("Select Language"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['English', 'Spanish', 'French', 'German'].map((lang) {
            return ListTile(
              title: Text(lang),
              onTap: () {
                setState(() => _selectedLanguage = lang);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
