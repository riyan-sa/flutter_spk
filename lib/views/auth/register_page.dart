import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../providers/api_client.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  // Semua Controller sesuai dengan field di database & UI
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _nimController = TextEditingController();
  final _semesterController = TextEditingController();
  final _ipkController = TextEditingController();
  final _minatController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;
  bool _isTermsAccepted = false;
  bool _isLoading = false;
  bool _isScanning = false;

  // ==========================================
  // LOGIKA OCR (ML KIT)
  // ==========================================
  Future<void> _scanKTM() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );

    if (image == null) return;

    setState(() => _isScanning = true);

    try {
      final inputImage = InputImage.fromFilePath(image.path);
      final textRecognizer = TextRecognizer(
        script: TextRecognitionScript.latin,
      );
      final RecognizedText recognizedText = await textRecognizer.processImage(
        inputImage,
      );

      String fullText = recognizedText.text;
      debugPrint("Hasil OCR Mentah:\n$fullText");

      _ekstrakData(fullText);

      textRecognizer.close();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Scan berhasil! Silakan periksa kembali data Anda.'),
            backgroundColor: Color(0xFF0D5C4D),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal membaca KTM. Silakan isi manual.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isScanning = false);
      }
    }
  }

  void _ekstrakData(String rawText) {
    // Pecah teks berdasarkan baris enter
    List<String> barisTeks = rawText.split('\n');

    // Bersihkan baris yang kosong/spasi doang biar akurat
    barisTeks.removeWhere((element) => element.trim().isEmpty);

    // Regex untuk mendeteksi NIM (9-15 digit angka)
    RegExp nimRegex = RegExp(r'\b\d{9,15}\b');

    // Kita cari baris demi baris
    for (int i = 0; i < barisTeks.length; i++) {
      String baris = barisTeks[i].trim();

      // Cek apakah di baris ini ada NIM-nya?
      var nimMatch = nimRegex.firstMatch(baris);

      if (nimMatch != null) {
        // 1. Ketemu NIM! Langsung isi ke TextField NIM
        _nimController.text = nimMatch.group(0)!;

        // 2. Ambil Nama (Karena nama ada di atas NIM, kita ambil index i - 1)
        if (i > 0) {
          _nameController.text = barisTeks[i - 1].trim();
        }

        // Stop pencarian karena NIM dan Nama udah dapet semua
        break;
      }
    }
  }

  // ==========================================
  // LOGIKA REGISTRASI
  // ==========================================
  void _handleRegister() async {
    if (!_isTermsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Anda harus menyetujui Syarat & Ketentuan terlebih dahulu!',
          ),
          backgroundColor: Colors.orangeAccent,
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final response = await ApiClient.dio.post(
          '/auth/register',
          data: {
            'name': _nameController.text.trim(),
            'email': _emailController.text.trim(),
            'password': _passwordController.text,
            'password_confirmation': _confirmPasswordController.text,
            'nim': _nimController.text.trim(),
            'semester': int.tryParse(_semesterController.text.trim()),
            'ipk': double.tryParse(_ipkController.text.trim()),
            'minat': _minatController.text.trim(),
          },
        );

        setState(() => _isLoading = false);

        if (response.statusCode == 200 || response.statusCode == 201) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Registrasi Berhasil! Silakan masuk.'),
                backgroundColor: Color(0xFF0D5C4D),
              ),
            );
            Navigator.pushReplacementNamed(context, '/login');
          }
        }
      } on DioException catch (e) {
        setState(() => _isLoading = false);
        final errorMessage =
            e.response?.data['message'] ??
            'Gagal mendaftarkan akun. Periksa kembali data Anda!';
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _nimController.dispose();
    _semesterController.dispose();
    _ipkController.dispose();
    _minatController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0D5C4D);
    const tealColor = Color(0xFF14B8A6);
    const frameBgColor = Color(0xFFF8FAFC);

    return Scaffold(
      backgroundColor: frameBgColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              color: Colors.white,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // HEADER
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 24.0,
                      right: 24.0,
                      top: 32.0,
                      bottom: 8.0,
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Buat akun mahasiswa untuk melanjutkan',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // FORM
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 16.0,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ==========================================
                          // 0. FITUR SCAN KTM (DIPINDAH KE PALING ATAS)
                          // ==========================================
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: primaryColor.withOpacity(0.2),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.bolt_rounded,
                                      color: Colors.orange[400],
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Isi Otomatis',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0F172A),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Punya KTM? Scan sekarang biar nggak perlu repot ngetik Nama dan NIM.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: _isScanning ? null : _scanKTM,
                                    icon: _isScanning
                                        ? const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                        : const Icon(
                                            Icons.document_scanner_rounded,
                                            size: 18,
                                          ),
                                    label: Text(
                                      _isScanning
                                          ? 'Membaca KTM...'
                                          : 'Scan KTM Saya',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      elevation: 0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Divider(height: 1, thickness: 1),
                          ),

                          // ==========================================
                          // 1. INFORMASI AKUN
                          // ==========================================
                          _buildSectionTitle('Informasi Akun'),
                          _buildInputLabel('Nama Lengkap'),
                          TextFormField(
                            controller: _nameController,
                            decoration: _buildInputDecoration(
                              'Masukkan nama lengkap',
                            ),
                            validator: (v) =>
                                v == null || v.isEmpty ? 'Wajib diisi' : null,
                          ),
                          const SizedBox(height: 16),

                          _buildInputLabel('Email'),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: _buildInputDecoration('Masukkan email'),
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Wajib diisi';
                              if (!v.contains('@'))
                                return 'Format email tidak valid';
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),

                          // ==========================================
                          // 2. DATA MAHASISWA
                          // ==========================================
                          _buildSectionTitle('Data Mahasiswa'),
                          _buildInputLabel('NIM'),
                          TextFormField(
                            controller: _nimController,
                            keyboardType: TextInputType.number,
                            decoration: _buildInputDecoration('Masukkan NIM'),
                            validator: (v) =>
                                v == null || v.isEmpty ? 'Wajib diisi' : null,
                          ),
                          const SizedBox(height: 16),

                          _buildInputLabel('Semester'),
                          TextFormField(
                            controller: _semesterController,
                            keyboardType: TextInputType.number,
                            decoration: _buildInputDecoration('Contoh: 8'),
                            validator: (v) =>
                                v == null || v.isEmpty ? 'Wajib diisi' : null,
                          ),
                          const SizedBox(height: 16),

                          _buildInputLabel('IPK'),
                          TextFormField(
                            controller: _ipkController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: _buildInputDecoration('Contoh: 3.75'),
                            validator: (v) =>
                                v == null || v.isEmpty ? 'Wajib diisi' : null,
                          ),
                          const SizedBox(height: 16),

                          _buildInputLabel('Minat'),
                          TextFormField(
                            controller: _minatController,
                            decoration: _buildInputDecoration(
                              'Contoh: Software Engineer',
                            ),
                            validator: (v) =>
                                v == null || v.isEmpty ? 'Wajib diisi' : null,
                          ),
                          const SizedBox(height: 24),

                          // ==========================================
                          // 3. KEAMANAN AKUN
                          // ==========================================
                          _buildSectionTitle('Keamanan Akun'),

                          _buildInputLabel('Password'),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _isPasswordObscured,
                            decoration: _buildInputDecoration(
                              '********',
                              IconButton(
                                icon: Icon(
                                  _isPasswordObscured
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  size: 20,
                                  color: Colors.grey[400],
                                ),
                                onPressed: () => setState(
                                  () => _isPasswordObscured =
                                      !_isPasswordObscured,
                                ),
                              ),
                            ),
                            validator: (v) => v == null || v.length < 8
                                ? 'Minimal 8 karakter'
                                : null,
                          ),
                          const SizedBox(height: 16),

                          _buildInputLabel('Konfirmasi Password'),
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: _isConfirmPasswordObscured,
                            decoration: _buildInputDecoration(
                              '********',
                              IconButton(
                                icon: Icon(
                                  _isConfirmPasswordObscured
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  size: 20,
                                  color: Colors.grey[400],
                                ),
                                onPressed: () => setState(
                                  () => _isConfirmPasswordObscured =
                                      !_isConfirmPasswordObscured,
                                ),
                              ),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Wajib diisi';
                              if (v != _passwordController.text)
                                return 'Password tidak cocok';
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // S&K dan Tombol Submit
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: _isTermsAccepted,
                                  activeColor: primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  onChanged: (bool? val) => setState(
                                    () => _isTermsAccepted = val ?? false,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text.rich(
                                  TextSpan(
                                    text: 'Saya menyetujui ',
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 13,
                                      height: 1.3,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Syarat & Ketentuan',
                                        style: TextStyle(
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const TextSpan(text: ' serta '),
                                      TextSpan(
                                        text: 'Kebijakan Privasi.',
                                        style: TextStyle(
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleRegister,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'REGISTER',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        letterSpacing: 1,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Sudah punya akun? ',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pushReplacementNamed(
                                  context,
                                  '/login',
                                ),
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                    color: tealColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0F172A),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 13,
          color: Color(0xFF334155),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint, [Widget? suffix]) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      suffixIcon: suffix,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[200]!, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF0D5C4D), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
    );
  }
}
