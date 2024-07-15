import 'package:flutter/material.dart';
import 'package:journey_journal_app/components/post.dart';
import 'package:journey_journal_app/pages/home_page.dart';

class SettingsPage extends StatelessWidget {
  final Map<String, dynamic> credentials;
  final String defaultProfileImage = 'assets/images/profile-pic.png'; // Path to default profile image

  const SettingsPage({
    Key? key,
    required this.credentials,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    credentials['profileImage'] ?? defaultProfileImage,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20), // Optional spacing after the image
            Divider(),
            Text('First Name: ${credentials['firstName']}'),
            Divider(),
            Text('Last Name: ${credentials['lastName']}'),
            Divider(),
            Text('Username: ${credentials['login']}'),
            Divider(),
            Text('Email:  ${credentials['email']} '),
            Divider(),
            // Additional Text widgets as needed
          ],
        ),
      ),
    );
  }
}

