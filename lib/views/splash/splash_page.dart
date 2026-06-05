import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Pastikan path import ini sesuai dengan struktur folder lu
import '../../providers/auth_provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Ambil AuthProvider tanpa listen agar tidak memicu build ulang
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Future.wait memastikan kedua proses (delay 2 detik & cek token)
    // berjalan berbarengan dan selesai sebelum pindah halaman.
    await Future.wait([
      Future.delayed(const Duration(seconds: 2)), // Durasi tayang logo
      authProvider.checkLoginStatus(), // Proses cek token di background
    ]);

    if (mounted) {
      if (authProvider.isLoggedIn) {
        // Jika token valid, langsung masuk ke Dashboard
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        // Jika belum ada token, lempar ke halaman Login
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0D5C4D); // Hijau Tua SKRIPSIAN

    return const Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school_rounded, color: Colors.white, size: 80),
            SizedBox(height: 16),
            Text(
              'SKRIPSIAN',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 2.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
