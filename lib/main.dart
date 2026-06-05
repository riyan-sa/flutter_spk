import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/spk_provider.dart';
import 'views/auth/login_page.dart';
import 'views/auth/register_page.dart';
import 'views/main_navigation.dart';
import 'views/penilaian/form_penilaian_page.dart';
import 'views/hasil/hasil_page.dart';
import 'views/history/history_page.dart';
// Import file splash screen dan theme lu
import 'views/splash/splash_page.dart';
import 'shared/theme.dart';

// Hapus 'async' di void main karena kita gak butuh await checkLoginStatus lagi di sini
void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      theme: AppTheme.lightTheme, // Memasang tema kustom lu
      // Aplikasi sekarang SELALU mulai dari SplashPage
      home: const SplashPage(),

      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/dashboard': (context) => const MainNavigation(),
        '/form-penilaian': (context) => const FormPenilaianPage(),
        '/hasil-rekomendasi': (context) => const HasilPage(),
        '/history': (context) =>
            const HistoryPage(), // Tambahkan route untuk HistoryPage
      },
    );
  }
}
