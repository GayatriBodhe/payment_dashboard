import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:payment_dashboard_frontend/models/payment.dart';
// Removed unused import for 'user.dart'
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.1.197:3000'; // Use your IP
  static const String tokenKey = 'jwt_token';

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  Future<List<Payment>> getPayments() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/payments'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return (data['data'] as List?)
              ?.map((json) => Payment.fromJson(json))
              .toList() ??
          [];
    } else {
      throw Exception(
        'Failed to load payments: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<void> login(String username, String password) async {
    print('Attempting login to: $baseUrl/auth/login');
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': username, 'password': password}),
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        await saveToken(data['access_token']);
      } else {
        throw Exception(
          'Login failed: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Error during login: $e');
      throw e;
    }
  }

  Future<Map<String, dynamic>> getStats() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/payments/stats'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic>? data = json.decode(response.body);
      return data ??
          {
            'totalTransactionsToday': 0,
            'totalTransactionsWeek': 0,
            'revenue': 0,
            'failedTransactions': 0,
          };
    } else {
      throw Exception(
        'Failed to load stats: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }

  fetchPayments() {}

  fetchStats() {}

  getUsers() {}

  addUser(String text, String text2, String text3) {}

  // ... (keep other methods as they are)
}
