import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/trip.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  static const String baseUrl =
      'https://journey-journal-cop4331-71e6a1fdae61.herokuapp.com/api'; // Server URL

  //login
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
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
        throw "Username or Password is incorrect.";
      } else {
        throw "Had trouble connecting. Try again later";
      }
    } on http.ClientException {
      throw "Had trouble connecting. Try again later";
    }
  }

  //register
  static Future<Map<String, dynamic>> register(String firstName,
      String lastName, String email, String login, String password) async {
    final url = Uri.parse('$baseUrl/register');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'login': login,
          'password': password
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw "Had trouble connecting. Try again later";
      }
    } on http.ClientException {
      throw "Had trouble connecting. Try again later";
    }
  }

//add post
  static Future<Trip> addEntry({
    required String userId,
    required String title,
    required String description,
    required String location,
  }) async {
    final url = Uri.parse('$baseUrl/addEntry');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'title': title,
          'description': description,
          'location': location,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return Trip.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to add entry: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error adding entry: $e');
      }
      rethrow;
    }
  }
  //edit

  static Future<Map<String, dynamic>> editEntry(
      String entryId, Map<String, dynamic> updates) async {
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
        throw "Entry not found.";
      } else {
        throw "Had trouble connecting. Try again later";
      }
    } on http.ClientException {
      throw "Had trouble connecting. Try again later";
    }
  }
  //delete

  static Future<void> deleteEntry(String entryId) async {
    final url = Uri.parse('$baseUrl/deleteEntry/$entryId');
    try {
      final response = await http.delete(url);

      if (response.statusCode != 200) {
        throw Exception('Failed to delete entry: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to the server: $e');
    }
  }
//searchEntries (change)

  static Future<Map<String, dynamic>> searchEntries(
    String search,
  ) async {
    final url = Uri.parse('$baseUrl/searchEntries');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(<String, String>{
          'search': search,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw "Had trouble connecting. Try again later";
      }
    } on http.ClientException {
      throw "Had trouble connecting. Try again later";
    }
  }
//searchMyEntries (change)

  static Future<List<Trip>> searchMyEntries(
      String search, String userId) async {
    final url = Uri.parse('$baseUrl/searchMyEntries');
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
        final dynamic jsonResponse = jsonDecode(response.body);

        if (kDebugMode) {
          debugPrint('API Response: $jsonResponse');
        }

        if (jsonResponse is List) {
          return jsonResponse
              .map((json) => Trip.fromJson(json as Map<String, dynamic>))
              .toList();
        } else if (jsonResponse is Map) {
          // Handle case where response is a single object instead of a list
          return [Trip.fromJson(jsonResponse as Map<String, dynamic>)];
        } else {
          throw Exception(
              'Unexpected response format: ${jsonResponse.runtimeType}');
        }
      } else {
        throw Exception(
            'Failed to fetch entries: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error in searchMyEntries: $e');
      }
      rethrow;
    }
  }

//getEntry
  static Future<Map<String, dynamic>> getEntry(String entryId) async {
    final url = Uri.parse('$baseUrl/getEntry$entryId');
    try {
      final response = await http.get(
        url,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        throw "Entry not found.";
      } else {
        throw "Had trouble connecting. Try again later";
      }
    } on http.ClientException {
      throw "Had trouble connecting. Try again later";
    }
  }
}
