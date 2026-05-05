import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cargolink_application/models/dashboard_stats.dart';

class ApiService {
  final String baseUrl = "http://10.0.2.2:8000/api";
  final Duration requestTimeout = const Duration(seconds: 90);

  Future<Map<String, dynamic>> registerUser({
    required String username,
    required String email,
    required String phone,
    required String password,
    String carModel = "",
    String carYear = "",
    String carColor = "",
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
          "vehicle_model": carModel,
          "vehicle_year": carYear,
          "vehicle_color": carColor,
        }),
      ).timeout(requestTimeout, onTimeout: () {
        throw TimeoutException('Registration request timed out after 90 seconds');
      });

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
    } on TimeoutException {
      return {"error": true, "message": "Request timed out. Server is not responding. Please try again."};
    } catch (e) {
      return {"error": true, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> loginUser({
    required String username,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "password": password,
        }),
      ).timeout(requestTimeout, onTimeout: () {
        throw TimeoutException('Login request timed out after 90 seconds');
      });

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return responseData;
      } else {
        return {"error": true, "message": "Invalid username or password"};
      }
    } on TimeoutException {
      return {"error": true, "message": "Login request timed out. Server is not responding. Please try again."};
    } catch (e) {
      return {"error": true, "message": "Connection failed: $e"};
    }
  }

  Future<List<dynamic>> fetchRecentShipments() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('jwt_token');

    if (token == null) {
      throw Exception("Authentication failed. Please log in again.");
    }

    final url = Uri.parse('$baseUrl/bookings/summary/');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(requestTimeout, onTimeout: () {
        throw TimeoutException('Fetching shipments request timed out after 90 seconds');
      });

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        throw Exception("Authentication failed. Please log in again.");
      } else {
        throw Exception("Failed to load shipments: ${response.statusCode}");
      }
    } on TimeoutException {
      throw Exception("Request timed out while fetching shipments. Please try again.");
    } catch (e) {
      throw Exception("Connection failed: $e");
    }
  }

  Future<bool> postNewLoad(Map<String, dynamic> loadData) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('jwt_token');

    if (token == null) {
      throw Exception("Authentication failed. Please log in again.");
    }

    final url = Uri.parse('$baseUrl/shipments/'); // Update to your actual route

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(loadData),
      ).timeout(requestTimeout, onTimeout: () {
        throw TimeoutException('Post new load request timed out after 90 seconds');
      });

      return response.statusCode == 201;
    } on TimeoutException {
      throw Exception("Request timed out while posting load. Please try again.");
    } catch (e) {
      throw Exception("Failed to post load: $e");
    }
  }

  Future<DashboardStats> getDashboardStats(String token, dynamic widget) async {
    final response = await http.get(
      Uri.parse('$baseUrl/dashboard/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token ${token}',
      },
    ).timeout(requestTimeout, onTimeout: () {
      throw TimeoutException('Get dashboard stats request timed out after 90 seconds');
    });

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
        'Authorization': 'Bearer $yourSavedToken',
      },
    ).timeout(requestTimeout, onTimeout: () {
      throw TimeoutException('Get dashboard summary request timed out after 90 seconds');
    });

    if (response.statusCode == 200) {
      return DashboardStats.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load dashboard stats');
    }
  }
}
