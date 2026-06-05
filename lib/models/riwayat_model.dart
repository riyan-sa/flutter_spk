class RiwayatModel {
  final String namaAlternatif;
  final double nilaiAkhir;
  final String tanggal;

  RiwayatModel({
    required this.namaAlternatif,
    required this.nilaiAkhir,
    required this.tanggal,
  });

  factory RiwayatModel.fromJson(Map<String, dynamic> json) {
    return RiwayatModel(
      namaAlternatif:
          json['top_alternative']?['nama_topik'] ?? 'Topik Tidak Diketahui',
      nilaiAkhir: json['top_score'] != null
          ? double.parse(json['top_score'].toString())
          : 0.0,
      tanggal: json['created_at'] ?? '',
    );
  }
}
