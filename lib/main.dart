import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ➔ IMPORT FIREBASE CORE & OPTIONS
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // File ini otomatis dibuat oleh flutterfire cli

import 'providers/auth_provider.dart';
import 'providers/spk_provider.dart';
import 'views/auth/login_page.dart';
import 'views/auth/register_page.dart';
import 'views/main_navigation.dart';
import 'views/penilaian/form_penilaian_page.dart';
import 'views/hasil/hasil_page.dart';
import 'views/history/history_page.dart';
import 'views/splash/splash_page.dart';
import 'shared/theme.dart';

// ➔ UBAH MAIN MENJADI ASYNC UNTUK INISIALISASI FIREBASE
void main() async {
  // Wajib dipanggil pertama kali jika ada proses await sebelum runApp
  WidgetsFlutterBinding.ensureInitialized();

  // ➔ INISIALISASI FIREBASE
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final auth = AuthProvider();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: auth),
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
      theme: AppTheme.lightTheme, // Memasang tema kustom
      // Aplikasi sekarang SELALU mulai dari SplashPage
      home: const SplashPage(),

      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/dashboard': (context) => const MainNavigation(),
        '/form-penilaian': (context) => const FormPenilaianPage(),
        '/hasil-rekomendasi': (context) => const HasilPage(),
        '/history': (context) => const HistoryPage(),
      },
    );
  }
}