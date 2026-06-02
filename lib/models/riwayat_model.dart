class RiwayatModel {
  final String namaAlternatif;
  final double nilaiAkhir;
  final String tanggal;

  // Constructor menggunakan data bertipe data kuat (Type-safe)
  RiwayatModel({
    required this.namaAlternatif,
    required this.nilaiAkhir,
    required this.tanggal,
  });
} 