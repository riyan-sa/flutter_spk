class RekomendasiModel {
  final int alternatifId;
  final String namaAlternatif;
  final double nilaiAkhir;
  final int ranking;

  RekomendasiModel({
    required this.alternatifId,
    required this.namaAlternatif,
    required this.nilaiAkhir,
    required this.ranking,
  });

  factory RekomendasiModel.fromJson(Map<String, dynamic> json) {
    return RekomendasiModel(
      alternatifId: json['alternatif_id'] ?? json['id'] ?? 0,
      namaAlternatif: json['alternative']?['nama_alternatif'] ?? json['nama_alternatif'] ?? 'Topik Riset',
      nilaiAkhir: json['nilai_akhir'] != null ? double.parse(json['nilai_akhir'].toString()) : 0.0,
      ranking: json['ranking'] ?? 0,
    );
  }
}