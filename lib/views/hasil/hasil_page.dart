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
      appBar: AppBar(title: const Text('Rekomendasi WASPAS')),
      body: listHasil.isEmpty
        ? const Center(child: Text('Tidak ada data kalkulasi.'))
        : Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(border: Border.all(color: primaryColor, width: 2), borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      const Text('REKOMENDASI UTAMA', style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
                      const SizedBox(height: 8),
                      Text(listHasil.first.namaAlternatif, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('Skor Qi: ${listHasil.first.nilaiAkhir.toStringAsFixed(4)}', style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: listHasil.length,
                    itemBuilder: (context, index) {
                      final item = listHasil[index];
                      return ListTile(
                        leading: CircleAvatar(child: Text('${item.ranking}')),
                        title: Text(item.namaAlternatif),
                        trailing: Text(item.nilaiAkhir.toStringAsFixed(3)),
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