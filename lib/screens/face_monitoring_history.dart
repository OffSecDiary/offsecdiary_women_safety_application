import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FaceMonitoringHistoryScreen extends StatelessWidget {
  const FaceMonitoringHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Face Monitoring History"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("face_monitoring")
            .where("userId", isEqualTo: user?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  snapshot.error.toString(),
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            );
          }

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                "No monitoring events found",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          docs.sort((a, b) {
            final aData =
                a.data() as Map<String, dynamic>;
            final bData =
                b.data() as Map<String, dynamic>;

            final aTime =
                aData["timestamp"] as Timestamp?;
            final bTime =
                bData["timestamp"] as Timestamp?;

            if (aTime == null || bTime == null) {
              return 0;
            }

            return bTime.compareTo(aTime);
          });

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data =
                  docs[index].data() as Map<String, dynamic>;

              final timestamp =
                  data["timestamp"] as Timestamp?;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.face,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    data["status"] ?? "Monitoring Active",
                  ),
                  subtitle: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        timestamp == null
                            ? "Waiting for server..."
                            : timestamp
                                .toDate()
                                .toString(),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}