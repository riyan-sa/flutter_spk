import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_client.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String _userName = 'Mahasiswa';

  bool get isLoggedIn => _isLoggedIn;
  String get userName => _userName;

  // Cek apakah user sudah login sebelumnya saat aplikasi baru dibuka
  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token != null) {
      _isLoggedIn = true;
      _userName = prefs.getString('user_name') ?? 'Mahasiswa';
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await ApiClient.dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200 && response.data['success'] == true) {
        final prefs = await SharedPreferences.getInstance();
        // Simpan token Bearer dan nama user secara lokal
        await prefs.setString('auth_token', response.data['data']['token']);
        await prefs.setString('user_name', response.data['data']['user']['name']);
        
        _isLoggedIn = true;
        _userName = response.data['data']['user']['name'];
        notifyListeners();
        return true;
      }
      return false;
    } on DioException catch (e) {
      debugPrint('Login Error: ${e.response?.data}');
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await ApiClient.dio.post('/auth/logout');
    } catch (e) {
      debugPrint('Logout Error di Server: $e');
    } finally {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      _isLoggedIn = false;
      _userName = 'Mahasiswa';
      notifyListeners();
    }
  }
}