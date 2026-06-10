import 'package:flutter/material.dart';
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
  final List<Map<String, dynamic>> contacts = [
    {
      "name": "Mom",
      "phone": "+91 9876543210",
      "relationship": "Mother",
      "priority": 1,
    },
    {
      "name": "Best Friend",
      "phone": "+91 9876501234",
      "relationship": "Friend",
      "priority": 2,
    },
  ];

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
            onPressed: () {
              setState(() {
                contacts.add({
                  "name": nameController.text,
                  "phone": phoneController.text,
                  "relationship": relationController.text,
                  "priority": contacts.length + 1,
                });
              });

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

  void _deleteContact(int index) {
    setState(() {
      contacts.removeAt(index);
    });

    AppUtils.showSnackBar(
  context,
  "Contact removed",
);

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
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 14),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppTheme.primaryRed,
                child: Text(
                  contact["priority"].toString(),
                ),
              ),
              title: Text(contact["name"]),
              subtitle: Text(
                "${contact["phone"]}\n${contact["relationship"]}",
              ),
              isThreeLine: true,
              trailing: IconButton(
                onPressed: () => _deleteContact(index),
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}