class RiwayatModel {
  final int id;
  final String judul;
  final String tanggal;

  RiwayatModel({
    required this.id,
    required this.judul,
    required this.tanggal,
  });

  factory RiwayatModel.fromJson(Map<String, dynamic> json) {
    return RiwayatModel(
      id: json['id'],
      judul: json['judul'],
      tanggal: json['created_at'],
    );
  }
}