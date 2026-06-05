import 'package:flutter/material.dart';
import 'dashboard/dashboard_page.dart';
import 'penilaian/form_penilaian_page.dart';
import 'profile/profile_page.dart';
import 'history/history_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  // Susunan halaman pembungkus kontens
  final List<Widget> _pages = [
    const DashboardPage(),
    const FormPenilaianPage(),
    const HistoryPage(),
    const Profilepage(),
  ];

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0D5C4D); // Hijau Tua SKRIPSIAN
    const activeMintColor = Color(
      0xFF6EE7B7,
    ); // Hijau Mint Terang untuk isi Cari Topik aktif
    const inactiveColor = Color(
      0xFF334155,
    ); // Abu-abu Slate untuk menu tidak aktif

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      // ==========================================
      // REVISI KUSTOM NAVBAR SESUAI IMAGE_76B986.PNG
      // ==========================================
      bottomNavigationBar: Container(
        height: 76,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Color(
                0xFFE2E8F0,
              ), // Garis pembatas abu-abu tipis atas navbar
              width: 1.5,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // TAB 1: HOME
            _buildNavItem(
              index: 0,
              icon: Icons.home_outlined,
              activeIcon: Icons.home_outlined,
              label: 'Home',
              activeColor: primaryColor,
              inactiveColor: inactiveColor,
            ),

            // TAB 2: CARI TOPIK (FLOATING PILL CONTAINER STYLE)
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedIndex = 1),
                child: _selectedIndex == 1
                    ? Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(
                            16,
                          ), // Sisi melengkung figma kotak
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.auto_awesome_rounded,
                              color: activeMintColor,
                              size: 22,
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Cari Topik',
                              style: TextStyle(
                                color: activeMintColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.auto_awesome_rounded,
                            color: inactiveColor,
                            size: 22,
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Cari Topik',
                            style: TextStyle(
                              color: inactiveColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            // TAB 3: HISTORY
            _buildNavItem(
              index: 2,
              icon: Icons.bookmark_border_rounded,
              activeIcon: Icons.bookmark_border_rounded,
              label: 'History',
              activeColor: primaryColor,
              inactiveColor: inactiveColor,
            ),

            // TAB 4: PROFIL
            _buildNavItem(
              index: 3,
              icon: Icons.person_outline_rounded,
              activeIcon: Icons.person_outline_rounded,
              label: 'Profil',
              activeColor: primaryColor,
              inactiveColor: inactiveColor,
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi pembantu pembentuk item navigasi standar (Home, History, Profil)
  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required Color activeColor,
    required Color inactiveColor,
  }) {
    final isSelected = _selectedIndex == index;
    final color = isSelected ? activeColor : inactiveColor;

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedIndex = index),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isSelected ? activeIcon : icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
