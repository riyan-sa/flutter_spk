import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/spk_provider.dart';
import 'views/auth/login_page.dart';
import 'views/main_navigation.dart';
import 'views/hasil/hasil_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final auth = AuthProvider();
  await auth.checkLoginStatus();

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
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) => auth.isLoggedIn ? const MainNavigation() : const LoginPage(),
      ),
      routes: {
        '/login': (context) => const LoginPage(),
        '/dashboard': (context) => const MainNavigation(),
        '/hasil-rekomendasi': (context) => const HasilPage(),
      },
    );
  }
}