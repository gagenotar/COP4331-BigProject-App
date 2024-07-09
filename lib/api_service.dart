import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bson/bson.dart';


class ApiService{
  static const String baseUrl = 'http://localhost:5001/api'; // Replace with your server URL
  //login
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        throw Exception('Invalid credentials');
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

    //register
    static Future<Map<String, dynamic>> register
    ( String firstName, String lastName, String
    email, String
    login, String
    password) async {
      final url = Uri.parse('$baseUrl/register');
      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({ 'firstName': firstName, 'lastName': lastName, 'email': email, 'login': login, 'password': password}),
        );

        if (response.statusCode == 200) {
          return jsonDecode(response.body);
        } else if (response.statusCode == 404) {
          throw Exception('Invalid credentials');
        } else {
          throw Exception('Failed to register');
        }
      } catch (e) {
        throw Exception('Failed to connect to server: $e');
      }
    }
//add post
  static Future<Map<String, dynamic>> addEntry
      (ObjectId userId,
  String title,
  String description, String
  location) async {
    final url = Uri.parse('$baseUrl/addEntry');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({ 'userId': userId, 'title': title, 'description': description, 'location': location}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        throw Exception('Invalid credentials');
      } else {
        throw Exception('Failed to add post');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }


}