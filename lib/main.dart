import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/spk_provider.dart';
import 'views/auth/login_page.dart';
import 'views/main_navigation.dart'; // Import file navigasi baru
import 'views/hasil/hasil_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SpkProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        // Ubah rute /dashboard agar memuat struktur MainNavigation yang punya navbar bawah
        '/dashboard': (context) => const MainNavigation(), 
        '/hasil-rekomendasi': (context) => const HasilPage(),
      },
    );
  }
}