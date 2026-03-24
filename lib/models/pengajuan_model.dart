class Pengajuan {
  final int? id;
  final String npm;
  final String semester;
  final String tujuanInstansi;
  final String status;
  final String? judulLaporan;
  final String? namaPembimbing;

  Pengajuan({
    this.id,
    required this.npm,
    required this.semester,
    required this.tujuanInstansi,
    required this.status,
    this.judulLaporan,
    this.namaPembimbing,
  });

  factory Pengajuan.fromJson(Map<String, dynamic> json) {
    return Pengajuan(
      id: json['id'],
      npm: json['npm'],
      semester: json['semester'].toString(),
      tujuanInstansi: json['tujuan_instansi'],
      status: json['status'],
      judulLaporan: json['judul_laporan'],
      namaPembimbing: json['dosen'] != null ? json['dosen']['name'] : 'Belum ditentukan',
    );
  }
}