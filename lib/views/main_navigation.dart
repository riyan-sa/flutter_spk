import 'package:flutter/material.dart';
import 'dashboard/dashboard_page.dart';
import 'penilaian/form_penilaian_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  // Daftar halaman sesuai dengan susunan menu di Figma
  final List<Widget> _pages = [
    const DashboardPage(),
    const FormPenilaianPage(),
    const Center(child: Text('Halaman Simpan (Bookmark)', style: TextStyle(fontSize: 16, color: Colors.grey))),
    const Center(child: Text('Halaman Profil Pengguna', style: TextStyle(fontSize: 16, color: Colors.grey))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0D5C4D); // Hijau Tua SKRIPSIAN
    const inactiveColor = Color(0xFF64748B); // Abu-abu Slate

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xEFEFEFEF), width: 1.5), // Garis pembatas tipis atas sesuai figma
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: primaryColor,
          unselectedItemColor: inactiveColor,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
          items: const [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.home_filled),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.auto_awesome_rounded), // Ikon Sparkles untuk Rekomendasi
              ),
              label: 'Rekomendasi',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.bookmark_border_rounded),
              ),
              label: 'Simpan',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.person_outline_rounded),
              ),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}