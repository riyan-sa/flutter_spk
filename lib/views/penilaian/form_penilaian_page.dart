import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/spk_provider.dart';

class FormPenilaianPage extends StatefulWidget {
  const FormPenilaianPage({super.key});

  @override
  State<FormPenilaianPage> createState() => _FormPenilaianPageState();
}

class _FormPenilaianPageState extends State<FormPenilaianPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isSending = false;

  // Controller untuk menyimpan input teks 7 Mata Kuliah di Section C1
  final _rplController = TextEditingController();
  final _frameworkController = TextEditingController();
  final _basisDataController = TextEditingController();
  final _aiController = TextEditingController();
  final _spkController = TextEditingController();
  final _statistikaController = TextEditingController();
  final _mobileController = TextEditingController();

  // State nilai tampung untuk Section C2, C3, C4, dan C9
  int _valC2 = 3;
  int _valC3 = 3;
  double _valC4 = 3.0;
  int _valC9 = 3;

  void _submitDataKeWaspas() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSending = true);

      // Konversi nilai input 7 MK ke tipe data integer (jika kosong default 0)
      int rpl = int.tryParse(_rplController.text) ?? 0;
      int framework = int.tryParse(_frameworkController.text) ?? 0;
      int db = int.tryParse(_basisDataController.text) ?? 0;
      int ai = int.tryParse(_aiController.text) ?? 0;
      int spk = int.tryParse(_spkController.text) ?? 0;
      int stats = int.tryParse(_statistikaController.text) ?? 0;
      int mobile = int.tryParse(_mobileController.text) ?? 0;

      // Menghitung rata-rata nilai matematika untuk kriteria C1
      int nilaiRataRataC1 = ((rpl + framework + db + ai + spk + stats + mobile) / 7).round();

      // Format payload answers sesuai struktur QuestionnaireController Laravel Anda
      final List<Map<String, int>> payloadAnswers = [
        {'question_id': 1, 'answer_value': nilaiRataRataC1},
        {'question_id': 2, 'answer_value': _valC2},
        {'question_id': 3, 'answer_value': _valC3},
        {'question_id': 4, 'answer_value': _valC4.toInt()},
        {'question_id': 9, 'answer_value': _valC9},
      ];

      bool success = await Provider.of<SpkProvider>(context, listen: false).submitPenilaian(payloadAnswers);
      
      setState(() => _isSending = false);

      if (success && mounted) {
        Navigator.pushNamed(context, '/hasil-rekomendasi');
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memproses perhitungan ke server Laravel!'), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  @override
  void dispose() {
    _rplController.dispose();
    _frameworkController.dispose();
    _basisDataController.dispose();
    _aiController.dispose();
    _spkController.dispose();
    _statistikaController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0D5C4D); // Hijau Utama SKRIPSIAN
    const darkFieldColor = Color(0xFF1E293B); // Background Input Box
    const sectionTitleColor = Color(0xFF0F766E); // Warna teks Section judul

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.5),
          child: Container(color: const Color(0xFFE2E8F0), height: 1.5),
        ),
        title: Row(
          children: [
            const Icon(Icons.school_rounded, color: primaryColor, size: 24),
            const SizedBox(width: 8),
            Text(
              'SKRIPSIAN',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: darkFieldColor.withValues(alpha: 0.9)),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ==========================================
                // BANNER ATAS: STUDENT RECOMMENDATION GAYA GRADASI
                // ==========================================
                Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFE0F2FE), Color(0xFFF8FAFC), Color(0xFFCFFAFE)],
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Student\nRecommendation',
                              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: primaryColor, height: 1.1),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Calculate your final project topic based on your academic performance and interests.',
                              style: TextStyle(fontSize: 12, color: Colors.grey[600], height: 1.4),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: Icon(Icons.bar_chart_rounded, size: 80, color: primaryColor.withValues(alpha: 0.3)),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // ==========================================
                // SECTION C1: NILAI MATA KULIAH RELEVAN
                // ==========================================
                _buildSectionHeader(Icons.star_border_rounded, 'SECTION C1: NILAI MATA KULIAH RELEVAN', sectionTitleColor),
                const SizedBox(height: 16),
                _buildTextBoxKriteria('RPL', _rplController, darkFieldColor),
                _buildTextBoxKriteria('Framework Programming', _frameworkController, darkFieldColor),
                _buildTextBoxKriteria('Sistem Basis Data', _basisDataController, darkFieldColor),
                _buildTextBoxKriteria('Kecerdasan Buatan', _aiController, darkFieldColor),
                _buildTextBoxKriteria('SPK', _spkController, darkFieldColor),
                _buildTextBoxKriteria('Statistika Komputer', _statistikaController, darkFieldColor),
                _buildTextBoxKriteria('Mobile Programming', _mobileController, darkFieldColor),
                const SizedBox(height: 24),

                // ==========================================
                // SECTION C2: MINAT MAHASISWA
                // ==========================================
                _buildSectionHeader(Icons.favorite_border_rounded, 'SECTION C2: MINAT MAHASISWA', sectionTitleColor),
                const SizedBox(height: 12),
                _buildWadahPillKuesioner(
                  'Seberapa besar minat Anda pada penelitian akademis?',
                  _valC2,
                  (v) => setState(() => _valC2 = v),
                  primaryColor,
                ),
                const SizedBox(height: 32),

                // ==========================================
                // SECTION C3: PENGALAMAN
                // ==========================================
                _buildSectionHeader(Icons.shopping_bag_outlined, 'SECTION C3: PENGALAMAN', sectionTitleColor),
                const SizedBox(height: 12),
                _buildWadahPillKuesioner(
                  'Seberapa besar tingkat pengalaman proyek praktis atau magang Anda?',
                  _valC3,
                  (v) => setState(() => _valC3 = v),
                  primaryColor,
                ),
                const SizedBox(height: 32),

                // ==========================================
                // SECTION C4: PENGUASAAN TEKNOLOGI (SLIDER STYLE)
                // ==========================================
                _buildSectionHeader(Icons.phonelink_setup_rounded, 'SECTION C4: PENGUASAAN TEKNOLOGI', sectionTitleColor),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Beginner', style: TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w600)),
                          Text('Expert', style: TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      Slider(
                        value: _valC4,
                        min: 1,
                        max: 5,
                        divisions: 4,
                        activeColor: primaryColor,
                        inactiveColor: const Color(0xFFE2E8F0),
                        label: _valC4.toInt().toString(),
                        onChanged: (double value) {
                          setState(() {
                            _valC4 = value;
                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(5, (i) => Text('${i + 1}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // ==========================================
                // SECTION C9: KETERSEDIAAN DATASET (BOX CARD STYLE)
                // ==========================================
                _buildSectionHeader(Icons.storage_rounded, 'SECTION C9: KETERSEDIAAN DATASET', sectionTitleColor),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(5, (index) {
                    int boxVal = index + 1;
                    bool isBoxSelected = _valC9 == boxVal;
                    return GestureDetector(
                      onTap: () => setState(() => _valC9 = boxVal),
                      child: Container(
                        width: 54,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: isBoxSelected ? Colors.white : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isBoxSelected ? primaryColor : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '$boxVal',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isBoxSelected ? primaryColor : Colors.black87),
                            ),
                            if (boxVal == 1 || boxVal == 5) const SizedBox(height: 6),
                            if (boxVal == 1)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                decoration: BoxDecoration(color: const Color(0xFF475569), borderRadius: BorderRadius.circular(4)),
                                child: const Text('HARD', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                              ),
                            if (boxVal == 5)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(4)),
                                child: const Text('EASY', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 40),

                // ==========================================
                // TOMBOL SUBMIT: HITUNG REKOMENDASI TOPIK
                // ==========================================
                ElevatedButton.icon(
                  onPressed: _isSending ? null : _submitDataKeWaspas,
                  icon: const Icon(Icons.calculate_outlined, size: 18),
                  label: const Text(
                    'Hitung Rekomendasi Topik',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Note: Data processed using our proprietary weighted algorithm.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[500], fontSize: 11, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 48),

                // Footer Hak Cipta bawah kuesioner
                const Text('SKRIPSIAN', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black26, fontSize: 13)),
                const SizedBox(height: 4),
                Text('© 2024 SKRIPSIAN. All rights reserved.\nPrivacy Policy    Terms of Service    Help Center', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[400], fontSize: 11, height: 1.5)),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Komponen Header Section
  Widget _buildSectionHeader(IconData icon, String title, Color titleColor) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: titleColor, size: 18),
            const SizedBox(width: 8),
            Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: titleColor, letterSpacing: 0.3)),
          ],
        ),
        const SizedBox(height: 6),
        const Divider(color: Colors.black12, thickness: 1),
      ],
    );
  }

  // Komponen Input Box Gelap Section C1 (Placeholder: 0-100)
  Widget _buildTextBoxKriteria(String title, TextEditingController ctrl, Color bgFieldColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87)),
          const SizedBox(height: 6),
          TextFormField(
            controller: ctrl,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: '0-100',
              hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
              filled: true,
              fillColor: bgFieldColor,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Nilai $title wajib diisi';
              final n = int.tryParse(v);
              if (n == null || n < 0 || n > 100) return 'Masukkan angka berkisar 0-100';
              return null;
            },
          ),
        ],
      ),
    );
  }

  // Komponen Wadah Pill Putih Lonjong Lonjong Horizontal Section C2 & C3
  Widget _buildWadahPillKuesioner(String quest, int groupVal, Function(int) onSelected, Color themeColor) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(quest, style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.4)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30), border: Border.all(color: const Color(0xFFE2E8F0))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(5, (idx) {
                int score = idx + 1;
                bool active = groupVal == score;
                return GestureDetector(
                  onTap: () => onSelected(score),
                  child: Container(
                    width: 38,
                    height: 38,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: active ? themeColor : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$score',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: active ? Colors.white : Colors.black87),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('MINAT RENDAH', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black38)),
              Text('MINAT TINGGI', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black38)),
            ],
          )
        ],
      ),
    );
  }
}