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
      namaAlternatif: json['alternative']?['nama_alternatif'] ?? 'Topik Tidak Diketahui',
      nilaiAkhir: json['nilai_akhir'] != null ? double.parse(json['nilai_akhir'].toString()) : 0.0,
      tanggal: json['created_at'] ?? '',
    );
  }
}