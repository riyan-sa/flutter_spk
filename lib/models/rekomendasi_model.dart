class RekomendasiModel {
  final String judul;
  final double skor;
  final String kategori;

  RekomendasiModel({
    required this.judul,
    required this.skor,
    required this.kategori,
  });

  factory RekomendasiModel.fromJson(Map<String, dynamic> json) {
    return RekomendasiModel(
      judul: json['judul'],
      skor: double.parse(json['skor'].toString()),
      kategori: json['kategori'],
    );
  }
}