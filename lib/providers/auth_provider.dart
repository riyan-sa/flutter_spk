import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_client.dart';

class AuthProvider with ChangeNotifier {
  bool _loading = false;

  bool get loading => _loading;

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  String? token;

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _loading = true;
    notifyListeners();

    try {
      final response = await ApiClient.dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        token = response.data['token'];

        final prefs = await SharedPreferences.getInstance();

        await prefs.setString('token', token!);

        ApiClient.dio.options.headers['Authorization'] =
            'Bearer $token';

        _isLoggedIn = true;

        _loading = false;
        notifyListeners();

        return true;
      }

      _loading = false;
      notifyListeners();

      return false;
    } on DioException catch (e) {
      debugPrint(e.toString());

      _loading = false;
      notifyListeners();

      return false;
    }
  }

  Future<void> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();

    token = prefs.getString('token');

    if (token != null) {
      _isLoggedIn = true;

      ApiClient.dio.options.headers['Authorization'] =
          'Bearer $token';
    }

    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();

    token = null;

    _isLoggedIn = false;

    notifyListeners();
  }
}