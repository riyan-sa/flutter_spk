import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/spk_provider.dart';

class FormPenilaianPage extends StatefulWidget {
  const FormPenilaianPage({super.key});

  @override
  State<FormPenilaianPage> createState() => _FormPenilaianPageState();
}

class _FormPenilaianPageState extends State<FormPenilaianPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isSending = false;

  // ==========================================
  // CONTROLLER SECTION C1 (NILAI MATA KULIAH)
  // ==========================================
  final Map<String, TextEditingController> _c1Controllers = {
    'rpl': TextEditingController(),
    'framework': TextEditingController(),
    'db': TextEditingController(),
    'ai': TextEditingController(),
    'spk': TextEditingController(),
    'stats': TextEditingController(),
    'mobile': TextEditingController(),
  };

  // ==========================================
  // DATA STRUKTUR BIDANG TOPIK (A1 - A8)
  // ==========================================
  final List<Map<String, String>> _topikList = [
    {'id': 'A1', 'name': 'A1 – Software Engineering'},
    {'id': 'A2', 'name': 'A2 – Web & Enterprise Application'},
    {'id': 'A3', 'name': 'A3 – Database & Data Engineering'},
    {'id': 'A4', 'name': 'A4 – Artificial Intelligence'},
    {'id': 'A5', 'name': 'A5 – System Analyst & DSS'},
    {'id': 'A6', 'name': 'A6 – Data Science & BI'},
    {'id': 'A8', 'name': 'A8 – Mobile & Smart Application'},
  ];

  // State Nilai Tampung Kuesioner per Bidang Topik
  final Map<String, dynamic> _kuesionerValues = {};

  @override
  void initState() {
    super.initState();
    // Inisialisasi nilai default (3 untuk skala 1-5) untuk setiap topik
    for (var topik in _topikList) {
      String id = topik['id']!;
      _kuesionerValues['${id}_C2'] = 3; 
      _kuesionerValues['${id}_C3'] = 3; 
      _kuesionerValues['${id}_C4'] = 3.0; 
      _kuesionerValues['${id}_C9'] = 3; 
    }
  }

  @override
  void dispose() {
    for (var controller in _c1Controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

 void _submitDataKeWaspas() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSending = true);

      // 1. Ekstrak & Hitung Rata-Rata Nilai C1 (Skala 0-100)
      double totalC1 = 0;
      _c1Controllers.forEach((key, controller) {
        totalC1 += double.tryParse(controller.text) ?? 0.0;
      });
      double rataRataC1Raw = totalC1 / _c1Controllers.length;

      // KONSISTENSI VALIDASI: Konversi nilai ujian 0-100 menjadi Skala Likert 1-5
      int nilaiRataRataC1;
      if (rataRataC1Raw >= 85) {
        nilaiRataRataC1 = 5; // Sangat Baik
      } else if (rataRataC1Raw >= 75) {
        nilaiRataRataC1 = 4; // Baik
      } else if (rataRataC1Raw >= 60) {
        nilaiRataRataC1 = 3; // Cukup
      } else if (rataRataC1Raw >= 45) {
        nilaiRataRataC1 = 2; // Kurang
      } else {
        nilaiRataRataC1 = 1; // Sangat Kurang
      }

      // 2. Format struktur payload jawaban dinamis ke format Array Map
      final List<Map<String, int>> payloadAnswers = [
        {'question_id': 1, 'answer_value': nilaiRataRataC1}, // Aman dikirim karena nilainya 1-5
      ];

      // Hitung rata-rata kuesioner gabungan bidang untuk C2, C3, C4, C9
      double totalC2 = 0, totalC3 = 0, totalC4 = 0, totalC9 = 0;
      for (var topik in _topikList) {
        String id = topik['id']!;
        totalC2 += _kuesionerValues['${id}_C2'] as int;
        totalC3 += _kuesionerValues['${id}_C3'] as int;
        totalC4 += (_kuesionerValues['${id}_C4'] as double).toInt();
        totalC9 += _kuesionerValues['${id}_C9'] as int;
      }

      int len = _topikList.length;
      payloadAnswers.add({'question_id': 2, 'answer_value': (totalC2 / len).round()});
      payloadAnswers.add({'question_id': 3, 'answer_value': (totalC3 / len).round()});
      payloadAnswers.add({'question_id': 4, 'answer_value': (totalC4 / len).round()});
      payloadAnswers.add({'question_id': 9, 'answer_value': (totalC9 / len).round()});

      // Log ke debug console untuk melihat payload sebelum dikirim
      debugPrint('Payload dikirim ke Laravel: $payloadAnswers');

      bool success = await Provider.of<SpkProvider>(context, listen: false).submitPenilaian(payloadAnswers);

      setState(() => _isSending = false);

      if (success && mounted) {
        Navigator.pushNamed(context, '/hasil-rekomendasi');
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal memproses perhitungan ke server Laravel! Periksa kesesuaian parameter data.'), 
            backgroundColor: Colors.redAccent
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0D5C4D); // Hijau Utama SKRIPSIAN
    const darkFieldColor = Color(0xFF1E293B); // Background Input Box Gelap
    const tealTextColor = Color(0xFF0F766E); // Warna Teks Label Kriteria

    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      // ==========================================
      // APPBAR YANG SUDAH DISESUAIKAN (TANPA GARIS 3 & AVATAR SAMA DENGAN DASHBOARD)
      // ==========================================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // Menghilangkan tombol back otomatis jika ada tumpukan halaman
        title: const Text(
          'SKRIPSIAN',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: primaryColor, letterSpacing: 0.5),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: primaryColor,
              child: Text(
                authProvider.userName.isNotEmpty ? authProvider.userName[0].toUpperCase() : 'R',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.5),
          child: Container(color: const Color(0xFFE2E8F0), height: 1.5),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // HEADLINE: STUDENT ASSESSMENT
                const Text(
                  'Student Assessment',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Text(
                  'Complete the following evaluation to receive an AI-driven thesis topic recommendation based on your academic performance and interests.',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.4),
                ),
                const SizedBox(height: 24),

                // HEADER SECTION C1
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFF99F6E4), borderRadius: BorderRadius.circular(4)),
                      child: const Text('C1', style: TextStyle(color: tealTextColor, fontWeight: FontWeight.bold, fontSize: 11)),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Nilai Mata Kuliah Relevan',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: tealTextColor),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // GRID TEXTBOXES FOR C1
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: _buildGridTextBox('Rekayasa Perangkat\nLunak', _c1Controllers['rpl']!, darkFieldColor)),
                          const SizedBox(width: 14),
                          Expanded(child: _buildGridTextBox('Framework\nProgramming', _c1Controllers['framework']!, darkFieldColor)),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(child: _buildGridTextBox('Sistem Basis Data', _c1Controllers['db']!, darkFieldColor)),
                          const SizedBox(width: 14),
                          Expanded(child: _buildGridTextBox('Kecerdasan Buatan\n(AI)', _c1Controllers['ai']!, darkFieldColor)),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(child: _buildGridTextBox('Sistem Pendukung\nKeputusan', _c1Controllers['spk']!, darkFieldColor)),
                          const SizedBox(width: 14),
                          Expanded(child: _buildGridTextBox('Statistika\nKomputer', _c1Controllers['stats']!, darkFieldColor)),
                        ],
                      ),
                      const SizedBox(height: 14),
                      _buildGridTextBox('Mobile Programming', _c1Controllers['mobile']!, darkFieldColor, isFullWidth: true),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // LOOPING CARD UNTUK TOPIK A1 SAMPAI A8
                ..._topikList.map((topik) {
                  String id = topik['id']!;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(11), topRight: Radius.circular(11)),
                          ),
                          child: Text(
                            topik['name']!,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSubLabelKriteria('MINAT MAHASISWA (C2)', tealTextColor),
                              const SizedBox(height: 10),
                              _buildSkalaLikertRow(
                                labelKiri: 'Sangat\nTidak\nMinat',
                                labelKanan: 'Sangat\nMinat',
                                currentVal: _kuesionerValues['${id}_C2'] as int,
                                onSelected: (v) => setState(() => _kuesionerValues['${id}_C2'] = v),
                                activeColor: primaryColor,
                              ),
                              const SizedBox(height: 20),

                              _buildSubLabelKriteria('PENGALAMAN PROYEK (C3)', tealTextColor),
                              const SizedBox(height: 10),
                              _buildPengalamanTingkatRow(
                                currentVal: _kuesionerValues['${id}_C3'] as int,
                                onSelected: (v) => setState(() => _kuesionerValues['${id}_C3'] = v),
                                activeColor: primaryColor,
                              ),
                              const SizedBox(height: 20),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildSubLabelKriteria('PENGUASAAN TEKNOLOGI (C4)', tealTextColor),
                                  Text(
                                    '${(_kuesionerValues['${id}_C4'] as double).toInt()}/5',
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: tealTextColor, fontSize: 13),
                                  )
                                ],
                              ),
                              Slider(
                                value: _kuesionerValues['${id}_C4'] as double,
                                min: 1, max: 5, divisions: 4,
                                activeColor: primaryColor,
                                inactiveColor: const Color(0xFFE2E8F0),
                                onChanged: (v) => setState(() => _kuesionerValues['${id}_C4'] = v),
                              ),
                              const SizedBox(height: 12),

                              _buildSubLabelKriteria('KETERSEDIAAN DATASET/OBJEK (C9)', tealTextColor),
                              const SizedBox(height: 10),
                              _buildSkalaLikertRow(
                                labelKiri: 'Sangat\nSulit',
                                labelKanan: 'Sangat\nMudah',
                                currentVal: _kuesionerValues['${id}_C9'] as int,
                                onSelected: (v) => setState(() => _kuesionerValues['${id}_C9'] = v),
                                activeColor: primaryColor,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 16),

                // BUTTON HITUNG
                ElevatedButton(
                  onPressed: _isSending ? null : _submitDataKeWaspas,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  child: _isSending
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Hitung Rekomendasi Topik', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubLabelKriteria(String title, Color textColor) {
    return Text(
      title,
      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textColor, fontFamily: 'monospace', letterSpacing: 0.5),
    );
  }

  Widget _buildGridTextBox(String title, TextEditingController ctrl, Color bgFieldColor, {bool isFullWidth = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title, 
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.black54, height: 1.2, fontFamily: 'monospace')
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: ctrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'monospace'),
          decoration: InputDecoration(
            hintText: '0.00',
            hintStyle: TextStyle(color: Colors.grey[500], fontSize: 13, fontFamily: 'monospace'),
            filled: true,
            fillColor: bgFieldColor,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
          ),
          validator: (v) {
            if (v == null || v.isEmpty) return 'Wajib';
            final n = double.tryParse(v);
            if (n == null || n < 0 || n > 100) return '0-100';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSkalaLikertRow({
    required String labelKiri,
    required String labelKanan,
    required int currentVal,
    required Function(int) onSelected,
    required Color activeColor,
  }) {
    return Row(
      children: [
        Text(labelKiri, textAlign: TextAlign.center, style: const TextStyle(fontSize: 9, color: Colors.black38, fontWeight: FontWeight.bold, height: 1.1)),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: const Color(0xFFCBD5E1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(5, (idx) {
                int val = idx + 1;
                bool isSelected = currentVal == val;
                return GestureDetector(
                  onTap: () => onSelected(val),
                  child: Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? activeColor : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$val',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black87),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(labelKanan, textAlign: TextAlign.center, style: const TextStyle(fontSize: 9, color: Colors.black38, fontWeight: FontWeight.bold, height: 1.1)),
      ],
    );
  }

  Widget _buildPengalamanTingkatRow({
    required int currentVal,
    required Function(int) onSelected,
    required Color activeColor,
  }) {
    final List<String> labels = ['Tidak\nPernah', 'Jarang', 'Pernah', 'Sering', 'Sangat\nBerpengalaman'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(5, (idx) {
        int val = idx + 1;
        bool isSelected = currentVal == val;
        return Expanded(
          child: GestureDetector(
            onTap: () => onSelected(val),
            child: Container(
              margin: EdgeInsets.only(
                left: idx == 0 ? 0 : 3,
                right: idx == 4 ? 0 : 3,
              ),
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? activeColor : Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: isSelected ? activeColor : const Color(0xFFCBD5E1)),
              ),
              child: Text(
                labels[idx],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 8, 
                  fontWeight: FontWeight.bold, 
                  color: isSelected ? Colors.white : Colors.black54,
                  height: 1.1,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}