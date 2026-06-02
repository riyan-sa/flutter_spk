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
}