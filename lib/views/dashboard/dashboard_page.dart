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
    final spk = Provider.of<SpkProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Halo, ${Provider.of<AuthProvider>(context).userName}!', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('Riwayat Kuesioner Anda (WASPAS Database)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 12),
            spk.riwayat.isEmpty 
              ? const Center(child: Padding(padding: EdgeInsets.all(24.0), child: Text('Belum ada riwayat tes.', style: TextStyle(color: Colors.grey))))
              : Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: spk.riwayat.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = spk.riwayat[index];
                      return ListTile(
                        title: Text(item.namaAlternatif, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        subtitle: Text(item.tanggal.split('T')[0], style: const TextStyle(fontSize: 12)),
                        trailing: Text(item.nilaiAkhir.toStringAsFixed(3), style: const TextStyle(fontWeight: FontWeight.bold, color: primaryColor, fontSize: 15)),
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