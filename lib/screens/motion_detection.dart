import 'dart:async';
import 'package:flutter/material.dart';

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

  Timer? _demoTimer;

  void _toggleMonitoring() {
    setState(() {
      isMonitoring = !isMonitoring;
      dangerDetected = false;
      motionStatus = isMonitoring
          ? "Monitoring movement..."
          : "No unusual movement";
    });

    if (isMonitoring) {
      _startDemoMotionSimulation();
    } else {
      _demoTimer?.cancel();
    }
  }

  void _startDemoMotionSimulation() {
    _demoTimer?.cancel();

    _demoTimer = Timer(const Duration(seconds: 4), () {
      if (!mounted || !isMonitoring) return;

      setState(() {
        dangerDetected = true;
        motionStatus = "Panic running detected";
      });

      _showDangerPrompt();
    });
  }

  void _showDangerPrompt() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        title: const Text(
          "Danger Check",
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          "We detected sudden movement. Are you safe?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
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
    _demoTimer?.cancel();
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

            // Main Motion Icon
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

            const SizedBox(height: 25),

            // Sensitivity Slider
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppTheme.cardBackground,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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