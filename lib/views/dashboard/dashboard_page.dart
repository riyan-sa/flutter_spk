import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/spk_provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SpkProvider>(context, listen: false).fetchRiwayat();
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0D5C4D); 
    const bgColor = Color(0xFFF8F9FA);      

    final spkProvider = Provider.of<SpkProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.5),
          child: Container(color: const Color(0xFFEFEFEF), height: 1.5),
        ),
        title: Row(
          children: [
            const Text(
              'SKRIPSIAN',
              style: TextStyle(color: primaryColor, fontWeight: FontWeight.w900, fontSize: 18),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: primaryColor,
              child: Text(
                authProvider.userName.isNotEmpty ? authProvider.userName[0].toUpperCase() : 'A',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // BOX CONTAINER: SAPAAN USER
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Halo, ${authProvider.userName}!',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.black87),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Siap Menentukan Topik Skripsimu? Sistem kami siap membantu merekomendasikan topik terbaik berdasarkan minat dan nilaimu.',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // TOMBOL UTAMA: MULAI CARI TOPIK SKRIPSI
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/form-penilaian');
              },
              icon: const Icon(Icons.rocket_launch_rounded, size: 18),
              label: const Text(
                'Mulai Cari Topik Skripsi',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
            ),
            const SizedBox(height: 24),

            // CONTAINER: PANDUAN PENGISIAN
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.info_outline_rounded, color: primaryColor, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Panduan Pengisian',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildPanduanStep('1', 'Masukkan nilai kriteria secara objektif.'),
                  const SizedBox(height: 16),
                  _buildPanduanStep('2', 'Isi kuesioner minat dan penguasaan teknologi.'),
                  const SizedBox(height: 16),
                  _buildPanduanStep('3', 'Sistem akan otomatis menghitung rekomendasi terbaik dengan metode WASPAS.'),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // SECTION: TABEL RIWAYAT TES SEBELUMNYA
            const Text(
              'Riwayat Tes Sebelumnya',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Baris Tabel
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    color: const Color(0xFFF8F9FA),
                    child: Row(
                      children: const [
                        Expanded(flex: 3, child: Text('TANGGAL', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54))),
                        Expanded(flex: 5, child: Text('REKOMENDASI (RANK 1)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54))),
                        Expanded(
                          flex: 2, 
                          child: Align( // ➔ SUDAH DIPERBAIKI MENGGUNAKAN WIDGET ALIGN (BARIS 186)
                            alignment: Alignment.centerRight, 
                            child: Text('SKOR QI', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54))
                          )
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xFFE2E8F0)),

                  // Isi Data Tabel Dinamis dari API Laravel
                  spkProvider.riwayat.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Center(child: Text('Belum ada data histori.', style: TextStyle(color: Colors.grey, fontSize: 13))),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: spkProvider.riwayat.length,
                          separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFE2E8F0)),
                          itemBuilder: (context, index) {
                            final item = spkProvider.riwayat[index];
                            final dotColor = index % 2 == 0 ? const Color(0xFF0D5C4D) : const Color(0xFF475569);

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      item.tanggal.contains('T') ? item.tanggal.split('T')[0] : item.tanggal,
                                      style: const TextStyle(fontSize: 13, color: Colors.black87),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Row(
                                      children: [
                                        Icon(Icons.circle, size: 8, color: dotColor),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            item.namaAlternatif,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Align( // ➔ SUDAH DIPERBAIKI MENGGUNAKAN WIDGET ALIGN (BARIS 237)
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        item.nilaiAkhir.toStringAsFixed(3),
                                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black87,
                side: const BorderSide(color: Color(0xFFCBD5E1)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Lihat Semua Riwayat', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 48),

            // FOOTER BRANDING & LINKS
            const Text(
              'SKRIPSIAN',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w900, color: primaryColor, fontSize: 14, letterSpacing: 0.5),
            ),
            const SizedBox(height: 6),
            Text(
              '© 2024 SKRIPSIAN. Platform Rekomendasi Topik\nSkripsi Terpercaya.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: Colors.grey[500], height: 1.4),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildFooterLink('Tentang Kami'),
                _buildFooterDivider(),
                _buildFooterLink('Kebijakan Privasi'),
                _buildFooterDivider(),
                _buildFooterLink('Hubungi Bantuan'),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPanduanStep(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Color(0xFFDBEAFE), 
            shape: BoxShape.circle,
          ),
          child: Text(
            number,
            style: const TextStyle(color: Color(0xFF1E40AF), fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.4),
          ),
        ),
      ],
    );
  }

  Widget _buildFooterLink(String label) {
    return GestureDetector(
      onTap: () {},
      child: Text(
        label,
        style: const TextStyle(fontSize: 11, color: Colors.black87, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildFooterDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text('|', style: TextStyle(color: Colors.grey[400], fontSize: 11)),
    );
  }
}