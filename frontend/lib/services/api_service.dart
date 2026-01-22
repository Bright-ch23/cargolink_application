import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cargolink_application/models/dashboard_stats.dart';

class ApiService {
  // Use 10.0.2.2 for Android Emulator, 127.0.0.1 for iOS Simulator
  final String baseUrl = "http://10.0.2.2:8000/api";

  Future<Map<String, dynamic>> registerUser({
    required String username,
    required String email,
    required String phone,
    required String password,
    String? carColor,
    String? plateNumber,
    String? vehicleType,
    String? carModel,  // Changed to optional
    String? carYear,   // Changed to optional
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
          "plate_number": plateNumber,
          "vehicle_type": vehicleType,
        }),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return responseData;
      } else {
        // Improved error reporting for Django validation errors
        return {
          "error": true,
          "message": responseData.toString()
        };
      }
    } on SocketException {
      return {"error": true, "message": "Cannot connect to server. Check if Django is running."};
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
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return responseData; // This contains the 'token' and 'role'
      } else {
        return {"error": true, "message": "Invalid username or password"};
      }
    } catch (e) {
      return {"error": true, "message": "Connection failed: $e"};
    }
  }

  // FIXED: Standardized Authorization to use Bearer (JWT)
  // This solves the 401 error
  Future<DashboardStats> getDashboardSummary(String yourSavedToken) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/bookings/summary/'), // Ensure this exists in urls.py
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $yourSavedToken', // Use 'Bearer' for JWT
        },
      );

      if (response.statusCode == 200) {
        return DashboardStats.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Summary endpoint not found (404). Check Django urls.py');
      } else {
        throw Exception('Failed to load stats: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}