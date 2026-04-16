import 'package:flutter/material.dart';

class AlurKpPage extends StatelessWidget {
  const AlurKpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> alurKP = [
      {
        'nomor': '1',
        'judul': 'Pengajuan Kerja Praktek',
        'deskripsi':
            'Mahasiswa mengajukan permohonan Kerja Praktek melalui aplikasi SiKP dengan melengkapi data diri, data partner, dan data instansi tujuan.',
        'icon': Icons.assignment_add,
        'color': const Color(0xFF337418),
        'bgColor': const Color(0xFFF0FDF4),
        'subItems': [
          'Formulir Permohonan Kerja Praktek',
          'Formulir Permohonan Dosen Pembimbing',
          'Surat Tugas Kerja Praktek',
        ],
      },
      {
        'nomor': '2',
        'judul': 'Pembuatan Surat Tugas',
        'deskripsi':
            'Formulir ditandatangani oleh Koordinator Kerja Praktek, kemudian dibawa ke Tata Usaha Fakultas untuk diterbitkan.',
        'icon': Icons.edit_document,
        'color': const Color(0xFF1B4D0C),
        'bgColor': const Color(0xFFE8F5E9),
        'subItems': [],
      },
      {
        'nomor': '3',
        'judul': 'Distribusi Berkas',
        'deskripsi':
            'Mahasiswa menggandakan berkas menjadi 3 rangkap untuk didistribusikan kepada pihak yang berkepentingan.',
        'icon': Icons.file_copy_outlined,
        'color': const Color(0xFFFFD700),
        'bgColor': const Color(0xFFFFF8E1),
        'subItems': [
          '1 rangkap untuk Koordinator KP',
          '1 rangkap untuk TU Prodi',
          '1 rangkap untuk Mahasiswa',
        ],
      },
      {
        'nomor': '4',
        'judul': 'Pengajuan ke Instansi',
        'deskripsi':
            'Mahasiswa mengajukan permohonan Kerja Praktek ke instansi tujuan dengan membawa surat tugas dari fakultas.',
        'icon': Icons.business_center_outlined,
        'color': const Color(0xFF337418),
        'bgColor': const Color(0xFFF0FDF4),
        'subItems': [],
      },
      {
        'nomor': '5',
        'judul': 'Pelaksanaan Kerja Praktek',
        'deskripsi':
            'Mahasiswa melaksanakan Kerja Praktek di instansi tujuan dan menyusun laporan. Penilaian dilakukan oleh dosen pembimbing dan pihak instansi.',
        'icon': Icons.work_outline_rounded,
        'color': const Color(0xFF1B4D0C),
        'bgColor': const Color(0xFFE8F5E9),
        'subItems': [
          'Mahasiswa melakukan Kerja Praktek',
          'Menyusun Laporan Kerja Praktek',
          'Dinilai oleh Dosen Pembimbing KP',
          'Dinilai oleh Pihak Instansi',
        ],
      },
      {
        'nomor': '6',
        'judul': 'Pengumpulan Laporan',
        'deskripsi':
            'Mahasiswa menyerahkan laporan akhir Kerja Praktek kepada pihak yang berwenang setelah pelaksanaan selesai.',
        'icon': Icons.upload_file_rounded,
        'color': const Color(0xFFFFD700),
        'bgColor': const Color(0xFFFFF8E1),
        'subItems': [
          'Menyerahkan laporan fisik ke TU Prodi',
          'Mengisi Form Pengumpulan Laporan secara online',
        ],
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF1F8EE),
      body: Stack(
        children: [
          // Background blobs
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF337418).withOpacity(0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFFD700).withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Column(
            children: [
              // ── Header ──
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF337418), Color(0xFF1B4D0C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(36),
                    bottomRight: Radius.circular(36),
                  ),
                ),
                padding: const EdgeInsets.only(
                  top: 64,
                  bottom: 40,
                  left: 24,
                  right: 24,
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.route_rounded,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Prosedur Kerja Praktek',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Ikuti langkah-langkah berikut untuk\nmelaksanakan Kerja Praktek',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Colors.white70),
                    ),
                  ],
                ),
              ),

              // ── List Alur ──
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: alurKP.length,
                  itemBuilder: (context, index) {
                    final item = alurKP[index];
                    final bool isLast = index == alurKP.length - 1;

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Garis & Nomor ──
                        Column(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: item['color'],
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: (item['color'] as Color).withOpacity(
                                      0.3,
                                    ),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  item['nomor'],
                                  style: TextStyle(
                                    color:
                                        item['color'] == const Color(0xFFFFD700)
                                            ? const Color(0xFF337418)
                                            : Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            if (!isLast)
                              Container(
                                width: 2,
                                height: _getLineHeight(item),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      item['color'] as Color,
                                      (item['color'] as Color).withOpacity(0.2),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(width: 16),

                        // ── Konten ──
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.85),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: (item['color'] as Color).withOpacity(
                                    0.2,
                                  ),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Judul + Icon
                                  Row(
                                    children: [
                                      Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: item['bgColor'],
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Icon(
                                          item['icon'],
                                          color: item['color'],
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          item['judul'],
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: item['color'],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),

                                  // Deskripsi
                                  Text(
                                    item['deskripsi'],
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                      height: 1.5,
                                    ),
                                  ),

                                  // Sub Items
                                  if ((item['subItems'] as List)
                                      .isNotEmpty) ...[
                                    const SizedBox(height: 10),
                                    ...(item['subItems'] as List<String>).map(
                                      (sub) => Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 4,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 6,
                                              height: 6,
                                              margin: const EdgeInsets.only(
                                                top: 5,
                                                right: 8,
                                              ),
                                              decoration: BoxDecoration(
                                                color: item['color'],
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                sub,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: (item['color']
                                                          as Color)
                                                      .withOpacity(0.8),
                                                  height: 1.4,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double _getLineHeight(Map<String, dynamic> item) {
    final int subCount = (item['subItems'] as List).length;
    if (subCount == 0) return 100;
    if (subCount <= 2) return 130;
    if (subCount <= 3) return 155;
    return 175;
  }
}
