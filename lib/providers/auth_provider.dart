import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String _userName = 'Riyan'; // Default nama sesuai figma teman Anda

  bool get isLoggedIn => _isLoggedIn;
  String get userName => _userName;

  Future<bool> login(String email, String password) async {
    // Simulasi delay loading setengah detik
    await Future.delayed(const Duration(milliseconds: 500));
    _isLoggedIn = true;
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    notifyListeners();
  }
}