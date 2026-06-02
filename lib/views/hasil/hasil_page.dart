import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/spk_provider.dart';

class HasilPage extends StatelessWidget {
  const HasilPage({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0D5C4D); // Hijau Tua SKRIPSIAN
    const textDarkColor = Color(0xFF0F766E); // Warna Teks Judul Utama / Badge
    const tableHeaderBg = Color(0xFFF1F5F9); // Latar belakang abu-abu terang header tabel

    // Mengambil data terintegrasi hasil perhitungan WASPAS dari SpkProvider
    final listHasil = Provider.of<SpkProvider>(context).hasilTerbaru;

    // Fungsi pembantu untuk memetakan nama kriteria agar kodenya sama persis dengan image_9be4e4.png
    String getKodeTopik(String nama) {
      if (nama.contains('Artificial Intelligence')) return 'A2';
      if (nama.contains('Cyber Security')) return 'A2'; // Sesuai mockup figma
      if (nama.contains('Cloud Computing')) return 'A3';
      if (nama.contains('Software Engineering')) return 'A5';
      if (nama.contains('Data Science')) return 'A1';
      if (nama.contains('Internet of Things')) return 'A6';
      if (nama.contains('Mobile Application')) return 'A4';
      return 'A0';
    }

    return Scaffold(
      backgroundColor: Colors.white,
      // ==========================================
      // APPBAR SESUAI IMAGE_9BE4E4.PNG
      // ==========================================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: primaryColor),
          onPressed: () => Navigator.pushReplacementNamed(context, '/dashboard'),
        ),
        title: const Text(
          'Thesis Recommendations',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, color: primaryColor),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.5),
          child: Container(color: const Color(0xFFE2E8F0), height: 1.5),
        ),
      ),
      body: SafeArea(
        child: listHasil.isEmpty
            ? const Center(
                child: Text('Tidak ada data kalkulasi terbaru.', style: TextStyle(color: Colors.grey)),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Judul Utama Halaman
                    const Text(
                      'Hasil Rekomendasi\nTopik Skripsi Anda',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.black87, height: 1.2),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Berdasarkan perhitungan metode WASPAS terhadap preferensi dan kompetensi Anda.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.4),
                    ),
                    const SizedBox(height: 28),

                    // ==========================================
                    // CONTAINER UTAMA: PERINGKAT 1 (REKOMENDASI TERATAS)
                    // ==========================================
                    Container(
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: primaryColor, width: 2),
                      ),
                      child: Column(
                        children: [
                          // Lencana Rekomendasi Teratas
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE0F2FE),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.stars_rounded, color: textDarkColor, size: 14),
                                SizedBox(width: 6),
                                Text(
                                  'REKOMENDASI TERATAS',
                                  style: TextStyle(color: textDarkColor, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                          
                          // Judul Topik Teratas (Membesar & Centered)
                          Text(
                            listHasil.first.namaAlternatif,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: textDarkColor, height: 1.2),
                          ),
                          const SizedBox(height: 12),
                          
                          Text(
                            'Bidang ini paling sesuai dengan profil akademis dan minat riset yang Anda unggah sebelumnya.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.4),
                          ),
                          const SizedBox(height: 20),
                          
                          // Kotak Pencapaian Skor Qi dengan Ikon Piala
                          Container(
                            width: 140,
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Column(
                              children: [
                                const Icon(Icons.emoji_events_rounded, color: textDarkColor, size: 36),
                                const SizedBox(height: 6),
                                const Text(
                                  'SKOR AKHIR QI',
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black54, letterSpacing: 0.3),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  listHasil.first.nilaiAkhir.toStringAsFixed(3),
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: textDarkColor),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // ==========================================
                    // KOMPONEN: TABEL PERINGKAT LAINNYA
                    // ==========================================
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Judul Header Komponen Tabel
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: tableHeaderBg.withValues(alpha: 0.5),
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                            ),
                            child: const Text(
                              'Peringkat Lainnya',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                          ),
                          const Divider(height: 1, color: Color(0xFFE2E8F0)),
                          
                          // Baris Kepala Judul Kolom Tabel
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            color: Colors.white,
                            child: Row(
                              children: const [
                                Expanded(flex: 2, child: Text('PERINGKAT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54))),
                                Expanded(flex: 2, child: Text('KODE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54))),
                                Expanded(flex: 6, child: Text('NAMA BIDANG TOPIK', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54))),
                              ],
                            ),
                          ),
                          const Divider(height: 1, color: Color(0xFFE2E8F0)),

                          // Loop data alternatif tersisa dari API Laravel (Indeks ke-2 dst)
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: listHasil.length - 1,
                            separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFE2E8F0)),
                            itemBuilder: (context, index) {
                              final item = listHasil[index + 1];
                              int rankingKe = index + 2;

                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        '$rankingKe',
                                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        getKodeTopik(item.namaAlternatif),
                                        style: const TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 6,
                                      child: Text(
                                        item.namaAlternatif,
                                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87, height: 1.3),
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
                    const SizedBox(height: 32),

                    // ==========================================
                    // TOMBOL AKSI BAWAH (PDF & KEMBALI)
                    // ==========================================
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.file_download_outlined, size: 18),
                      label: const Text('Cetak / Simpan PDF', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    OutlinedButton.icon(
                      onPressed: () => Navigator.pushReplacementNamed(context, '/dashboard'),
                      icon: const Icon(Icons.dashboard_customize_outlined, size: 16),
                      label: const Text('Kembali ke Dashboard', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primaryColor,
                        side: const BorderSide(color: primaryColor, width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
      ),
    );
  }
}