import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../core/theme/theme.dart';
import '../core/utils/utils.dart';
import '../widgets/custom_button.dart';

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({super.key});

  @override
  State<EmergencyContactsScreen> createState() =>
      _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState
    extends State<EmergencyContactsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _addContact({
    required String name,
    required String phone,
    required String relationship,
  }) async {
    final user = _auth.currentUser;

    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('contacts')
        .add({
      'name': name,
      'phone': phone,
      'relationship': relationship,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _deleteContact(String docId) async {
    final user = _auth.currentUser;

    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('contacts')
        .doc(docId)
        .delete();

    if (!mounted) return;

    AppUtils.showSnackBar(
      context,
      "Contact removed",
    );
  }

  void _showAddContactDialog() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final relationController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        title: const Text(
          "Add Emergency Contact",
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _input(nameController, "Name"),
            const SizedBox(height: 10),
            _input(phoneController, "Phone"),
            const SizedBox(height: 10),
            _input(relationController, "Relationship"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          CustomButton(
            text: "Add",
            height: 45,
            onPressed: () async {
              await _addContact(
                name: nameController.text.trim(),
                phone: phoneController.text.trim(),
                relationship: relationController.text.trim(),
              );

              if (!mounted) return;

              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _input(TextEditingController c, String hint) {
    return TextField(
      controller: c,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: AppTheme.darkBackground,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text("Emergency Contacts"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryRed,
        onPressed: _showAddContactDialog,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('users')
            .doc(user!.uid)
            .collection('contacts')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong"),
            );
          }

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                "No contacts added yet",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final contact =
                  docs[index].data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.only(bottom: 14),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.primaryRed,
                    child: Text(
                      "${index + 1}",
                    ),
                  ),
                  title: Text(
                    contact["name"] ?? "",
                  ),
                  subtitle: Text(
                    "${contact["phone"]}\n${contact["relationship"]}",
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                    onPressed: () =>
                        _deleteContact(docs[index].id),
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
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