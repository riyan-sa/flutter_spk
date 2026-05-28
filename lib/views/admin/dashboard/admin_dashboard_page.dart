import 'package:flutter/material.dart';

import '../alternatif/alternatif_page.dart';
import '../bobot/bobot_page.dart';
import '../kriteria/kriteria_page.dart';
import '../riwayat/riwayat_user_page.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            menuCard(
              context,
              'Alternatif',
              Icons.list,
              const AlternatifPage(),
            ),
            menuCard(
              context,
              'Kriteria',
              Icons.category,
              const KriteriaPage(),
            ),
            menuCard(
              context,
              'Bobot',
              Icons.tune,
              const BobotPage(),
            ),
            menuCard(
              context,
              'Riwayat',
              Icons.history,
              const RiwayatUserPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget menuCard(
    BuildContext context,
    String title,
    IconData icon,
    Widget page,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
      child: Card(
        elevation: 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}