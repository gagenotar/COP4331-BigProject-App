import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bson/bson.dart';
import 'package:journey_journal_app/components/trip.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart';
import 'package:crypto/crypto.dart';




class ApiService{
  static const String baseUrl =
      'https://journey-journal-cop4331-71e6a1fdae61.herokuapp.com/api';

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'login': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var accessToken = data['accessToken'];
      var userId = data['id'];
      // You should construct the Map<String, dynamic> that represents your credentials
      var credentials = {
        'accessToken': accessToken,
        'userId': userId,
      };
      return credentials;
    }
    else {
      print('Login failed with status code ${response.statusCode}');
      print(response.body);
      // Throw an exception or handle the error as needed
      throw Exception('Failed to login');
    }
  }


  static Future<void> register(String firstName, String lastName, String email, String login, String password) async {
    final url = Uri.parse('$baseUrl/auth/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'login': login,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var accessToken = data['accessToken'];
      var userId = data['id'];
      // handle accessToken and userId as needed
    } else {
      print('Registration failed with status code ${response.statusCode}');
      print(response.body);
    }
  }

  static Future<Map<String, dynamic>> verifyCode(String email, String code) async {
    final url = Uri.parse('$baseUrl/auth/verify');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email,'code': code}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      if (response.statusCode == 400) {
        throw "Invalid code";
      }

      else {
        throw "Had trouble connecting. Try again later";
      }

    } on http.ClientException {
      throw "Had trouble connecting. Try again later";
    }
  }

  static Future<void> refreshToken(String refreshToken) async {
    final url = Uri.parse('$baseUrl/auth/refreshToken');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'refreshToken=$refreshToken',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var accessToken = data['accessToken'];
      // handle accessToken as needed
    } else {
      print('Token refresh failed with status code ${response.statusCode}');
      print(response.body);
    }
  }

  static Future<void> logout() async {
    final url = Uri.parse('$baseUrl/auth/logout');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print('Logged out successfully');
    }
    else {
      print('Logout failed with status code ${response.statusCode}');
      print(response.body);
    }
  }

  static Future<Trip> addEntry({
    required String userId,
    required String title,
    String description = '',
    String location = '',
    int rating = 0,
    String? imagePath,
  }) async {
    final url = Uri.parse('$baseUrl/addEntry');

    var request = http.MultipartRequest('POST', url);
    request.fields['userId'] = userId as String;
    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['location'] = location;
    request.fields['rating'] = rating.toString();

    if (imagePath != null) {
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      var data = jsonDecode(responseBody);
      return Trip.fromJson(data); // Convert server response to Trip object
    } else {
      throw http.ClientException('Failed to add entry with status code ${response.statusCode}');
    }
  }

  static Future<void> deleteEntryByID(String entryId) async {
    final url = Uri.parse('$baseUrl/app/deleteEntry/$entryId');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      print('Entry deleted successfully');
    } else {
      print('Failed to delete entry with status code ${response.statusCode}');
    }
  }

  static Future<Trip> editEntryByID(String entryId, {
    String? title,
    String? description,
    dynamic location,
    int? rating,
    String? imagePath,
  }) async {
    final url = Uri.parse('$baseUrl/app/editEntry/$entryId');

    var request = http.MultipartRequest('PUT', url);
    if (title != null) request.fields['title'] = title;
    if (description != null) request.fields['description'] = description;
    if (location != null) request.fields['location'] = jsonEncode(location);
    if (rating != null) request.fields['rating'] = rating.toString();
    if (imagePath != null) {
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      var responseData = jsonDecode(responseBody);
      // Convert the response data to a Trip object
      return Trip.fromJson(responseData);
    } else {
      print('Failed to edit entry with status code ${response.statusCode}');
      throw http.ClientException('Failed to edit entry with status code ${response.statusCode}');
    }
  }


  static Future<void> getEntryById(String entryId) async {
    final url = Uri.parse('$baseUrl/app/getEntry/$entryId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var entry = jsonDecode(response.body);
      // handle entry as needed
    } else {
      print('Failed to fetch entry with status code ${response.statusCode}');
    }
  }



  static Future<List<dynamic>> searchEntries(String search, String userId) async {
    final url = Uri.parse('$baseUrl/app/searchEntries');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'search': search, 'userId': userId}),
    );

    if (response.statusCode == 200) {
      List<dynamic> results = jsonDecode(response.body);
      return results;
      // handle results as needed
    } else {
      throw 'Search failed with status code ${response.statusCode}';
    }
  }

  static Future<List<Trip>> searchMyEntries(
      String search, String userId) async {
    final url = Uri.parse('$baseUrl/app/searchMyEntries');
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

  static Future<Map<String, dynamic>> getProfileById(String userId) async {
    final url = Uri.parse('$baseUrl/app/profile/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Return profile data as a Map
    } else {
      throw Exception('Failed to fetch profile with status code ${response.statusCode}');
    }
  }

 static Future<void> updateProfileByID({
    required String id,
    String? login,
    String? password,
  }) async {
    final uri = Uri.parse('$baseUrl/app/updateProfileByID/$id');
    final headers = {
      'Content-Type': 'application/json',
    };

    // If password is provided, hash it
    String? hashedPassword;
    if (password != null) {
      hashedPassword = _hashPassword(password);
    }

    // Construct request body
    final body = jsonEncode({
      'login': login,
      'password': hashedPassword,
    });

    try {
      // Make HTTP PUT request
      final response = await http.put(
        uri,
        headers: headers,
        body: body,
      );

      // Handle response
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Profile updated successfully: $data');
      } else {
        final data = jsonDecode(response.body);
        print('Failed to update profile: $data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

}


String _hashPassword(String password) {
  // Use SHA-256 hashing algorithm for the password
  var bytes = utf8.encode(password); // Convert password to bytes
  var digest = sha256.convert(bytes); // Hash password
  return digest.toString(); // Return the hashed password as a string
}
