import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../core/theme/theme.dart';

class SOSHistoryScreen extends StatelessWidget {
  const SOSHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text("SOS History"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('sos_history')
            .where('userId', isEqualTo: user?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Firebase Error:\n${snapshot.error}",
                style: const TextStyle(
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
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
                "No SOS Alerts Found",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            );
          }

          docs.sort((a, b) {
            final aTime =
                (a['timestamp'] as Timestamp?)
                        ?.millisecondsSinceEpoch ??
                    0;

            final bTime =
                (b['timestamp'] as Timestamp?)
                        ?.millisecondsSinceEpoch ??
                    0;

            return bTime.compareTo(aTime);
          });

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data =
                  docs[index].data() as Map<String, dynamic>;

              final timestamp =
                  data['timestamp'] as Timestamp?;

              return Card(
                margin:
                    const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.warning),
                  ),
                  title: Text(
                    data['status'] ?? 'SOS Sent',
                  ),
                  subtitle: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Latitude: ${data['latitude']}",
                      ),
                      Text(
                        "Longitude: ${data['longitude']}",
                      ),
                      Text(
                        "Contacts Notified: ${data['contactsCount'] ?? 0}",
                      ),
                      if (timestamp != null)
                        Text(
                          "Time: ${timestamp.toDate()}",
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