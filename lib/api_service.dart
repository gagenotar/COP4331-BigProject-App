import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bson/bson.dart';


class ApiService{
  static const String baseUrl = 'https://journey-journal-cop4331-71e6a1fdae61.herokuapp.com/api'; // Replace with your server URL
  //login
   Future<Map<String, dynamic>> login(String email, String password) async {
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
  Future<Map<String, dynamic>> register
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
  //edit

  static Future<Map<String, dynamic>> editEntry
      (
      String entryId,
      Map<String, dynamic> updates) async {
    final url = Uri.parse('$baseUrl/editEntry/$entryId');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updates),
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
 //delete

  static Future<Map<String, dynamic>> deleteEntry
      (
      String entryId,
      ) async {
    final url = Uri.parse('$baseUrl/deleteEntry/$entryId');
    try {
      final response = await http.delete(
        url,

      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        throw Exception('Invalid credentials');
      } else {
        throw Exception('Failed to delete post');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }
//searchEntries (change)

  static Future<Map<String, dynamic>> searchEntries
      (
      String search,
      ) async {
    final url = Uri.parse('$baseUrl/searchEntries');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(<String,String>{'search':search,}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        throw Exception('Invalid credentials');
      } else {
        throw Exception('Failed to search for post');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }
//searchMyEntries (change)

  static Future<Map<String, dynamic>> searchMyEntries
      (
      String search,
      String userId,) async {
    final url = Uri.parse('$baseUrl/addEntry');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(<String, String>{
          'search': search,
          'userId': userId,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        throw Exception('Invalid credentials');
      } else {
        throw Exception('Failed to search for post');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

//getEntry
  static Future<Map<String, dynamic>> getEntry
      (String
  entryId) async {
    final url = Uri.parse('$baseUrl/getEntry$entryId');
    try {
      final response = await http.get(
        url,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        throw Exception('Invalid credentials');
      } else {
        throw Exception('Failed to get post');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }
}
