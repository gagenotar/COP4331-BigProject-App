import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bson/bson.dart';


class ApiService{
  static const String baseUrl = 'https://journey-journal-cop4331-71e6a1fdae61.herokuapp.com/api'; // Replace with your server URL

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
        } 
        else if (response.statusCode == 404) {
          throw "Username or Password is incorrect.";
        } 
        else {
          throw "Had trouble connecting. Try again later";
        }
      } on http.ClientException {
        throw "Had trouble connecting. Try again later";
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
        } 
        else {
          throw "Had trouble connecting. Try again later";
        }
      } on http.ClientException {
        throw "Had trouble connecting. Try again later";
      }
    }
//add post
static Future<Map<String, dynamic>> addEntry
      (ObjectId userId,
  String title,
  String description, double rating, String
  location) async {
    final url = Uri.parse('$baseUrl/addEntry');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({ 'userId': userId, 'title': title, 'description': description, 'rating': rating, 'location': location}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } 
      else {
        throw "Had trouble connecting. Try again later";
      }
    } on http.ClientException {
      throw "Had trouble connecting. Try again later";
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
      } 
      else if (response.statusCode == 404) {
        throw "Entry not found.";
      }
      else {
        throw "Had trouble connecting. Try again later";
      }
    } on http.ClientException {
      throw "Had trouble connecting. Try again later";
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
      } 
      else if (response.statusCode == 404) {
        throw "Entry not found.";
      }
      else {
        throw "Had trouble connecting. Try again later";
      }
    } on http.ClientException {
      throw "Had trouble connecting. Try again later";
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
      } 
      else {
        throw "Had trouble connecting. Try again later";
      }
    } on http.ClientException {
      throw "Had trouble connecting. Try again later";
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
      } 
      else {
        throw "Had trouble connecting. Try again later";
      }
    } on http.ClientException {
      throw "Had trouble connecting. Try again later";
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
      } 
      else if (response.statusCode == 404) {
        throw "Entry not found.";
      }
      else {
        throw "Had trouble connecting. Try again later";
      }
    } on http.ClientException {
      throw "Had trouble connecting. Try again later";
    }
  }
}
