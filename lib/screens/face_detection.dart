import 'package:flutter/material.dart';

import '../core/theme/theme.dart';
import '../core/utils/utils.dart';
import '../widgets/custom_button.dart';
import '../widgets/emergency_card.dart';
import 'sos.dart';

class FaceDetectionScreen extends StatefulWidget {
  const FaceDetectionScreen({super.key});

  @override
  State<FaceDetectionScreen> createState() =>
      _FaceDetectionScreenState();
}

class _FaceDetectionScreenState
    extends State<FaceDetectionScreen> {
  bool fearDetected = false;
  bool isAnalyzing = false;

  Future<void> _startFaceAnalysis() async {
    setState(() {
      isAnalyzing = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      isAnalyzing = false;
      fearDetected = true;
    });

    _showSafetyDialog();
  }

  void _showSafetyDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        title: const Text(
          "Stress Detected",
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          "Fear micro-expression detected.\nAre you safe right now?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);

              AppUtils.showSnackBar(
  context,
  "...",
);

              setState(() {
                fearDetected = false;
              });
            },
            child: const Text(
              "I AM SAFE",
              style: TextStyle(color: Colors.green),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              AppUtils.navigateTo(
                context,
                const SOSScreen(),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryRed,
            ),
            child: const Text("SEND HELP"),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryRed.withValues(alpha: 0.4),
        ),
      ),
      child: Center(
        child: isAnalyzing
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(
              color: AppTheme.primaryRed,
            ),
            SizedBox(height: 20),
            Text(
              "Analyzing face...",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        )
            : const Icon(
          Icons.camera_alt,
          color: Colors.grey,
          size: 80,
        ),
      ),
    );
  }

  Widget _buildAnalysisCard() {
    return EmergencyCard(
      title: "Face Stress Analysis",
      subtitle: fearDetected
          ? "Fear micro-expression detected"
          : "No distress signals",
      icon: Icons.face,
      iconColor: fearDetected
          ? AppTheme.primaryRed
          : AppTheme.safeGreen,
    );
  }

  Widget _buildDangerAction() {
    return Column(
      children: [
        const Text(
          "Silent face safety check",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        CustomButton(
          text: isAnalyzing
              ? "ANALYZING..."
              : "START FACE ANALYSIS",
          icon: Icons.face_retouching_natural,

          onPressed: isAnalyzing
              ? null
              : () {
            _startFaceAnalysis();
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
        title: const Text("Silent Face Detection"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildCameraPreview(),
              const SizedBox(height: 24),
              _buildAnalysisCard(),
              const SizedBox(height: 30),
              _buildDangerAction(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}