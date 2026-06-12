import 'package:flutter/material.dart';

import '../core/constants/constants.dart';
import '../core/theme/theme.dart';
import '../core/utils/utils.dart';
import '../services/location_service.dart';

import '../widgets/emergency_card.dart';
import '../widgets/quick_action_tile.dart';

import 'emergency_contacts.dart';
import 'face_detection.dart';
import 'motion_detection.dart';
import 'profile.dart';
import 'settings.dart';
import 'sos.dart';
import 'voice_mode.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isMotionEnabled = true;
  bool isSafeMode = true;
  String locationText = "Fetching live location...";

  final LocationService _locationService = LocationService();

  @override
  void initState() {
    super.initState();
    _loadCurrentLocation();
  }

  Future<void> _loadCurrentLocation() async {
    final position = await _locationService.getCurrentLocation();

    if (!mounted) return;

    setState(() {
      if (position != null) {
        locationText = AppUtils.formatLocation(
          position.latitude,
          position.longitude,
        );
      } else {
        locationText = "Location unavailable";
      }
    });
  }

  Future<void> _openLiveLocation() async {
    final position = await _locationService.getCurrentLocation();

    if (position == null) {
      AppUtils.showSnackBar(
        context,
        "Location unavailable",
      );
      return;
    }

    await AppUtils.openGoogleMaps(
      position.latitude,
      position.longitude,
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(
            isSafeMode ? Icons.shield : Icons.warning,
            color: isSafeMode
                ? AppTheme.safeGreen
                : AppTheme.primaryRed,
            size: 30,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isSafeMode
                  ? AppConstants.safeMode
                  : AppConstants.dangerDetected,
              style: const TextStyle(
                color: AppTheme.textWhite,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              AppUtils.navigateTo(
                context,
                ProfileScreen(),
              );
            },
            icon: const Icon(
              Icons.person,
              color: AppTheme.textWhite,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSOSButton() {
    return GestureDetector(
      onTap: () {
        AppUtils.navigateTo(
          context,
          SOSScreen(),
        );
      },
      child: Container(
        height: 220,
        width: 220,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.primaryRed,
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryRed.withValues(alpha: 0.5),
              blurRadius: 30,
              spreadRadius: 10,
            ),
          ],
        ),
        child: const Center(
          child: Text(
            AppConstants.sosButton,
            style: TextStyle(
              fontSize: 52,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        QuickActionTile(
          icon: Icons.mic,
          label: "Voice",
          onTap: () {
            AppUtils.navigateTo(
              context,
              VoiceModeScreen(),
            );
          },
        ),
        QuickActionTile(
          icon: Icons.face,
          label: "Face",
          onTap: () {
            AppUtils.navigateTo(
              context,
              FaceDetectionScreen(),
            );
          },
        ),
        QuickActionTile(
          icon: Icons.directions_run,
          label: "Motion",
          onTap: () {
            AppUtils.navigateTo(
              context,
              MotionDetectionScreen(),
            );
          },
        ),
        QuickActionTile(
          icon: Icons.contacts,
          label: "Contacts",
          onTap: () {
            AppUtils.navigateTo(
              context,
              EmergencyContactsScreen(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBottomCards() {
    return Column(
      children: [
        EmergencyCard(
          title: "Live Location",
          subtitle: locationText,
          icon: Icons.location_on,
          iconColor: AppTheme.primaryRed,
          onTap: _openLiveLocation,
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(18),
          ),
          child: SwitchListTile(
            value: isMotionEnabled,
            activeThumbColor: AppTheme.primaryRed,
            onChanged: (value) {
              setState(() {
                isMotionEnabled = value;
              });
            },
            title: const Text(
              AppConstants.motionDetection,
              style: TextStyle(color: Colors.white),
            ),
            subtitle: const Text(
              "Enable panic running alerts",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
        const SizedBox(height: 16),
        EmergencyCard(
          title: "Settings",
          subtitle: "Emergency preferences and privacy",
          icon: Icons.settings,
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
            size: 16,
          ),
          onTap: () {
            AppUtils.navigateTo(
              context,
              SettingsScreen(),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text(
          AppConstants.appName,
          style: TextStyle(
            color: AppTheme.textWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              AppUtils.navigateTo(
                context,
                SettingsScreen(),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppTheme.primaryRed,
          onRefresh: _loadCurrentLocation,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildHeaderCard(),
                const SizedBox(height: 30),
                _buildSOSButton(),
                const SizedBox(height: 30),
                _buildQuickActions(),
                const SizedBox(height: 30),
                _buildBottomCards(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}