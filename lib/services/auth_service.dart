import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:farm_booking_app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  final Dio _dio = Dio();

  AuthService() {
    _dio.options.headers['Accept'] = 'application/json';
    _dio.options.headers['Content-Type'] = 'application/json';
  }

  Future<User> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '${Constants.baseUrl}/api/auth/login',
        data: {
          'email': email,
          'password': password,
          'device_name': 'flutter_app_ios',
        },
      );

      if (response.statusCode == 200) {
        final userData = response.data;
        String encodedUserMap = jsonEncode(userData);
        final user = User.fromJson(userData);

        // Save token to shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', encodedUserMap);

        return user;
      } else {
        throw Exception('Failed to login: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Login failed: ${e.message}');
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token != null) {
        // You might need to implement a proper logout API call here
        // For example:
        // await _dio.post(
        //   '$baseUrl/auth/logout',
        //   options: Options(headers: {'Authorization': 'Bearer $token'}),
        // );
      }

      await prefs.remove('user');
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      final userData = jsonDecode(userJson);
      return User.fromJson(userData);
    }
    return null;
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('user');
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Map<String, dynamic>> getVendorFarmhousesAvailability(
      int vendorId) async {
    try {
      final token = await getToken();
      final response = await _dio.get(
        'https://bookyourfarms.com/user/space/availability/vendor-farmhouses',
        queryParameters: {
          'vendor_id': vendorId,
        },
        options: Options(
          headers: {
            'Authorization': token != null ? 'Bearer $token' : null,
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(
            'Failed to get vendor farmhouses: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to get vendor farmhouses: ${e.message}');
    }
  }
}
