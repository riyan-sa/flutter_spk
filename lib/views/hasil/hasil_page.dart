import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/spk_provider.dart';

class HasilPage extends StatelessWidget {
  const HasilPage({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0D5C4D);
    final listHasil = Provider.of<SpkProvider>(context).hasilTerbaru;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, title: const Text('Thesis Recommendations', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text('Hasil Rekomendasi\nTopik Skripsi Anda', textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            const SizedBox(height: 20),
            
            // Peringkat 1 (Figma Border Style)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: primaryColor, width: 2)),
              child: Column(
                children: [
                  Text(listHasil.first.namaAlternatif, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
                    child: Text('SKOR AKHIR QI : ${listHasil.first.nilaiAkhir}', style: const TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Tabel Sisa Peringkat
            Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.black12), borderRadius: BorderRadius.circular(8)),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: listHasil.length - 1,
                itemBuilder: (context, index) {
                  final item = listHasil[index + 1];
                  return ListTile(
                    leading: CircleAvatar(child: Text('${item.ranking}')),
                    title: Text(item.namaAlternatif),
                    trailing: Text('${item.nilaiAkhir}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}