import 'package:flutter/material.dart';

import '../core/theme/theme.dart';
import '../core/utils/utils.dart';
import '../widgets/custom_button.dart';
import 'sos.dart';

class VoiceModeScreen extends StatefulWidget {
  const VoiceModeScreen({super.key});

  @override
  State<VoiceModeScreen> createState() =>
      _VoiceModeScreenState();
}

class _VoiceModeScreenState extends State<VoiceModeScreen> {
  bool isListening = false;
  String transcript =
      "Someone is following me near Pune station.";
  String threatLevel = "High";

  void _toggleListening() {
    setState(() {
      isListening = !isListening;
    });
  }

  void _goToSOS() {
    AppUtils.navigateTo(
      context,
      const SOSScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text("Voice Emergency"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 30),
            GestureDetector(
              onTap: _toggleListening,
              child: CircleAvatar(
                radius: 80,
                backgroundColor: isListening
                    ? AppTheme.safeGreen
                    : AppTheme.primaryRed,
                child: const Icon(
                  Icons.mic,
                  size: 70,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isListening
                  ? "Listening..."
                  : "Tap mic to start",
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 30),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(transcript),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: ListTile(
                leading: const Icon(Icons.warning),
                title: const Text("Threat Level"),
                subtitle: Text(threatLevel),
              ),
            ),
            const Spacer(),
            CustomButton(
              text: "Escalate to SOS",
              icon: Icons.warning,
              onPressed: _goToSOS,
            ),
          ],
        ),
      ),
    );
  }
}