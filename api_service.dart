import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://localhost:5001/'; // Base URL from backend

  Future<List<Map<String, dynamic>>> getTrips() async {
    final response = await http.get(Uri.parse('$baseUrl/api/trips'));
    if (response.statusCode == 200) {
      List<dynamic> trips = json.decode(response.body);
      return trips.map((trip) => trip as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load trips');
    }
  }

  Future<void> addTrip(Map<String, dynamic> trip) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/trips'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(trip),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add trip');
    }
  }

  Future<void> updateTrip(String id, Map<String, dynamic> trip) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/trips/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(trip),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update trip');
    }
  }

  Future<void> deleteTrip(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/api/trips/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete trip');
    }
  }
}
