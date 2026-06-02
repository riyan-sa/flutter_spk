import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../providers/api_client.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Controller penampung data register untuk ditembak ke API Laravel
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;
  bool _isTermsAccepted = false;
  bool _isLoading = false;

  void _handleRegister() async {
    if (!_isTermsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Anda harus menyetujui Syarat & Ketentuan terlebih dahulu!'),
          backgroundColor: Colors.orangeAccent,
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // Mengirimkan payload pendaftaran akun mahasiswa ke endpoint Laravel backend Anda
        final response = await ApiClient.dio.post('/auth/register', data: {
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'username': _usernameController.text.trim(),
          'password': _passwordController.text,
          'password_confirmation': _confirmPasswordController.text,
        });

        setState(() => _isLoading = false);

        if (response.statusCode == 200 || response.statusCode == 201) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Registrasi Berhasil! Silakan login.'), backgroundColor: Color(0xFF0D5C4D)),
            );
            // Kembalikan user ke halaman login setelah akun sukses terdaftar di MySQL
            Navigator.pushReplacementNamed(context, '/login');
          }
        }
      } on DioException catch (e) {
        setState(() => _isLoading = false);
        final errorMessage = e.response?.data['message'] ?? 'Gagal mendaftarkan akun. Periksa kembali data Anda!';
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage), backgroundColor: Colors.redAccent),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0D5C4D); // Hijau Tua SKRIPSIAN
    const tealColor = Color(0xFF14B8A6);    // Teal Link Aksentuasi
    const frameBgColor = Color(0xFFF8FAFC);  // Latar belakang luar abu-abu figma

    return Scaffold(
      backgroundColor: frameBgColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              color: Colors.white,
              elevation: 1,
              shadowColor: Colors.black12,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ==========================================
                  // SECTION 1: HEADER REGISTRASI (GAYA IMAGE_9BDE17.PNG)
                  // ==========================================
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 32.0, bottom: 8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.school_rounded, color: primaryColor, size: 28),
                            const SizedBox(width: 8),
                            const Text(
                              'Skripsian',
                              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Color(0xFF0F172A), letterSpacing: -0.5),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tentukan Topik Skripsimu Sekarang Juga',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  
                  // ==========================================
                  // SECTION 2: INPUT FIELDS FORM REGISTRASI
                  // ==========================================
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // FIELD 1: NAMA LENGKAP
                          _buildInputLabel('Nama Lengkap'),
                          TextFormField(
                            controller: _nameController,
                            style: const TextStyle(fontSize: 14, color: Colors.black87),
                            decoration: _buildInputDecoration('Masukkan nama lengkap Anda', null),
                            validator: (v) => v == null || v.isEmpty ? 'Nama lengkap wajib diisi' : null,
                          ),
                          const SizedBox(height: 18),

                          // FIELD 2: EMAIL
                          _buildInputLabel('Email'),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(fontSize: 14, color: Colors.black87),
                            decoration: _buildInputDecoration('contoh@kampus.ac.id', null),
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Email tidak boleh kosong';
                              if (!v.contains('@')) return 'Format email tidak valid';
                              return null;
                            },
                          ),
                          const SizedBox(height: 18),

                          // FIELD 3: NIM / USERNAME
                          _buildInputLabel('NIM/Username'),
                          TextFormField(
                            controller: _usernameController,
                            style: const TextStyle(fontSize: 14, color: Colors.black87),
                            decoration: _buildInputDecoration('Masukkan NIM atau username', null),
                            validator: (v) => v == null || v.isEmpty ? 'NIM atau username wajib diisi' : null,
                          ),
                          const SizedBox(height: 18),

                          // FIELD 4: PASSWORD
                          _buildInputLabel('Password'),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _isPasswordObscured,
                            style: const TextStyle(fontSize: 14, color: Colors.black87),
                            decoration: _buildInputDecoration(
                              'Min. 8 karakter',
                              IconButton(
                                icon: Icon(_isPasswordObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20, color: Colors.grey[400]),
                                onPressed: () => setState(() => _isPasswordObscured = !_isPasswordObscured),
                              ),
                            ),
                            validator: (v) => v == null || v.length < 8 ? 'Password minimal berisikan 8 karakter' : null,
                          ),
                          const SizedBox(height: 18),

                          // FIELD 5: KONFIRMASI PASSWORD
                          _buildInputLabel('Konfirmasi Password'),
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: _isConfirmPasswordObscured,
                            style: const TextStyle(fontSize: 14, color: Colors.black87),
                            decoration: _buildInputDecoration(
                              'Ulangi password Anda',
                              IconButton(
                                icon: Icon(_isConfirmPasswordObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20, color: Colors.grey[400]),
                                onPressed: () => setState(() => _isConfirmPasswordObscured = !_isConfirmPasswordObscured),
                              ),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Konfirmasi password wajib diisi';
                              if (v != _passwordController.text) return 'Password konfirmasi tidak cocok';
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // CHECKBOX SYARAT & KETENTUAN
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: _isTermsAccepted,
                                  activeColor: primaryColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                  side: BorderSide(color: Colors.grey[300]!, width: 1.5),
                                  onChanged: (bool? val) => setState(() => _isTermsAccepted = val ?? false),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text.rich(
                                  TextSpan(
                                    text: 'Saya menyetujui ',
                                    style: const TextStyle(color: Colors.black54, fontSize: 13, height: 1.3),
                                    children: [
                                      TextSpan(text: 'Syarat & Ketentuan', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                                      const TextSpan(text: ' serta '),
                                      TextSpan(text: 'Kebijakan Privasi Skripsian.', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // TOMBOL SUBMIT REGISTER
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleRegister,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                elevation: 0,
                              ),
                              child: _isLoading
                                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Text('DAFTAR SEKARANG', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 0.5)),
                                        SizedBox(width: 8),
                                        Icon(Icons.arrow_forward_rounded, size: 16),
                                      ],
                                    ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // LINK UNTUK KEMBALI KE LOGIN
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Sudah punya akun? ', style: TextStyle(color: Colors.black54, fontSize: 14)),
                              GestureDetector(
                                onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                                child: const Text('Login', style: TextStyle(color: tealColor, fontWeight: FontWeight.bold, fontSize: 14)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ==========================================
                  // SECTION 3: FOOTER KEAMANAN DATA TERJAMIN
                  // ==========================================
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF8FAFC), // Warna abu figma bawah card
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(color: Color(0xFFDCFCE7), shape: BoxShape.circle),
                          child: const Icon(Icons.verified_user_rounded, color: Color(0xFF15803D), size: 20),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Keamanan Data Terjamin',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B)),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Data akademik dan draf topik skripsi Anda akan terenkripsi secara aman dalam sistem kami.',
                                style: TextStyle(fontSize: 12, color: Colors.grey[600], height: 1.4),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget kecil pembantu untuk merender label form input
  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF334155)),
      ),
    );
  }

  // Fungsi pembantu dekorasi input box agar mirip 100% dengan gaya minimalis figma
  InputDecoration _buildInputDecoration(String hint, Widget? suffix) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      suffixIcon: suffix,
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[200]!, width: 1.5)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF0D5C4D), width: 1.5)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.redAccent, width: 1.5)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.redAccent, width: 1.5)),
    );
  }
}