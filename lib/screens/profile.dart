import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameController =
  TextEditingController(text: "Vaishnavi Jadhav");
  final phoneController =
  TextEditingController(text: "+91 9876543210");
  final bloodController =
  TextEditingController(text: "B+");
  final guardianController =
  TextEditingController(text: "Mother");
  final addressController =
  TextEditingController(text: "Pune, Maharashtra");
  final medicalController =
  TextEditingController(text: "No allergies");

  Widget _inputField(
      String label,
      TextEditingController controller,
      IconData icon,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.red),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: const Color(0xFF1E1E1E),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  void _saveProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profile saved successfully"),
        
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    bloodController.dispose();
    guardianController.dispose();
    addressController.dispose();
    medicalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // Profile avatar
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.red,
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 50,
              ),
            ),

            const SizedBox(height: 25),

            _inputField(
              "Full Name",
              nameController,
              Icons.person,
            ),
            _inputField(
              "Phone Number",
              phoneController,
              Icons.phone,
            ),
            _inputField(
              "Blood Group",
              bloodController,
              Icons.bloodtype,
            ),
            _inputField(
              "Guardian Relation",
              guardianController,
              Icons.family_restroom,
            ),
            _inputField(
              "Home Address",
              addressController,
              Icons.home,
            ),
            _inputField(
              "Medical Notes",
              medicalController,
              Icons.medical_services,
            ),

            const SizedBox(height: 20),

            CustomButton(
              text: "SAVE PROFILE",
              icon: Icons.save,
              onPressed: _saveProfile,
            ),
          ],
        ),
      ),
    );
  }
}