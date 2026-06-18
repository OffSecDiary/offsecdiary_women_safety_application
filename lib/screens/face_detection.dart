import 'dart:async';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'face_monitoring_history.dart';

class FaceDetectionScreen extends StatefulWidget {
  const FaceDetectionScreen({super.key});

  @override
 State<FaceDetectionScreen> createState() =>
      _FaceDetectionScreenState();
}

class _FaceDetectionScreenState extends State<FaceDetectionScreen> {
  CameraController? _controller;

  bool isLoading = true;
  bool isMonitoring = false;

  int monitoringCount = 0;

  Timer? monitoringTimer;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();

      if (cameras.isEmpty) {
        return;
      }

      _controller = CameraController(
        cameras.first,
        ResolutionPreset.medium,
      );

      await _controller!.initialize();

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Camera Error: $e");
    }
  }

  void _startMonitoring() {
    if (isMonitoring) return;

    setState(() {
      isMonitoring = true;
      monitoringCount = 0;
    });

    _saveMonitoringEvent();

    monitoringTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => _saveMonitoringEvent(),
    );
  }

  void _stopMonitoring() {
    monitoringTimer?.cancel();

    setState(() {
      isMonitoring = false;
    });
  }

  Future<void> _saveMonitoringEvent() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance
          .collection("face_monitoring")
          .add({
        "userId": user?.uid,
        "status": "Monitoring Active",
        "timestamp": FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      setState(() {
        monitoringCount++;
      });
    } catch (e) {
      debugPrint("Firestore Error: $e");
    }
  }

  @override
  void dispose() {
    monitoringTimer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  Widget _buildStatusCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              isMonitoring
                  ? Icons.verified_user
                  : Icons.pause_circle,
              size: 55,
              color: isMonitoring
                  ? Colors.green
                  : Colors.grey,
            ),
            const SizedBox(height: 10),
            Text(
              isMonitoring
                  ? "Monitoring Active"
                  : "Monitoring Stopped",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Events Logged : $monitoringCount",
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton.icon(
          icon: Icon(
            isMonitoring
                ? Icons.stop
                : Icons.play_arrow,
          ),
          label: Text(
            isMonitoring
                ? "STOP MONITORING"
                : "START MONITORING",
          ),
          onPressed: isMonitoring
              ? _stopMonitoring
              : _startMonitoring,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Face Monitoring"),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: "Monitoring History",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const FaceMonitoringHistoryScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  flex: 5,
                  child: CameraPreview(_controller!),
                ),
                const SizedBox(height: 16),
                _buildStatusCard(),
                const SizedBox(height: 20),
                _buildControlButton(),
                const SizedBox(height: 25),
              ],
            ),
    );
  }
}