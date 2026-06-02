import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/spk_provider.dart';

class FormPenilaianPage extends StatefulWidget {
  const FormPenilaianPage({super.key});

  @override
  State<FormPenilaianPage> createState() => _FormPenilaianPageState();
}

class _FormPenilaianPageState extends State<FormPenilaianPage> {
  final Map<int, int> _selectedAnswers = {1: 3, 2: 3, 3: 3, 4: 3};
  bool _isSending = false;

  void _submitForm() async {
    setState(() => _isSending = true);

    final formattedAnswers = _selectedAnswers.entries.map((entry) {
      return {'question_id': entry.key, 'answer_value': entry.value};
    }).toList();

    bool success = await Provider.of<SpkProvider>(context, listen: false).submitPenilaian(formattedAnswers);
    
    setState(() => _isSending = false);

    if (success && mounted) {
      Navigator.pushNamed(context, '/hasil-rekomendasi');
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0D5C4D);
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Input Parameter Bobot Kriteria', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildSliderCard('C1. Nilai Kelompok MK Relevan', 1),
            _buildSliderCard('C2. Tingkat Minat Pribadi', 2),
            _buildSliderCard('C3. Ketersediaan Portofolio Proyek', 3),
            _buildSliderCard('C4. Penguasaan Tools / Framework', 4),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isSending ? null : _submitForm,
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16)),
              child: _isSending ? const CircularProgressIndicator(color: Colors.white) : const Text('Kirim ke Matriks WASPAS ➔'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSliderCard(String title, int qId) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Slider(
              value: _selectedAnswers[qId]!.toDouble(),
              min: 1, max: 5, divisions: 4,
              label: _selectedAnswers[qId].toString(),
              onChanged: (v) => setState(() => _selectedAnswers[qId] = v.toInt()),
            ),
          ],
        ),
      ),
    );
  }
}