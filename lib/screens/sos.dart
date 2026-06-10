import 'dart:async';
import 'package:flutter/material.dart';

import '../core/theme/theme.dart';
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

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown == 0) {
        timer.cancel();
        setState(() {
          alertSent = true;
        });
      } else {
        setState(() {
          countdown--;
        });
      }
    });
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
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              alertSent
                  ? "Emergency Alert Sent"
                  : "Sending in $countdown seconds...",
              style: const TextStyle(fontSize: 22),
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