import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../models/rekomendasi_model.dart';
import '../models/riwayat_model.dart';
import 'api_client.dart';

class SpkProvider with ChangeNotifier {
  List<RiwayatModel> _riwayat = [];

  RekomendasiModel? _hasilTerbaru;

  List<RiwayatModel> get riwayat => _riwayat;

  RekomendasiModel? get hasilTerbaru => _hasilTerbaru;

  bool _loading = false;

  bool get loading => _loading;

  Future<bool> submitPenilaian(List<Map<String, int>> answers) async {
    _loading = true;
    notifyListeners();

    try {
      final response = await ApiClient.dio.post(
        '/questionnaire',
        data: {
          'answers': answers,
        },
      );

      if (response.statusCode == 200) {
        _hasilTerbaru = RekomendasiModel.fromJson(
          response.data['recommendation'],
        );

        _loading = false;
        notifyListeners();

        return true;
      }

      _loading = false;
      notifyListeners();

      return false;
    } on DioException catch (e) {
      debugPrint(e.toString());

      _loading = false;
      notifyListeners();

      return false;
    }
  }

  Future<void> fetchRiwayat() async {
    try {
      final response = await ApiClient.dio.get(
        '/recommendation/history',
      );

      if (response.statusCode == 200) {
        _riwayat = (response.data['data'] as List)
            .map((e) => RiwayatModel.fromJson(e))
            .toList();

        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}