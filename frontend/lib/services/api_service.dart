import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cargolink_application/models/dashboard_stats.dart';

class ApiService {
  final String baseUrl = "http://10.0.2.2:8000/api";

  Map<String, String> _jsonHeaders([String? token]) {
    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
    };
  }

  Future<Map<String, dynamic>> registerUser({
    required String username,
    required String email,
    required String phone,
    required String password,
    required String userType,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register/'),
        headers: _jsonHeaders(),
        body: jsonEncode({
          "username": username,
          "email": email,
          "phone": phone,
          "password": password,
          "user_type": userType,
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
    required String username,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login/'),
        headers: _jsonHeaders(),
        body: jsonEncode({
          "username": username,
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

  Future<DashboardStats> getDashboardSummary(String token) async {
    final summary = await getDashboardSummaryData(token);
    return DashboardStats.fromJson(summary);
  }

  Future<Map<String, dynamic>> getDashboardSummaryData(String token) async {
    if (token.isEmpty) {
      throw Exception('Missing authentication token. Please log in again.');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/bookings/summary/'),
      headers: _jsonHeaders(token),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 401) {
      throw Exception('Session expired or invalid. Please log in again.');
    } else {
      throw Exception('Failed to load dashboard stats');
    }
  }

  Future<List<Map<String, dynamic>>> getBookings(String token) async {
    if (token.isEmpty) {
      throw Exception('Missing authentication token. Please log in again.');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/bookings/'),
      headers: _jsonHeaders(token),
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      return responseData.cast<Map<String, dynamic>>();
    }

    throw Exception('Failed to load bookings: ${response.statusCode}');
  }

  Future<List<Map<String, dynamic>>> getAvailableLoads(String token) async {
    if (token.isEmpty) {
      throw Exception('Missing authentication token. Please log in again.');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/bookings/available/'),
      headers: _jsonHeaders(token),
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      return responseData.cast<Map<String, dynamic>>();
    }

    throw Exception('Failed to load available loads: ${response.statusCode}');
  }

  Future<Map<String, dynamic>> createBooking({
    required String token,
    required String pickupLocation,
    required String dropoffLocation,
    required String cargoType,
    required double cargoWeightKg,
    required double fareAmount,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/bookings/'),
      headers: _jsonHeaders(token),
      body: jsonEncode({
        'pickup_location': pickupLocation,
        'pickup_latitude': 0,
        'pickup_longitude': 0,
        'dropoff_location': dropoffLocation,
        'dropoff_latitude': 0,
        'dropoff_longitude': 0,
        'cargo_type': cargoType,
        'cargo_weight_kg': cargoWeightKg,
        'fare_amount': fareAmount,
      }),
    );

    final Map<String, dynamic> responseData = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return responseData;
    }

    return {
      'error': true,
      'message': responseData.toString(),
    };
  }

  Future<List<Map<String, dynamic>>> getBookingBids({
    required String token,
    required String bookingId,
  }) async {
    if (token.isEmpty) {
      throw Exception('Missing authentication token. Please log in again.');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/bookings/$bookingId/bids/'),
      headers: _jsonHeaders(token),
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      return responseData.cast<Map<String, dynamic>>();
    }

    throw Exception('Failed to load bids: ${response.statusCode}');
  }

  Future<Map<String, dynamic>> placeBid({
    required String token,
    required String bookingId,
    required double amount,
    String message = '',
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/bids/'),
      headers: _jsonHeaders(token),
      body: jsonEncode({
        'booking': int.parse(bookingId),
        'amount': amount,
        'message': message,
      }),
    );

    final Map<String, dynamic> responseData = jsonDecode(response.body);
    if (response.statusCode == 201) {
      return responseData;
    }

    return {
      'error': true,
      'message': responseData.toString(),
    };
  }

  Future<Map<String, dynamic>> respondToBid({
    required String token,
    required String bidId,
    required String action,
  }) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/bids/$bidId/respond/'),
      headers: _jsonHeaders(token),
      body: jsonEncode({'action': action}),
    );

    final Map<String, dynamic> responseData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return responseData;
    }

    return {
      'error': true,
      'message': responseData.toString(),
    };
  }
}
