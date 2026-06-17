import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../core/theme/theme.dart';
import '../core/utils/utils.dart';
import '../widgets/custom_button.dart';
import 'sos.dart';

class VoiceModeScreen extends StatefulWidget {
  const VoiceModeScreen({super.key});

  @override
  State<VoiceModeScreen> createState() => _VoiceModeScreenState();
}

class _VoiceModeScreenState extends State<VoiceModeScreen> {
  final stt.SpeechToText speech = stt.SpeechToText();

  bool isListening = false;

  String transcript = "Tap the microphone and speak.";

  String threatLevel = "Safe";

  Future<void> _toggleListening() async {
    if (!isListening) {
      bool available = await speech.initialize();

      if (!mounted) return;

      if (available) {
        setState(() {
          isListening = true;
        });

        speech.listen(
          onResult: (result) {
            setState(() {
              transcript = result.recognizedWords;
            });

            _analyzeThreat(transcript);
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Speech recognition unavailable"),
          ),
        );
      }
    } else {
      setState(() {
        isListening = false;
      });

      speech.stop();
    }
  }

  void _analyzeThreat(String text) {
    final lowerText = text.toLowerCase();

    if (lowerText.contains("help") ||
        lowerText.contains("emergency") ||
        lowerText.contains("save me") ||
        lowerText.contains("danger") ||
        lowerText.contains("someone is following me")) {
      setState(() {
        threatLevel = "High";
      });

      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;

        AppUtils.navigateTo(
          context,
          const SOSScreen(),
        );
      });
    } else {
      setState(() {
        threatLevel = "Low";
      });
    }
  }

  void _goToSOS() {
    AppUtils.navigateTo(
      context,
      const SOSScreen(),
    );
  }

  @override
  void dispose() {
    speech.stop();
    super.dispose();
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
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 30),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  transcript,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
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