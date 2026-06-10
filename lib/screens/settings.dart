import 'package:flutter/material.dart';
import '../widgets/emergency_card.dart';
import 'emergency_contacts.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool doNotDisturb = false;
  bool silentSOS = true;
  bool liveLocation = true;
  bool motionDetection = true;
  bool darkTheme = true;
  double motionSensitivity = 0.7;

  Widget _settingSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(18),
      ),
      child: SwitchListTile(
        activeThumbColor: Colors.red,
        value: value,
        onChanged: onChanged,
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.grey),
        ),
        secondary: Icon(icon, color: Colors.red),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkTheme
          ? const Color(0xFF121212)
          : Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text(
          "Settings",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _settingSwitchTile(
            title: "Do Not Disturb",
            subtitle:
            "Disable auto prompts but keep manual SOS active",
            value: doNotDisturb,
            onChanged: (value) {
              setState(() {
                doNotDisturb = value;
              });
            },
            icon: Icons.do_not_disturb,
          ),

          _settingSwitchTile(
            title: "Silent Emergency Mode",
            subtitle: "Send alerts without sound",
            value: silentSOS,
            onChanged: (value) {
              setState(() {
                silentSOS = value;
              });
            },
            icon: Icons.volume_off,
          ),

          _settingSwitchTile(
            title: "Live Location Sharing",
            subtitle: "Share GPS during emergency",
            value: liveLocation,
            onChanged: (value) {
              setState(() {
                liveLocation = value;
              });
            },
            icon: Icons.location_on,
          ),

          _settingSwitchTile(
            title: "Motion Detection",
            subtitle: "Enable panic running detection",
            value: motionDetection,
            onChanged: (value) {
              setState(() {
                motionDetection = value;
              });
            },
            icon: Icons.directions_run,
          ),

          _settingSwitchTile(
            title: "Dark Theme",
            subtitle: "Cybersecurity black theme",
            value: darkTheme,
            onChanged: (value) {
              setState(() {
                darkTheme = value;
              });
            },
            icon: Icons.dark_mode,
          ),

          const SizedBox(height: 10),

          EmergencyCard(
            title: "Motion Sensitivity",
            subtitle:
            "Adjust how fast danger movement is detected",
            icon: Icons.speed,
          ),

          Slider(
            activeColor: Colors.red,
            value: motionSensitivity,
            onChanged: (value) {
              setState(() {
                motionSensitivity = value;
              });
            },
          ),

          const SizedBox(height: 20),

          EmergencyCard(
            title: "Emergency Preferences",
            subtitle: "Contacts, escalation and fallback rules",
            icon: Icons.settings_suggest,
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 16,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const EmergencyContactsScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}