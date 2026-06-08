import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'api_client.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String _userName = 'Mahasiswa';
  bool _isLoading = false; // Menambahkan state loading khusus

  bool get isLoggedIn => _isLoggedIn;
  String get userName => _userName;
  bool get isLoading => _isLoading; // Getter untuk state loading

  // Inisialisasi konfigurasi GoogleSignIn
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

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

  // ==========================================
  // AUTENTIKASI LAMA (TETAP DIJAGA UTUH 100%)
  // ==========================================
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
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
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } on DioException catch (e) {
      debugPrint('Login Error: ${e.response?.data}');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ==========================================
  // FITUR TAMBAHAN: LOGIN GOOGLE OPTIONAL
  // ==========================================
  Future<bool> loginWithGoogle() async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Munculkan pop-up pilihan akun Google di HP
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _isLoading = false;
        notifyListeners();
        return false; // User membatalkan dialog login Google
      }

      // 2. Ambil ID Token autentikasi dari Google
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        debugPrint('Google ID Token tidak ditemukan.');
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // 3. Tembak idToken Google ke endpoint baru backend Laravel Anda
      final response = await ApiClient.dio.post('/auth/google', data: {
        'id_token': idToken,
      });

      if (response.statusCode == 200 && response.data['success'] == true) {
        final prefs = await SharedPreferences.getInstance();
        
        // Simpan data token Sanctum dan nama user dengan cara yang sama seperti login lama
        await prefs.setString('auth_token', response.data['data']['token']);
        await prefs.setString('user_name', response.data['data']['user']['name']);

        _isLoggedIn = true;
        _userName = response.data['data']['user']['name'];
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _isLoading = false;
      notifyListeners();
      return false;
    } on DioException catch (e) {
      debugPrint('Google Auth Server Error: ${e.response?.data}');
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      debugPrint('Error Autentikasi Google: $e');
      _isLoading = false;
      notifyListeners();
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
      
      // Putus hubungan sesi google sign in agar user bisa memilih email lain saat login nanti
      try {
        await _googleSignIn.signOut();
      } catch (_) {}
      
      notifyListeners();
    }
  }
}