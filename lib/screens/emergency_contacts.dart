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

final User? user = FirebaseAuth.instance.currentUser;

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
          if (nameController.text.trim().isEmpty ||
              phoneController.text.trim().isEmpty) {
            return;
          }

          await FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .collection('contacts')
              .add({
            'name': nameController.text.trim(),
            'phone': phoneController.text.trim(),
            'relationship': relationController.text.trim(),
            'createdAt': Timestamp.now(),
          });

          if (mounted) {
            Navigator.pop(context);

            AppUtils.showSnackBar(
              context,
              "Contact added successfully",
            );
          }
        },
      ),
    ],
  ),
);

}

Widget _input(TextEditingController controller, String hint) {
return TextField(
controller: controller,
style: const TextStyle(color: Colors.white),
decoration: InputDecoration(
hintText: hint,
hintStyle: const TextStyle(color: Colors.grey),
filled: true,
fillColor: AppTheme.darkBackground,
),
);
}

Future<void> _deleteContact(String documentId) async {
await FirebaseFirestore.instance
.collection('users')
.doc(user!.uid)
.collection('contacts')
.doc(documentId)
.delete();


if (mounted) {
  AppUtils.showSnackBar(
    context,
    "Contact removed",
  );
}

}

@override
Widget build(BuildContext context) {
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
stream: FirebaseFirestore.instance
.collection('users')
.doc(user!.uid)
.collection('contacts')
.orderBy('createdAt', descending: false)
.snapshots(),
builder: (context, snapshot) {
if (snapshot.hasError) {
return const Center(
child: Text(
"Something went wrong",
style: TextStyle(color: Colors.white),
),
);
}


      if (snapshot.connectionState ==
          ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      final contacts = snapshot.data!.docs;

      if (contacts.isEmpty) {
        return const Center(
          child: Text(
            "No Emergency Contacts Added",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact =
              contacts[index].data() as Map<String, dynamic>;

          final documentId = contacts[index].id;

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
                contact['name'] ?? '',
              ),
              subtitle: Text(
                "${contact['phone'] ?? ''}\n${contact['relationship'] ?? ''}",
              ),
              isThreeLine: true,
              trailing: IconButton(
                onPressed: () =>
                    _deleteContact(documentId),
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
