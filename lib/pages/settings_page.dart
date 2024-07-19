import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final String email;
  final Map<String, dynamic> credentials;
  final String defaultProfileImage = 'assets/images/profile-pic.png'; // Path to default profile image
  final Function(String) updateEmailCallback;

  const SettingsPage({
    Key? key,
    required this.credentials,
    required this.email,
    required this.updateEmailCallback,
  }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current values
    firstNameController = TextEditingController(text: widget.credentials['firstName']);
    lastNameController = TextEditingController(text: widget.credentials['lastName']);
    emailController = TextEditingController(text: widget.email);
  }

  @override
  void dispose() {
    // Dispose controllers when not needed to avoid memory leaks
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Image section
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    widget.credentials['profileImage'] ?? widget.defaultProfileImage,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20), // Optional spacing after the image
            Divider(),
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(
                labelText: 'First Name',
              ),
            ),
            Divider(),
            TextField(
              controller: lastNameController,
              decoration: InputDecoration(
                labelText: 'Last Name',
              ),
            ),
            Divider(),
            Text('Username: ${widget.credentials['login']}', style: TextStyle(fontSize: 16.0)),
            Divider(),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
              onChanged: (newEmail) {
                // Update the email in the parent widget via callback
                widget.updateEmailCallback(newEmail);
              },
            ),
            Divider(),
            // Additional Text widgets as needed
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle saving changes here
          String newFirstName = firstNameController.text;
          String newLastName = lastNameController.text;
          String newEmail = emailController.text;

          // Update credentials with setState or your preferred state management approach
          setState(() {
            widget.credentials['firstName'] = newFirstName;
            widget.credentials['lastName'] = newLastName;
            // Email is updated via the callback in onChanged of TextField
          });

          // Optionally, navigate back to previous screen or show success message
          Navigator.pop(context); // Example: Navigate back after saving changes
        },
        child: Icon(Icons.save),
      ),
    );
  }
}

