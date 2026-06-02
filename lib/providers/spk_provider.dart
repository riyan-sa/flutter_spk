import 'package:flutter/material.dart';
import '../models/riwayat_model.dart';
import '../models/rekomendasi_model.dart';

class SpkProvider with ChangeNotifier {
  // 1. Mock Data untuk Riwayat Tes di Dashboard (Persis isi tabel figma)
  final List<RiwayatModel> _riwayat = [
    RiwayatModel(namaAlternatif: 'Sistem Pakar', nilaiAkhir: 0.895, tanggal: '2023-10-12'),
    RiwayatModel(namaAlternatif: 'Machine Learning', nilaiAkhir: 0.812, tanggal: '2023-09-05'),
  ];

  // 2. Mock Data untuk Hasil Perhitungan (Persis daftar peringkat figma)
  final List<RekomendasiModel> _hasilTerbaru = [
    RekomendasiModel(alternatifId: 1, namaAlternatif: 'Artificial Intelligence & Intelligent System', nilaiAkhir: 0.942, ranking: 1),
    RekomendasiModel(alternatifId: 2, namaAlternatif: 'Cyber Security & Digital Forensics', nilaiAkhir: 0.885, ranking: 2),
    RekomendasiModel(alternatifId: 3, namaAlternatif: 'Cloud Computing & Virtualization', nilaiAkhir: 0.812, ranking: 3),
    RekomendasiModel(alternatifId: 5, namaAlternatif: 'Software Engineering & Agile Method', nilaiAkhir: 0.795, ranking: 4),
    RekomendasiModel(alternatifId: 1, namaAlternatif: 'Data Science & Big Data Analytics', nilaiAkhir: 0.723, ranking: 5),
    RekomendasiModel(alternatifId: 6, namaAlternatif: 'Internet of Things (IoT) Systems', nilaiAkhir: 0.694, ranking: 6),
    RekomendasiModel(alternatifId: 4, namaAlternatif: 'Mobile Application Development', nilaiAkhir: 0.612, ranking: 7),
  ];

  List<RiwayatModel> get riwayat => _riwayat;
  List<RekomendasiModel> get hasilTerbaru => _hasilTerbaru;

  Future<bool> submitPenilaian(List<Map<String, int>> answers) async {
    await Future.delayed(const Duration(seconds: 1)); // Efek loading memproses matriks
    notifyListeners();
    return true;
  }
}