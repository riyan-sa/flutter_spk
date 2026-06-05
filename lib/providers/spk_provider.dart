import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'api_client.dart';
import '../models/riwayat_model.dart';
import '../models/rekomendasi_model.dart';

class SpkProvider with ChangeNotifier {
  List<RiwayatModel> _riwayat = [];
  List<RekomendasiModel> _hasilTerbaru = [];

  List<RiwayatModel> get riwayat => _riwayat;
  List<RekomendasiModel> get hasilTerbaru => _hasilTerbaru;

  // ➔ UBAH PARAMETER MENJADI DYNAMIC AGAR BISA MENERIMA KODE ALFA-NUMERIK 'A1'
  Future<bool> submitPenilaian(List<Map<String, dynamic>> answers) async {
    try {
      final response = await ApiClient.dio.post(
        '/questionnaire',
        data: {'answers': answers},
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        // Tambahkan fallback [] agar tidak error jika 'recommendation' ternyata null dari API
        final List<dynamic> dataJson = response.data['recommendation'] ?? [];
        _hasilTerbaru = dataJson
            .map((json) => RekomendasiModel.fromJson(json))
            .toList();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      // GANTI DARI "on DioException catch" MENJADI "catch (e)"
      // Biar semua error ketangkep dan gak bikin loading abadi
      debugPrint('Submit Penilaian Error (Jaringan/Parsing): $e');
      return false;
    }
  }

  // Mengambil daftar histori perhitungan WASPAS dari database Laravel
  Future<void> fetchRiwayat() async {
    try {
      final response = await ApiClient.dio.get('/recommendation/history');
      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> dataJson = response.data['data'];
        _riwayat = dataJson.map((json) => RiwayatModel.fromJson(json)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Fetch Riwayat Error: $e');
    }
  }
}
