import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cargolink_application/models/dashboard_stats.dart';

class ApiService {
  final String baseUrl = "http://10.0.2.2:8000/api";

  Future<Map<String, dynamic>> registerUser({
    required String username,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register/'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "username": username,
          "email": email,
          "phone": phone,
          "password": password,
        }),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return responseData;
      } else {
        return {
          "error": true,
          "message": responseData.values.join(", ")
        };
      }
    } on SocketException {
      return {"error": true, "message": "Cannot connect to server. Check if Django is running."};
    } catch (e) {
      return {"error": true, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> loginUser({
    required String username, // Changed back to username
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username, // Changed back to username
          "password": password,
        }),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return responseData;
      } else {
        return {"error": true, "message": "Invalid username or password"};
      }
    } catch (e) {
      return {"error": true, "message": "Connection failed: $e"};
    }
  }

  Future<DashboardStats> getDashboardStats(String token, dynamic widget) async {
    final response = await http.get(
      Uri.parse('$baseUrl/dashboard/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token ${widget.authToken}',
      },
    );

    if (response.statusCode == 200) {
      return DashboardStats.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load dashboard stats');
    }
  }

  Future<DashboardStats> getDashboardSummary(String yourSavedToken) async {
    final response = await http.get(
      Uri.parse('$baseUrl/bookings/summary/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $yourSavedToken', // Use 'Bearer' if using JWT
      },
    );

    if (response.statusCode == 200) {
      return DashboardStats.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load dashboard stats');
    }
  }
}
