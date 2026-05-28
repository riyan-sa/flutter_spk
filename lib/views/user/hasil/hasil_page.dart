import 'package:flutter/material.dart';

class HasilPage extends StatelessWidget {
  const HasilPage({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0D5C4D);
    const secondaryColor = Color(0xFF14B8A6);

    final List<Map<String, dynamic>> alternatifRanking = [
      {'ranking': 1, 'kode': 'A1', 'nama': 'Artificial Intelligence & Intelligent System', 'skor': 0.942, 'desc': 'Unggul di kriteria minat & penguasaan skill.'},
      {'ranking': 2, 'kode': 'A4', 'nama': 'Data Science & Big Data Analytics', 'skor': 0.885, 'desc': 'Nilai mata kuliah tinggi namun kuota dosen terbatas.'},
      {'ranking': 3, 'kode': 'A2', 'nama': 'Mobile & Cloud Computing', 'skor': 0.812, 'desc': 'Kesesuaian profil lulusan sangat baik.'},
    ];

    final topOne = alternatifRanking.first;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Rekomendasi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('REKOMENDASI TERBAIK', style: TextStyle(color: secondaryColor, fontWeight: FontWeight.bold, fontSize: 12)),
                    const SizedBox(height: 8),
                    Text(topOne['nama'], style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    const Divider(color: Colors.white24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Skor Akhir WASPAS (Qi):', style: TextStyle(color: Colors.white70)),
                        Text(topOne['skor'].toString(), style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Urutan Peringkat Alternatif', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: primaryColor)),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: alternatifRanking.length,
              itemBuilder: (context, index) {
                final item = alternatifRanking[index];
                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Colors.black12)),
                  child: ListTile(
                    leading: CircleAvatar(backgroundColor: index == 0 ? secondaryColor : Colors.grey[200], child: Text('#${item['ranking']}')),
                    title: Text(item['nama'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    trailing: Text(item['skor'].toString(), style: const TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.picture_as_pdf_rounded),
              label: const Text('Cetak Hasil Ke PDF'),
              style: ElevatedButton.styleFrom(backgroundColor: secondaryColor, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            )
          ],
        ),
      ),
    );
  }
}