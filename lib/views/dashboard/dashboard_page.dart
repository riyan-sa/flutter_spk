import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/spk_provider.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0D5C4D);
    const secondaryColor = Color(0xFF14B8A6);

    final spk = Provider.of<SpkProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('school SKRIPSIAN', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
        actions: const [Padding(padding: EdgeInsets.only(right: 16.0), child: CircleAvatar(backgroundColor: primaryColor, child: Text('A', style: TextStyle(color: Colors.white))))],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: primaryColor.withValues(alpha: 0.3))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Halo, ${Provider.of<AuthProvider>(context).userName}!', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Siap Menentukan Topik Skripsimu? Sistem kami siap membantu merekomendasikan topik terbaik berdasarkan minat dan nilaimu.', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/form-penilaian'),
                icon: const Icon(Icons.rocket_launch),
                label: const Text('Mulai Cari Topik Skripsi', style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(backgroundColor: secondaryColor, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Riwayat Tes Sebelumnya', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: spk.riwayat.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = spk.riwayat[index];
                  return ListTile(
                    title: Text(item.namaAlternatif, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Tanggal: ${item.tanggal}'),
                    trailing: Text('${item.nilaiAkhir}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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