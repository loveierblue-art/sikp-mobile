import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'services/api_service.dart';

class DownloadSuratPage extends StatefulWidget {
  const DownloadSuratPage({super.key});

  @override
  State<DownloadSuratPage> createState() => _DownloadSuratPageState();
}

class _DownloadSuratPageState extends State<DownloadSuratPage> {
  Map<String, dynamic>? _pengajuanKP;
  bool _isLoading = true;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final result = await _apiService.getPengajuanKP();
    if (mounted) {
      setState(() {
        _pengajuanKP = result['data'];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ApiService.currentUser;
    final String nama = user?['name'] ?? '-';
    final String npm = user?['id_user'] ?? '-';
    final String noTelp = _pengajuanKP?['noTelp'] ?? '-';
    final String namaPartner = _pengajuanKP?['namaPartner'] ?? '-';
    final String npmPartner = _pengajuanKP?['npmPartner'] ?? '-';
    final String noTelpPartner = _pengajuanKP?['noTelpPartner'] ?? '-';
    final String instansi = _pengajuanKP?['instansi'] ?? '-';
    final String alamatInstansi = _pengajuanKP?['alamatInstansi'] ?? '-';
    final String dosenPembimbing = _pengajuanKP?['dosenPembimbing'] ?? '-';
    final String status = _pengajuanKP?['status'] ?? 'Belum Diajukan';

    // tanggal hari ini untuk kop surat
    final now = DateTime.now();
    final List<String> bulan = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    final String tanggal = '${now.day} ${bulan[now.month]} ${now.year}';

    // tanggal dari Firebase
    final String tanggalMulai = _pengajuanKP?['tanggalMulai'] ?? '-';
    final String tanggalSelesai = _pengajuanKP?['tanggalSelesai'] ?? '-';

    final bool sudahDisetujui = status.toLowerCase() == 'disetujui';

    final List<Map<String, dynamic>> daftarSurat = [
      {
        'judul': 'Formulir Permohonan\nKerja Praktek',
        'icon': Icons.assignment_outlined,
        'color': const Color(0xFF337418),
        'bgColor': const Color(0xFFE8F5E9),
        'keterangan': 'Formulir pengajuan KP ke instansi',
        'onPreview':
            sudahDisetujui
                ? () => _previewSurat(
                  context,
                  judul: 'FORMULIR PERMOHONAN KERJA PRAKTEK',
                  buildContent:
                      (pw.Context ctx, Uint8List logoBytes) => _buildSurat1(
                        ctx,
                        logoBytes,
                        nama: nama,
                        npm: npm,
                        noTelp: noTelp,
                        namaPartner: namaPartner,
                        npmPartner: npmPartner,
                        noTelpPartner: noTelpPartner,
                        instansi: instansi,
                        alamat: alamatInstansi,
                        tanggal: tanggal,
                      ),
                )
                : null,
      },
      {
        'judul': 'Formulir Permohonan\nDosen Pembimbing KP',
        'icon': Icons.person_search_outlined,
        'color': const Color(0xFF0F6E56),
        'bgColor': const Color(0xFFE1F5EE),
        'keterangan': 'Formulir permintaan dosen pembimbing',
        'onPreview':
            sudahDisetujui
                ? () => _previewSurat(
                  context,
                  judul: 'FORMULIR PERMOHONAN DOSEN PEMBIMBING KP',
                  buildContent:
                      (pw.Context ctx, Uint8List logoBytes) => _buildSurat2(
                        ctx,
                        logoBytes,
                        nama: nama,
                        npm: npm,
                        noTelp: noTelp,
                        namaPartner: namaPartner,
                        npmPartner: npmPartner,
                        noTelpPartner: noTelpPartner,
                        instansi: instansi,
                        alamat: alamatInstansi,
                        dosenPembimbing: dosenPembimbing,
                        nipDosen: '-',
                        tanggal: tanggal,
                      ),
                )
                : null,
      },
      {
        'judul': 'Surat Tugas\nKerja Praktek',
        'icon': Icons.task_outlined,
        'color': const Color(0xFF854F0B),
        'bgColor': const Color(0xFFFAEEDA),
        'keterangan': 'Surat tugas resmi dari koordinator KP',
        'onPreview':
            sudahDisetujui
                ? () => _previewSurat(
                  context,
                  judul: 'SURAT TUGAS KERJA PRAKTEK',
                  buildContent:
                      (pw.Context ctx, Uint8List logoBytes) => _buildSurat3(
                        ctx,
                        logoBytes,
                        nama: nama,
                        npm: npm,
                        noTelp: noTelp,
                        namaPartner: namaPartner,
                        npmPartner: npmPartner,
                        noTelpPartner: noTelpPartner,
                        instansi: instansi,
                        alamat: alamatInstansi,
                        tanggal: tanggal,
                        tanggalMulai: tanggalMulai,
                        tanggalSelesai: tanggalSelesai,
                      ),
                )
                : null,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      body: Stack(
        children: [
          // ── Efek Blob ──
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [const Color(0xFF337418).withOpacity(0.15), const Color(0xFF337418).withOpacity(0)],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 120,
            left: -60,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [const Color(0xFFFFD700).withOpacity(0.12), const Color(0xFFFFD700).withOpacity(0)],
                ),
              ),
            ),
          ),

          SingleChildScrollView(
            child: Column(
              children: [
                // Header
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF337418), Color(0xFF458C26)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(36),
                      bottomRight: Radius.circular(36),
                    ),
                  ),
                  padding: const EdgeInsets.only(top: 64, bottom: 40, left: 24, right: 24),
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
                            child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
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
                        child: const Icon(Icons.download_rounded, size: 32, color: Colors.white),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Download Surat',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Tap surat untuk preview sebelum download',
                        style: TextStyle(fontSize: 13, color: Colors.white70),
                      ),
                    ],
                  ),
                ),

                _isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(color: Color(0xFF337418)),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!sudahDisetujui)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                margin: const EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFEBEB),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFD32F2F).withOpacity(0.3), width: 1),
                                ),
                                child: Row(
                                  children: const [
                                    Icon(Icons.lock_outline_rounded, color: Color(0xFFD32F2F), size: 20),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'Surat belum tersedia. Pengajuan KP Anda belum disetujui oleh Koordinator KP.',
                                        style: TextStyle(fontSize: 12, color: Color(0xFFD32F2F), height: 1.5),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            const Text(
                              'Surat Tersedia',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF337418)),
                            ),
                            const SizedBox(height: 12),
                            ...daftarSurat.map(
                              (surat) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: GestureDetector(
                                  onTap: surat['onPreview'],
                                  child: Opacity(
                                    opacity: sudahDisetujui ? 1.0 : 0.5,
                                    child: Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.8), 
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: const Color(0xFF337418).withOpacity(0.1), width: 1),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 52,
                                            height: 52,
                                            decoration: BoxDecoration(
                                              color: surat['bgColor'],
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Icon(surat['icon'], color: surat['color'], size: 26),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  surat['judul'],
                                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF337418), height: 1.3),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(surat['keterangan'], style: const TextStyle(fontSize: 12, color: Colors.black45)),
                                              ],
                                            ),
                                          ),
                                          Icon(
                                            sudahDisetujui ? Icons.arrow_forward_ios_rounded : Icons.lock_outline_rounded,
                                            color: const Color(0xFFFFD700), // Badge/Ikon ke Kuning Gold
                                            size: 16,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Catatan
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFAEEDA),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFF9A825).withOpacity(0.3), width: 1),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Icon(Icons.info_outline_rounded, color: Color(0xFF854F0B), size: 20),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Surat hanya tersedia setelah pengajuan KP disetujui oleh Koordinator Kerja Praktek.',
                                      style: TextStyle(fontSize: 12, color: Color(0xFF854F0B), height: 1.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _previewSurat(
    BuildContext context, {
    required String judul,
    required pw.Widget Function(pw.Context, Uint8List) buildContent,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                _PreviewSuratPage(judul: judul, buildContent: buildContent),
      ),
    );
  }

  pw.Widget _buildSurat1(
    pw.Context ctx,
    Uint8List logoBytes, {
    required String nama,
    required String npm,
    required String noTelp,
    required String namaPartner,
    required String npmPartner,
    required String noTelpPartner,
    required String instansi,
    required String alamat,
    required String tanggal,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _kopSurat(logoBytes),
        pw.SizedBox(height: 16),
        pw.Center(
          child: pw.Text(
            'FORMULIR PERMOHONAN KERJA PRAKTEK',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
          ),
        ),
        pw.SizedBox(height: 12),
        pw.Text(
          'Untuk memenuhi ketentuan kurikulum di Fakultas Teknik Universitas Khairun untuk mata kuliah Kerja Praktek (KP), maka bersama ini kami mengajukan permohonan Kerja Praktek :',
          style: const pw.TextStyle(fontSize: 10),
        ),
        pw.SizedBox(height: 12),
        pw.Text(
          'A.  Identitas Mahasiswa',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
        ),
        pw.SizedBox(height: 6),
        _tabelMahasiswa(
          nama,
          npm,
          noTelp,
          namaPartner,
          npmPartner,
          noTelpPartner,
        ),
        pw.SizedBox(height: 12),
        pw.Text(
          'B.  Tempat Kerja Praktek',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
        ),
        pw.SizedBox(height: 4),
        _itemList('1.  Nama Instansi/Perusahaan   :  $instansi'),
        _itemList('2.  Alamat                                    :  $alamat'),
        _itemList('3.  Ditujukan Kepada              :  Kepala Tata Usaha'),
        pw.SizedBox(height: 12),
        pw.Text(
          'C.  Bidang Kerja Praktek (KP) yang diminati :',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
        ),
        pw.SizedBox(height: 4),
        _itemList('1.  Penyusunan Data Mahasiswa'),
        _itemList('2.  Mengelola Kearsipan'),
        _itemList('3.  Melakukan Penyimpanan Dokumen'),
        pw.SizedBox(height: 12),
        pw.Text(
          'Demikianlah permohonan ini perhatian dan bantuannya kami ucapkan terima kasih.',
          style: const pw.TextStyle(fontSize: 10),
        ),
        pw.SizedBox(height: 24),
        _ttdBagian(tanggal, nama, namaPartner),
      ],
    );
  }

  pw.Widget _buildSurat2(
    pw.Context ctx,
    Uint8List logoBytes, {
    required String nama,
    required String npm,
    required String noTelp,
    required String namaPartner,
    required String npmPartner,
    required String noTelpPartner,
    required String instansi,
    required String alamat,
    required String dosenPembimbing,
    required String nipDosen,
    required String tanggal,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _kopSurat(logoBytes),
        pw.SizedBox(height: 16),
        pw.Center(
          child: pw.Column(
            children: [
              pw.Text(
                'FORMULIR PERMOHONAN',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              pw.Text(
                'DOSEN PEMBIMBING KERJA PRAKTEK',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 12),
        pw.Text(
          'Kami mahasiswa pelaksana kerja praktek :',
          style: const pw.TextStyle(fontSize: 10),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          'A.  Identitas Mahasiswa',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
        ),
        pw.SizedBox(height: 6),
        _tabelMahasiswaFB(
          nama,
          npm,
          noTelp,
          namaPartner,
          npmPartner,
          noTelpPartner,
        ),
        pw.SizedBox(height: 12),
        pw.Text(
          'B.  Tempat Kerja Praktek',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
        ),
        pw.SizedBox(height: 4),
        _itemList('1.  Nama Instansi/Perusahaan   :  $instansi'),
        _itemList('2.  Alamat                                    :  $alamat'),
        pw.SizedBox(height: 12),
        pw.Text(
          'Memohon untuk menunjuk Bapak/Ibu Dosen,',
          style: const pw.TextStyle(fontSize: 10),
        ),
        pw.SizedBox(height: 8),
        pw.Row(
          children: [
            pw.SizedBox(
              width: 120,
              child: pw.Text('  Nama', style: const pw.TextStyle(fontSize: 10)),
            ),
            pw.Text(
              ':  $dosenPembimbing',
              style: const pw.TextStyle(fontSize: 10),
            ),
          ],
        ),
        pw.SizedBox(height: 4),
        pw.Row(
          children: [
            pw.SizedBox(
              width: 120,
              child: pw.Text(
                '  NIP/NIDN',
                style: const pw.TextStyle(fontSize: 10),
              ),
            ),
            pw.Text(':  $nipDosen', style: const pw.TextStyle(fontSize: 10)),
          ],
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          'Sebagai dosen pembimbing kerja praktek kami.',
          style: const pw.TextStyle(fontSize: 10),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          'Demikianlah permohonan ini, atas perhatian dan bantuannya kami ucapkan terima kasih.',
          style: const pw.TextStyle(fontSize: 10),
        ),
        pw.SizedBox(height: 24),
        _ttdBagian(tanggal, nama, namaPartner),
      ],
    );
  }

  pw.Widget _buildSurat3(
    pw.Context ctx,
    Uint8List logoBytes, {
    required String nama,
    required String npm,
    required String noTelp,
    required String namaPartner,
    required String npmPartner,
    required String noTelpPartner,
    required String instansi,
    required String alamat,
    required String tanggal,
    required String tanggalMulai,
    required String tanggalSelesai,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _kopSurat(logoBytes),
        pw.SizedBox(height: 16),
        pw.Center(
          child: pw.Column(
            children: [
              pw.Text(
                'SURAT TUGAS',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              pw.Text(
                'KERJA PRAKTEK',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 12),
        pw.Text(
          'Koordinator kerja praktek Program Studi Teknik Komputer, Fakultas Teknik Universitas Khairun, dengan ini memberi tugas kepada mahasiswa di bawah ini:',
          style: const pw.TextStyle(fontSize: 10),
        ),
        pw.SizedBox(height: 10),
        pw.Text(
          'A.  Identitas Mahasiswa',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
        ),
        pw.SizedBox(height: 6),
        _tabelMahasiswa(
          nama,
          npm,
          noTelp,
          namaPartner,
          npmPartner,
          noTelpPartner,
        ),
        pw.SizedBox(height: 12),
        pw.Text(
          'B.  Tempat Kerja Praktek',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
        ),
        pw.SizedBox(height: 4),
        _itemList('1.  Nama Instansi/Perusahaan   :  $instansi'),
        _itemList('2.  Alamat                                    :  $alamat'),
        pw.SizedBox(height: 12),
        pw.Text(
          'Sesuai dengan surat persetujuan Pimpinan/Ketua/Kepala/Direksi (foto copy terlampir), maka kerja praktek ini hendaknya dimulai tanggal $tanggalMulai s.d. tanggal $tanggalSelesai dengan perincian sebagaimana diatur dalam surat persetujuan tersebut.',
          style: const pw.TextStyle(fontSize: 10),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          'Demikianlah surat tugas ini dibuat, atas perhatian dan bantuannya kami ucapkan terima kasih.',
          style: const pw.TextStyle(fontSize: 10),
        ),
        pw.SizedBox(height: 24),
        _ttdKoord(tanggal),
      ],
    );
  }

  pw.Widget _kopSurat(Uint8List logoBytes) {
    return pw.Column(
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.SizedBox(
              width: 60,
              height: 60,
              child: pw.Image(pw.MemoryImage(logoBytes)),
            ),
            pw.SizedBox(width: 8),
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(
                    'KEMENTERIAN PENDIDIKAN, KEBUDAYAAN, RISET DAN TEKNOLOGI',
                    style: pw.TextStyle(
                      fontSize: 8,
                      fontWeight: pw.FontWeight.bold,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.Text(
                    'UNIVERSITAS KHAIRUN',
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.Text(
                    'FAKULTAS TEKNIK PROGRAM STUDI TEKNIK INFORMATIKA',
                    style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.Text(
                    'Kampus III Universitas Khairun, Kelurahan Jati Kota Ternate Selatan',
                    style: const pw.TextStyle(fontSize: 8),
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.Text(
                    'http://if.unkhair.ac.id  http://unkhair.ac.id  Group FB: if.unkhair',
                    style: const pw.TextStyle(fontSize: 8),
                    textAlign: pw.TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
        pw.Divider(thickness: 2),
      ],
    );
  }

  pw.Widget _itemList(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(left: 16, bottom: 2),
      child: pw.Text(text, style: const pw.TextStyle(fontSize: 10)),
    );
  }

  pw.Widget _tabelMahasiswa(
    String nama,
    String npm,
    String noTelp,
    String namaPartner,
    String npmPartner,
    String noTelpPartner,
  ) {
    return pw.Table(
      border: pw.TableBorder.all(width: 0.5),
      columnWidths: {
        0: const pw.FixedColumnWidth(25),
        1: const pw.FixedColumnWidth(80),
        2: const pw.FlexColumnWidth(),
        3: const pw.FixedColumnWidth(80),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            _tabelCell('No', bold: true),
            _tabelCell('NPM', bold: true),
            _tabelCell('Nama', bold: true),
            _tabelCell('No Hp', bold: true),
          ],
        ),
        pw.TableRow(
          children: [
            _tabelCell('1.'),
            _tabelCell(npm),
            _tabelCell(nama),
            _tabelCell(noTelp),
          ],
        ),
        pw.TableRow(
          children: [
            _tabelCell('2.'),
            _tabelCell(npmPartner),
            _tabelCell(namaPartner),
            _tabelCell(noTelpPartner),
          ],
        ),
      ],
    );
  }

  pw.Widget _tabelMahasiswaFB(
    String nama,
    String npm,
    String noTelp,
    String namaPartner,
    String npmPartner,
    String noTelpPartner,
  ) {
    return pw.Table(
      border: pw.TableBorder.all(width: 0.5),
      columnWidths: {
        0: const pw.FixedColumnWidth(25),
        1: const pw.FixedColumnWidth(80),
        2: const pw.FlexColumnWidth(),
        3: const pw.FixedColumnWidth(80),
        4: const pw.FixedColumnWidth(80),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            _tabelCell('No', bold: true),
            _tabelCell('NPM', bold: true),
            _tabelCell('Nama', bold: true),
            _tabelCell('No HP', bold: true),
            _tabelCell('ID FB', bold: true),
          ],
        ),
        pw.TableRow(
          children: [
            _tabelCell('1.'),
            _tabelCell(npm),
            _tabelCell(nama),
            _tabelCell(noTelp),
            _tabelCell(nama),
          ],
        ),
        pw.TableRow(
          children: [
            _tabelCell('2.'),
            _tabelCell(npmPartner),
            _tabelCell(namaPartner),
            _tabelCell(noTelpPartner),
            _tabelCell(namaPartner),
          ],
        ),
      ],
    );
  }

  pw.Widget _tabelCell(String text, {bool bold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 9,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  pw.Widget _ttdBagian(String tanggal, String nama, String namaPartner) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Center(
          child: pw.Text(
            'Ternate, $tanggal',
            style: const pw.TextStyle(fontSize: 10),
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Menyetujui,', style: const pw.TextStyle(fontSize: 10)),
                pw.Text(
                  'Koord. Kerja Praktek',
                  style: const pw.TextStyle(fontSize: 10),
                ),
                pw.SizedBox(height: 40),
                pw.Text(
                  'Yasir Muin, S.T., M.Kom.',
                  style: pw.TextStyle(
                    fontSize: 10,
                    decoration: pw.TextDecoration.underline,
                  ),
                ),
                pw.Text(
                  'NIDN. 9990582796',
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Pemohon', style: const pw.TextStyle(fontSize: 10)),
                pw.SizedBox(height: 6),
                pw.Table(
                  border: pw.TableBorder.all(width: 0.5),
                  columnWidths: {
                    0: const pw.FixedColumnWidth(25),
                    1: const pw.FixedColumnWidth(100),
                    2: const pw.FixedColumnWidth(70),
                  },
                  children: [
                    pw.TableRow(
                      decoration: const pw.BoxDecoration(
                        color: PdfColors.grey300,
                      ),
                      children: [
                        _tabelCell('No', bold: true),
                        _tabelCell('Nama Mahasiswa', bold: true),
                        _tabelCell('Tanda Tangan', bold: true),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        _tabelCell('1.'),
                        _tabelCell(nama),
                        _tabelCell(''),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        _tabelCell('2.'),
                        _tabelCell(namaPartner),
                        _tabelCell(''),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _ttdKoord(String tanggal) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Ternate, $tanggal', style: const pw.TextStyle(fontSize: 10)),
        pw.SizedBox(height: 8),
        pw.Text('Menyetujui,', style: const pw.TextStyle(fontSize: 10)),
        pw.Text(
          'Koord. Kerja Praktek',
          style: const pw.TextStyle(fontSize: 10),
        ),
        pw.SizedBox(height: 40),
        pw.Text(
          'Yasir Muin, S.T., M.Kom.',
          style: pw.TextStyle(
            fontSize: 10,
            decoration: pw.TextDecoration.underline,
          ),
        ),
        pw.Text('NIDN. 9990582796', style: const pw.TextStyle(fontSize: 10)),
      ],
    );
  }
}

// ── Halaman Preview Surat ──
class _PreviewSuratPage extends StatelessWidget {
  final String judul;
  final pw.Widget Function(pw.Context, Uint8List) buildContent;

  const _PreviewSuratPage({required this.judul, required this.buildContent});

  Future<pw.Document> _generatePdf() async {
    final logoData = await rootBundle.load('assets/logo_unkhair.png');
    final logoBytes = logoData.buffer.asUint8List();

    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (ctx) => buildContent(ctx, logoBytes),
      ),
    );
    return doc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F1FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF185FA5),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          judul,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () async {
                final doc = await _generatePdf();
                await Printing.layoutPdf(
                  onLayout: (format) async => doc.save(),
                  name: '$judul.pdf',
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.download_rounded, color: Colors.white, size: 16),
                    SizedBox(width: 6),
                    Text(
                      'Download',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<pw.Document>(
        future: _generatePdf(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF185FA5)),
            );
          }
          return PdfPreview(
            build: (format) => snapshot.data!.save(),
            allowPrinting: false,
            allowSharing: false,
            canChangeOrientation: false,
            canChangePageFormat: false,
            canDebug: false,
            pdfFileName: '$judul.pdf',
          );
        },
      ),
    );
  }
}
