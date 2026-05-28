import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/spk_provider.dart';

class FormPenilaianPage extends StatefulWidget {
  const FormPenilaianPage({super.key});

  @override
  State<FormPenilaianPage> createState() => _FormPenilaianPageState();
}

class _FormPenilaianPageState extends State<FormPenilaianPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Menggunakan tipe integer karena Laravel mewajibkan min:1 max:5
  int? _valC1; 
  double _valC2 = 3.0;
  int? _valC3;
  double _valC4 = 3.0;

  void _submitData() async {
    if (_formKey.currentState!.validate()) {
      // Mapping ke ID Question Laravel (Asumsi ID 1 sampai 4 untuk kriteria C1-C4)
      final answers = [
        {'question_id': 1, 'answer_value': _valC1!},
        {'question_id': 2, 'answer_value': _valC2.toInt()},
        {'question_id': 3, 'answer_value': _valC3!},
        {'question_id': 4, 'answer_value': _valC4.toInt()},
      ];

      bool success = await Provider.of<SpkProvider>(context, listen: false).submitPenilaian(answers);
      if (success) {
        Navigator.pushReplacementNamed(context, '/hasil-rekomendasi');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal menghitung rekomendasi')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0D5C4D);
    return Scaffold(
      appBar: AppBar(title: const Text('Input Penilaian Kriteria', style: TextStyle(color: Colors.white)), backgroundColor: primaryColor),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('C1. Nilai Mata Kuliah Relevan', style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(filled: true, fillColor: Colors.white),
                items: const [
                  DropdownMenuItem(value: 5, child: Text('A (4.0)')),
                  DropdownMenuItem(value: 4, child: Text('B (3.0)')),
                  DropdownMenuItem(value: 3, child: Text('C (2.0)')),
                  DropdownMenuItem(value: 2, child: Text('D (1.0)')),
                  DropdownMenuItem(value: 1, child: Text('E (0.0)')),
                ],
                onChanged: (v) => setState(() => _valC1 = v),
                validator: (v) => v == null ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 20),
              const Text('C2. Minat Anda', style: TextStyle(fontWeight: FontWeight.bold)),
              Slider(value: _valC2, min: 1, max: 5, divisions: 4, onChanged: (v) => setState(() => _valC2 = v)),
              const SizedBox(height: 20),
              const Text('C3. Pengalaman Proyek', style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(filled: true, fillColor: Colors.white),
                items: const [
                  DropdownMenuItem(value: 1, child: Text('Tidak Ada')),
                  DropdownMenuItem(value: 3, child: Text('1 Proyek')),
                  DropdownMenuItem(value: 5, child: Text('Banyak Proyek/Magang')),
                ],
                onChanged: (v) => setState(() => _valC3 = v),
                validator: (v) => v == null ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 20),
              const Text('C4. Penguasaan Skill', style: TextStyle(fontWeight: FontWeight.bold)),
              Slider(value: _valC4, min: 1, max: 5, divisions: 4, onChanged: (v) => setState(() => _valC4 = v)),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submitData,
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16)),
                child: const Text('Hitung dengan WASPAS'),
              )
            ],
          ),
        ),
      ),
    );
  }
}