import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:journeyjournalapp/services/user_service.dart'; // Adjust the path accordingly

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    try {
      final response = await http.post(
        Uri.parse('https://journey-journal-cop4331-71e6a1fdae61.herokuapp.com/api/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        // Handle successful login
        final responseData = jsonDecode(response.body);
        print('Login successful: $responseData');

        if (responseData.containsKey('id')) {
          // Save the userId to shared preferences
          await UserService.saveUserId(responseData['id']);
          // Navigate to the home page
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          // Handle missing userId in response
          _showErrorDialog('Invalid response from server. No userId found.');
        }
      } else {
        // Handle login failure
        print('Login failed with status: ${response.statusCode}');
        _showErrorDialog('Invalid email or password.');
      }
    } catch (e) {
      print('Login error: $e');
      _showErrorDialog('An error occurred during login. Please try again.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Login Failed'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'images/brand-logo.png',  // Path to your image
                height: 150,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Welcome Back',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 20),
            _buildTextField(_emailController, 'Email'),
            _buildTextField(_passwordController, 'Password', obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text('Don’t have an account? Register'),
              style: TextButton.styleFrom(foregroundColor: Colors.blueAccent),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
        ),
        obscureText: obscureText,
      ),
    );
  }
}
