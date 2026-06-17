import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../core/theme/theme.dart';
import '../services/location_service.dart';
import '../widgets/custom_button.dart';

class SOSScreen extends StatefulWidget {
  const SOSScreen({super.key});

  @override
  State<SOSScreen> createState() => _SOSScreenState();
}

class _SOSScreenState extends State<SOSScreen> {
  int countdown = 5;
  Timer? timer;
  bool alertSent = false;

  final LocationService _locationService = LocationService();

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (countdown == 0) {
          timer.cancel();
          _saveSOSEvent();
        } else {
          setState(() {
            countdown--;
          });
        }
      },
    );
  }

  Future<void> _saveSOSEvent() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) return;

      final position =
          await _locationService.getCurrentLocation();

      final contactsSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('contacts')
              .get();

      final contactsCount =
          contactsSnapshot.docs.length;

      await FirebaseFirestore.instance
          .collection('sos_history')
          .add({
        'userId': user.uid,
        'latitude': position?.latitude,
        'longitude': position?.longitude,
        'contactsCount': contactsCount,
        'status': 'SOS Sent',
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      setState(() {
        alertSent = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "SOS Sent to $contactsCount Emergency Contacts",
          ),
        ),
      );
    } catch (e) {
      debugPrint("SOS Error: $e");
    }
  }

  void _cancelSOS() {
    timer?.cancel();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text("Emergency SOS"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 30),

            Container(
              height: 220,
              width: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: alertSent
                    ? AppTheme.safeGreen
                    : AppTheme.primaryRed,
              ),
              child: Center(
                child: alertSent
                    ? const Icon(
                        Icons.check,
                        size: 80,
                        color: Colors.white,
                      )
                    : Text(
                        "$countdown",
                        style: const TextStyle(
                          fontSize: 72,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 30),

            Text(
              alertSent
                  ? "Emergency Alert Sent"
                  : "Sending in $countdown seconds...",
              style: const TextStyle(
                fontSize: 22,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 15),

            if (alertSent)
              const Text(
                "Location recorded and emergency contacts identified.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),

            const Spacer(),

            if (!alertSent)
              CustomButton(
                text: "Cancel SOS",
                icon: Icons.close,
                backgroundColor: Colors.grey,
                onPressed: _cancelSOS,
              ),
          ],
        ),
      ),
    );
  }
}