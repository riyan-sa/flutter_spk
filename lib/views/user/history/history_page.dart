import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/spk_provider.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<SpkProvider>(context, listen: false)
          .fetchRiwayat();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SpkProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Rekomendasi'),
      ),
      body: ListView.builder(
        itemCount: provider.riwayat.length,
        itemBuilder: (context, index) {
          final item = provider.riwayat[index];

          return Card(
            child: ListTile(
              title: Text(item.judul),
              subtitle: Text(item.tanggal),
            ),
          );
        },
      ),
    );
  }
}