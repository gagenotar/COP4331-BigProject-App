import 'dart:convert';
import 'package:http/http.dart' as http;


class ApiService{
  static const String baseUrl =
      'https://journey-journal-cop4331-71e6a1fdae61.herokuapp.com/api';

static Future<void> login(String email, String password) async {
  final url = Uri.parse('$baseUrl/auth/login');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    var accessToken = data['accessToken'];
    var userId = data['id'];
    // handle accessToken and userId as needed
  } else {
    print('Login failed with status code ${response.statusCode}');
    print(response.body);
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

Future<void> refreshToken(String refreshToken) async {
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
Future<void> logout() async {
  final url = Uri.parse('$baseUrl/auth/logout');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    print('Logged out successfully');
  } else {
    print('Logout failed with status code ${response.statusCode}');
    print(response.body);
  }
}

Future<void> addEntry(String userId, String title, String description, dynamic location, int rating, String imagePath) async {
  final url = Uri.parse('$baseUrl/addEntry');
  var request = http.MultipartRequest('POST', url);
  request.fields['userId'] = userId;
  request.fields['title'] = title;
  request.fields['description'] = description;
  request.fields['location'] = jsonEncode(location);
  request.fields['rating'] = rating.toString();
  if (imagePath != null) {
    request.files.add(await http.MultipartFile.fromPath('image', imagePath));
  }

  var response = await request.send();
  if (response.statusCode == 200) {
    var responseBody = await response.stream.bytesToString();
    var data = jsonDecode(responseBody);
    var entryId = data['_id'];
    // handle entryId as needed
  } else {
    print('Failed to add entry with status code ${response.statusCode}');
  }
}

Future<void> deleteEntryById(String entryId) async {
  final url = Uri.parse('$baseUrl/deleteEntry/$entryId');
  final response = await http.delete(url);

  if (response.statusCode == 200) {
    print('Entry deleted successfully');
  } else {
    print('Failed to delete entry with status code ${response.statusCode}');
  }
}

Future<void> editEntryById(String entryId, {String? title, String? description, dynamic location, int? rating, String? imagePath}) async {
  final url = Uri.parse('$baseUrl/editEntry/$entryId');

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
    var updatedEntry = jsonDecode(responseBody);
    // handle updatedEntry as needed
  } else {
    print('Failed to edit entry with status code ${response.statusCode}');
  }
}
Future<void> getEntryById(String entryId) async {
  final url = Uri.parse('$baseUrl/getEntry/$entryId');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    var entry = jsonDecode(response.body);
    // handle entry as needed
  } else {
    print('Failed to fetch entry with status code ${response.statusCode}');
  }
}


Future<void> searchEntries(String search, String userId) async {
  final url = Uri.parse('$baseUrl/searchEntries');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'search': search, 'userId': userId}),
  );

  if (response.statusCode == 200) {
    List<dynamic> results = jsonDecode(response.body);
    // handle results as needed
  } else {
    print('Search failed with status code ${response.statusCode}');
  }
}

Future<void> searchMyEntries(String search, String userId) async {
  final url = Uri.parse('$baseUrl/searchMyEntries');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'search': search, 'userId': userId}),
  );

  if (response.statusCode == 200) {
    List<dynamic> results = jsonDecode(response.body);
    // handle results as needed
  } else {
    print('Search failed with status code ${response.statusCode}');
  }
}

Future<void> getProfileById(String userId) async {
  final url = Uri.parse('$baseUrl/profile/$userId');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    var profile = jsonDecode(response.body);
    // handle profile as needed
  } else {
    print('Failed to fetch profile with status code ${response.statusCode}');
  }
}

Future<void> updateProfileById(String userId, String login, String password) async {
  final url = Uri.parse('$baseUrl/updateProfile/$userId');
  final response = await http.put(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'login': login, 'password': password}),
  );

  if (response.statusCode == 200) {
    print('Profile updated successfully');
  } else {
    print('Failed to update profile with status code ${response.statusCode}');
  }
}



}
