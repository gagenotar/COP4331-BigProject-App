import 'package:flutter/material.dart';
import 'package:journey_journal_app/components/api_service.dart'; // Import your API service

class SettingsPage extends StatefulWidget {
  final String userId; // Pass the userId instead of credentials

  const SettingsPage({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Map<String, dynamic>? profileData;
  final String defaultProfileImage = 'assets/images/profile-pic.png'; // Path to default profile image
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    try {
      final data = await ApiService.getProfileById(widget.userId);
      setState(() {
        profileData = data;
        isLoading = false;
      });
    } catch (e) {
      // Handle the error (e.g., show a snackbar or dialog)
      print('Error fetching profile data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
       // appBar: AppBar(title: Text('Settings')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (profileData == null) {
      return Scaffold(
       // appBar: AppBar(title: Text('Settings')),
        body: Center(child: Text('Failed to load profile data')),
      );
    }

    return Scaffold(
     // appBar: AppBar(title: Text('Settings')),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
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
                      profileData!['profileImage'] ?? defaultProfileImage,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20), // Optional spacing after the image
              Divider(),
              Text('First Name: ${profileData!['firstName']}', style: TextStyle(fontSize: 16.0)),
              Divider(),
              Text('Last Name: ${profileData!['lastName']}', style: TextStyle(fontSize: 16.0)),
              Divider(),
              Text('Username: ${profileData!['login']}', style: TextStyle(fontSize: 16.0)),
              Divider(),
              Text('Email: ${profileData!['email']}', style: TextStyle(fontSize: 16.0)),
              Divider(),
              // Additional Text widgets as needed
            ],
          ),
        ),
      ),
    );
  }
}

