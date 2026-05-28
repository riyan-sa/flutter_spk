import 'package:flutter/material.dart';

class RiwayatUserPage extends StatelessWidget {
  const RiwayatUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pengguna'),
      ),
      body: ListView(
        children: const [
          Card(
            child: ListTile(
              title: Text('Riyan'),
              subtitle: Text('Memilih Sistem AI'),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Budi'),
              subtitle: Text('Memilih Mobile App'),
            ),
          ),
        ],
      ),
    );
  }
}