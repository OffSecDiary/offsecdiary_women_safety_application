import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'sos.dart';
import '../widgets/custom_button.dart';
import '../widgets/emergency_card.dart';
import '../core/theme/theme.dart';

class MotionDetectionScreen extends StatefulWidget {
  const MotionDetectionScreen({super.key});

  @override
  State<MotionDetectionScreen> createState() =>
      _MotionDetectionScreenState();
}

class _MotionDetectionScreenState
    extends State<MotionDetectionScreen> {
  bool isMonitoring = false;
  bool dangerDetected = false;

  double sensitivity = 0.7;

  String motionStatus = "No unusual movement";

  double motionScore = 0.0;

  StreamSubscription? _accelerometerSubscription;

  bool _dialogShowing = false;

  void _toggleMonitoring() {
    if (isMonitoring) {
      _stopMonitoring();
    } else {
      _startMonitoring();
    }
  }

  void _startMonitoring() {
    setState(() {
      isMonitoring = true;
      dangerDetected = false;
      motionStatus = "Monitoring movement...";
    });

    _accelerometerSubscription =
        accelerometerEventStream().listen((event) {
      if (!mounted) return;

      final magnitude = sqrt(
        event.x * event.x +
            event.y * event.y +
            event.z * event.z,
      );

      setState(() {
        motionScore = magnitude;
      });

      double threshold = 18 - (sensitivity * 8);

      if (magnitude > threshold &&
          !_dialogShowing &&
          isMonitoring) {
        setState(() {
          dangerDetected = true;
          motionStatus = "Sudden movement detected";
        });

        _showDangerPrompt();
      } else if (!dangerDetected) {
        setState(() {
          motionStatus =
          "Monitoring... Motion ${magnitude.toStringAsFixed(1)}";
        });
      }
    });
  }

  void _stopMonitoring() {
    _accelerometerSubscription?.cancel();

    setState(() {
      isMonitoring = false;
      dangerDetected = false;
      motionScore = 0.0;
      motionStatus = "Monitoring stopped";
    });
  }

  void _showDangerPrompt() {
    _dialogShowing = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        title: const Text(
          "Danger Check",
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          "Sudden movement detected. Are you safe?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);

              _dialogShowing = false;

              setState(() {
                dangerDetected = false;
                motionStatus = "User confirmed safe";
              });
            },
            child: const Text(
              "I AM SAFE",
              style: TextStyle(color: Colors.green),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryRed,
            ),
            onPressed: () {
              Navigator.pop(context);

              _dialogShowing = false;

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SOSScreen(),
                ),
              );
            },
            child: const Text("SEND HELP"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text("Motion Detection"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            Container(
              height: 180,
              width: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: dangerDetected
                    ? Colors.red
                    : isMonitoring
                    ? Colors.green
                    : AppTheme.cardBackground,
                boxShadow: [
                  BoxShadow(
                    color: (dangerDetected
                            ? Colors.red
                            : Colors.green)
                        .withValues(alpha: 0.4),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(
                Icons.directions_run,
                color: Colors.white,
                size: 70,
              ),
            ),

            const SizedBox(height: 25),

            EmergencyCard(
              title: "Motion Status",
              subtitle: motionStatus,
              icon: Icons.speed,
              iconColor:
                  dangerDetected ? Colors.red : Colors.green,
            ),

            const SizedBox(height: 16),

            EmergencyCard(
              title: "Motion Score",
              subtitle: motionScore.toStringAsFixed(2),
              icon: Icons.analytics,
              iconColor: Colors.orange,
            ),

            const SizedBox(height: 25),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppTheme.cardBackground,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Detection Sensitivity",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  Slider(
                    activeColor: AppTheme.primaryRed,
                    value: sensitivity,
                    onChanged: (value) {
                      setState(() {
                        sensitivity = value;
                      });
                    },
                  ),
                ],
              ),
            ),

            const Spacer(),

            CustomButton(
              text: isMonitoring
                  ? "STOP MONITORING"
                  : "START MONITORING",
              icon: isMonitoring
                  ? Icons.pause
                  : Icons.play_arrow,
              backgroundColor:
                  isMonitoring ? Colors.grey : Colors.red,
              onPressed: _toggleMonitoring,
            ),
          ],
        ),
      ),
    );
  }
}