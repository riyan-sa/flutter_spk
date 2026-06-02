import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      // Mengirimkan email murni hasil inputan user
      await Provider.of<AuthProvider>(context, listen: false).login(
        _emailController.text.trim(),
        _passwordController.text,
      );
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0D5C4D); // Hijau Tua SKRIPSIAN
    const secondaryColor = Color(0xFF14B8A6); // Hijau Teal Pilihan
    const darkFieldColor = Color(0xFF1E293B); // Slate Dark untuk Input Box

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ==========================================
                // ICON UTAMA & JUDUL SESUAI FIGMA
                // ==========================================
                const Center(
                  child: Icon(
                    Icons.school_rounded, // Ikon Topi Toga Akademis
                    size: 64,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'SKRIPSIAN',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32, 
                    fontWeight: FontWeight.w900, 
                    color: primaryColor,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tentukan Topik Skripsimu Sekarang Juga', 
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                ),
                const SizedBox(height: 32),
                
                // Daftar Keunggulan Fitur
                _buildFeatureItem(Icons.analytics, 'Rekomendasi Objektif (WASPAS Method)', 'Penentuan topik cerdas berdasarkan pembobotan parameter akademis secara presisi.', primaryColor),
                _buildFeatureItem(Icons.update, 'Dinamis & Real-time', 'Update data dan ketersediaan topik secara langsung sesuai database fakultas.', primaryColor),
                _buildFeatureItem(Icons.print, 'Simpan & Cetak Riwayat', 'Ekspor hasil rekomendasi anda langsung ke format PDF yang siap diajukan.', primaryColor),
                const SizedBox(height: 32),
                
                // Card Form Input Login
                Card(
                  color: Colors.white,
                  elevation: 2,
                  shadowColor: Colors.black12,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const Text('Selamat Datang', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
                          const SizedBox(height: 4),
                          const Text('Silakan masuk ke akun anda', style: TextStyle(color: Colors.grey, fontSize: 13)),
                          const SizedBox(height: 28),
                          
                          // INPUT FIELD EMAIL (DISESUAIKAN UNTUK TEMBAK API)
                          const Align(alignment: Alignment.centerLeft, child: Text('Email', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Masukkan Alamat Email Anda', 
                              hintStyle: const TextStyle(color: Colors.grey, fontSize: 13), 
                              filled: true, 
                              fillColor: darkFieldColor, 
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), 
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Email wajib diisi';
                              }
                              if (!v.contains('@')) {
                                return 'Format email tidak valid';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 18),
                          
                          const Align(alignment: Alignment.centerLeft, child: Text('Password', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(hintText: '••••••••', hintStyle: const TextStyle(color: Colors.grey, fontSize: 13), filled: true, fillColor: darkFieldColor, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)),
                            validator: (v) => v == null || v.isEmpty ? 'Password wajib diisi' : null,
                          ),
                          const SizedBox(height: 28),
                          
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _handleLogin,
                              style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), elevation: 0),
                              child: const Text('LOGIN ➔', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Teks Register Akun Baru
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Belum memiliki akun? ',
                                style: TextStyle(color: Colors.black54, fontSize: 13),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/register');
                                },
                                child: const Text(
                                  'Daftar Sekarang',
                                  style: TextStyle(
                                    color: secondaryColor, 
                                    fontWeight: FontWeight.bold, 
                                    fontSize: 13,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String desc, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(backgroundColor: color.withValues(alpha: 0.1), child: Icon(icon, color: color, size: 20)),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)), const SizedBox(height: 2), Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 12, height: 1.4))])),
        ],
      ),
    );
  }
}