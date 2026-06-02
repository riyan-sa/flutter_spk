import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/spk_provider.dart';

class FormPenilaianPage extends StatefulWidget {
  const FormPenilaianPage({super.key});

  @override
  State<FormPenilaianPage> createState() => _FormPenilaianPageState();
}

class _FormPenilaianPageState extends State<FormPenilaianPage> {
  int _valC2 = 3;
  int _valC3 = 3;

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0D5C4D);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(backgroundColor: Colors.white, title: const Text('Student Recommendation', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('SECTION C2 : MINAT MAHASISWA', style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor, fontSize: 12)),
            const SizedBox(height: 8),
            _buildSelectionCard('Seberapa besar minat Anda pada penelitian akademis?', _valC2, (v) => setState(() => _valC2 = v), primaryColor),
            const SizedBox(height: 24),
            const Text('SECTION C3 : PENGALAMAN', style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor, fontSize: 12)),
            const SizedBox(height: 8),
            _buildSelectionCard('Seberapa besar pengalaman implementasi proyek Anda?', _valC3, (v) => setState(() => _valC3 = v), primaryColor),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/hasil-rekomendasi');
              },
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              child: const Text('Hitung Rekomendasi Topik', style: TextStyle(fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionCard(String question, int groupValue, Function(int) onSelected, Color activeColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (index) {
              int val = index + 1;
              bool isSelected = groupValue == val;
              return GestureDetector(
                onTap: () => onSelected(val),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: isSelected ? activeColor : const Color(0xFFF1F5F9),
                  child: Text('$val', style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}