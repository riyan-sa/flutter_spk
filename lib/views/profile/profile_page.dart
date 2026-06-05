import 'package:flutter/material.dart';
import 'package:dio/dio.dart'; // Mengganti http dengan dio
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

// Import ApiClient dan AuthProvider dari arsitektur lu
import '../../providers/api_client.dart';
import '../../providers/auth_provider.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  Map<String, dynamic>? profile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null);
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      // Sangat simpel karena Base URL & Token udah diurus ApiClient
      final response = await ApiClient.dio.get('/auth/profile');

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            // Dio otomatis mengkonversi response ke Map/JSON
            profile = response.data['data'] ?? response.data;
          });
        }
      }
    } on DioException catch (error) {
      debugPrint('Gagal mengambil profile: ${error.response?.data ?? error.message}');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // Fungsi Logout yang terhubung dengan AuthProvider
  void _handleLogout() async {
    // Tampilkan dialog konfirmasi sebelum logout
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar dari akun ini?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      // Panggil provider untuk hapus token dan state
      await Provider.of<AuthProvider>(context, listen: false).logout();
      // Lempar kembali ke halaman login
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  String formatDate(String? dateString) {
    if (dateString == null) return '-';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('d MMMM yyyy', 'id_ID').format(date);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    // ======================
    // LOADING STATE
    // ======================
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF8FAFC),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF0D5C4D)),
        ),
      );
    }

    // ======================
    // ERROR STATE
    // ======================
    if (profile == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              const Text("Gagal memuat profile", style: TextStyle(color: Colors.red, fontSize: 16)),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() => isLoading = true);
                  _fetchProfile();
                },
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Coba Lagi'),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D5C4D)),
              )
            ],
          ),
        ),
      );
    }

    // Ekstrak data untuk mencegah error null
    final studentProfile = profile?['student_profile'] ?? {};
    final String name = profile?['name'] ?? 'Mahasiswa';
    final String initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';

    // ======================
    // MAIN CONTENT
    // ======================
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("Profile", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.5),
          child: Container(color: const Color(0xFFE2E8F0), height: 1.5),
        ),
        actions: [
          // Tombol Logout di pojok kanan atas
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            tooltip: 'Logout',
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1152),
            margin: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(36),
              border: Border.all(color: Colors.grey[200]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // COVER & AVATAR
                SizedBox(
                  height: 300,
                  child: Stack(
                    children: [
                      // Cover Gradient
                      Container(
                        height: 256,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
                          gradient: LinearGradient(
                            colors: [
                              Colors.teal[700]!,
                              Colors.teal[600]!,
                              Colors.green[500]!,
                            ],
                          ),
                        ),
                      ),
                      // Avatar
                      Positioned(
                        bottom: 0,
                        left: 40,
                        child: Container(
                          width: 144,
                          height: 144,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 6),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            backgroundColor: Colors.teal[700],
                            child: Text(
                              initial,
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // CONTENT
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 24, 40, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // HEADER
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.teal[100],
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              "Mahasiswa",
                              style: TextStyle(
                                color: Colors.teal[700],
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          if (profile?['created_at'] != null)
                            Text(
                              "Bergabung ${formatDate(profile!['created_at'])}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF64748B),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      // CARDS GRID
                      GridView.count(
                        crossAxisCount: MediaQuery.of(context).size.width > 768 ? 2 : 1,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 24,
                        mainAxisSpacing: 24,
                        childAspectRatio: 3,
                        children: [
                          InfoCard(title: "Nama Lengkap", value: name),
                          InfoCard(title: "Email", value: profile?['email'] ?? "-"),
                          InfoCard(title: "NIM", value: studentProfile['nim']?.toString() ?? "-"),
                          InfoCard(title: "Semester", value: studentProfile['semester']?.toString() ?? "-"),
                          InfoCard(title: "IPK", value: studentProfile['ipk']?.toString() ?? "-"),
                          InfoCard(title: "Minat", value: studentProfile['minat'] ?? "-"),
                          const InfoCard(title: "Role", value: "Mahasiswa"),
                          InfoCard(title: "ID Pengguna", value: "#${profile?['id'] ?? "-"}"),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ======================
// WIDGET CARD
// ======================
class InfoCard extends StatelessWidget {
  final String title;
  final String value;

  const InfoCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }
}