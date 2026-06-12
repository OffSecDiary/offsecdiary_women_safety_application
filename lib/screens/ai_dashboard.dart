import 'package:flutter/material.dart';
import '../services/threat_engine.dart';

class AIDashboardScreen extends StatelessWidget {
  const AIDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {

    int risk = ThreatEngine.calculateRisk(
      voiceScore: 20,
      motionScore: 15,
      faceScore: 10,
      locationScore: 5,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Guardian AI"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            Card(
              child: ListTile(
                title: const Text("Risk Score"),
                subtitle: Text("$risk%"),
              ),
            ),

            Card(
              child: ListTile(
                title: const Text("Threat Level"),
                subtitle: Text(
                  ThreatEngine.getThreatLevel(risk),
                ),
              ),
            ),

            Card(
              child: ListTile(
                title: const Text("Voice AI"),
                subtitle: const Text("Active"),
              ),
            ),

            Card(
              child: ListTile(
                title: const Text("Motion AI"),
                subtitle: const Text("Active"),
              ),
            ),

            Card(
              child: ListTile(
                title: const Text("Face AI"),
                subtitle: const Text("Active"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}